import 'package:flutter/services.dart' show rootBundle;
import 'package:sqflite/sqflite.dart';

import '../local/app_database.dart';
import '../local/session_service.dart';
import '../stories_index.dart';

class Story {
  final String id;
  final String title;
  final String language;
  final List<String> topics;
  final String? readingAge;

  // details (optional)
  final String? coverUrl;
  final String? synopsis;
  final String? writtenBy;
  final String? illustratedBy;
  final String? publishedBy;

  Story({
    required this.id,
    required this.title,
    required this.language,
    required this.topics,
    this.readingAge,
    this.coverUrl,
    this.synopsis,
    this.writtenBy,
    this.illustratedBy,
    this.publishedBy,
  });

  factory Story.fromMap(Map<String, dynamic> m) {
    return Story(
      id: m['id'] as String,
      title: (m['title'] ?? '') as String,
      language: (m['language'] ?? 'en') as String,
      topics: (m['topics'] as List?)?.whereType<String>().toList() ?? const [],
      readingAge: m['reading_age'] as String?,
      coverUrl: m['cover_url'] as String?,
      synopsis: m['synopsis'] as String?,
      writtenBy: m['written_by'] as String?,
      illustratedBy: m['illustrated_by'] as String?,
      publishedBy: m['published_by'] as String?,
    );
  }

  factory Story.fromJson(Map<String, dynamic> json) => Story.fromMap(json);
}

/// Offline story catalog. The catalog itself comes from the bundled
/// [StoriesIndex] (asset files); only the per-user `reading_history` lives in
/// SQLite. `Story.id` is the story `slug`.
class StoriesRepository {
  Future<Database> get _db async => AppDatabase.instance.db;

  /// Canonical (English-preferred) index entry per slug.
  StoryIndexItem? _canonicalForSlug(String slug) {
    StoryIndexItem? fallback;
    for (final item in StoriesIndex.items) {
      if (item.slug == slug) {
        if (item.language == 'en') return item;
        fallback ??= item;
      }
    }
    return fallback;
  }

  Iterable<StoryIndexItem> _canonicalItems() {
    final seen = <String>{};
    final out = <StoryIndexItem>[];
    for (final item in StoriesIndex.items) {
      if (seen.add(item.slug)) {
        out.add(_canonicalForSlug(item.slug) ?? item);
      }
    }
    return out;
  }

  Story _storyFromItem(StoryIndexItem item, {String? synopsis}) {
    return Story(
      id: item.slug,
      title: item.title,
      language: item.language,
      topics: item.topics,
      coverUrl: item.coverAsset,
      synopsis: synopsis,
    );
  }

  Future<String?> _loadSynopsis(StoryIndexItem item) async {
    try {
      return await rootBundle.loadString(item.synopsisPath);
    } catch (_) {
      return null;
    }
  }

  Future<List<Story>> listByTopic(String topic, {int limit = 6}) async {
    final matches = _canonicalItems()
        .where((i) => i.topics.contains(topic))
        .take(limit)
        .map((i) => _storyFromItem(i))
        .toList();
    return matches;
  }

  Future<Story?> getById(String id) async {
    final item = _canonicalForSlug(id);
    if (item == null) return null;
    final synopsis = await _loadSynopsis(item);
    return _storyFromItem(item, synopsis: synopsis);
  }

  /// Returns stories the user has opened, oldest -> newest (FIFO).
  Future<List<Story>> listReadingHistory({int limit = 6}) async {
    final uid = SessionService.instance.currentUserId;
    if (uid == null) return [];

    final db = await _db;
    final rows = await db.query(
      'reading_history',
      where: 'user_id = ?',
      whereArgs: [uid],
      orderBy: 'last_read_at ASC',
      limit: limit,
    );

    final stories = <Story>[];
    for (final r in rows) {
      final item = _canonicalForSlug(r['story_id'] as String);
      if (item != null) stories.add(_storyFromItem(item));
    }
    return stories;
  }

  /// Record/refresh that a story was opened.
  Future<void> touchReadingHistory(String storyId) async {
    final uid = SessionService.instance.currentUserId;
    if (uid == null) return;
    final db = await _db;
    await db.insert('reading_history', {
      'user_id': uid,
      'story_id': storyId,
      'last_read_at': DateTime.now().toIso8601String(),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  /// All stories in the bundled catalog (one entry per slug).
  Future<List<Story>> listAll() async {
    return _canonicalItems().map((i) => _storyFromItem(i)).toList();
  }

  Future<List<Story>> listByIds(List<String> ids) async {
    if (ids.isEmpty) return [];
    final out = <Story>[];
    for (final id in ids) {
      final item = _canonicalForSlug(id);
      if (item != null) out.add(_storyFromItem(item));
    }
    return out;
  }
}
