import 'dart:convert';

import 'package:sqflite/sqflite.dart';

import '../local/app_database.dart';
import '../local/session_service.dart';

class Progress {
  final String userId;
  final String storyId;
  final String? pageId;
  final int sentenceIndex;
  final bool isCompleted;
  final DateTime updatedAt;
  final Map<String, dynamic>? meta;

  Progress({
    required this.userId,
    required this.storyId,
    this.pageId,
    required this.sentenceIndex,
    required this.isCompleted,
    required this.updatedAt,
    this.meta,
  });

  Map<String, dynamic> toJson() => {
    'user_id': userId,
    'story_id': storyId,
    'page_id': pageId,
    'sentence_index': sentenceIndex,
    'is_completed': isCompleted,
    'updated_at': updatedAt.toIso8601String(),
    'meta': meta,
  };

  factory Progress.fromJson(Map<String, dynamic> m) => Progress(
    userId: m['user_id'] as String,
    storyId: m['story_id'] as String,
    pageId: (m['page_id'] as String?)?.isEmpty == true
        ? null
        : m['page_id'] as String?,
    sentenceIndex: (m['sentence_index'] as num).toInt(),
    isCompleted: (m['is_completed'] is bool)
        ? m['is_completed'] as bool
        : ((m['is_completed'] as num?)?.toInt() ?? 0) == 1,
    updatedAt: DateTime.parse(m['updated_at'] as String),
    meta: _decodeMeta(m['meta']),
  );

  static Map<String, dynamic>? _decodeMeta(dynamic raw) {
    if (raw == null) return null;
    if (raw is Map) return raw.cast<String, dynamic>();
    if (raw is String && raw.isNotEmpty) {
      try {
        final d = jsonDecode(raw);
        if (d is Map) return d.cast<String, dynamic>();
      } catch (_) {}
    }
    return null;
  }
}

/// Per-page reading progress, stored locally in the SQLite `reading_progress`
/// table. There is no server: the old `*ServerProgress` / sync-queue methods are
/// kept as no-ops so existing callers don't need to change.
class ProgressRepository {
  Future<Database> get _db async => AppDatabase.instance.db;
  String? get _uid => SessionService.instance.currentUserId;

  Future<Progress?> getLocalProgress(String storyId, {String? pageId}) async {
    final uid = _uid;
    if (uid == null) return null;
    final db = await _db;
    final rows = await db.query(
      'reading_progress',
      where: 'user_id = ? AND story_id = ? AND page_id = ?',
      whereArgs: [uid, storyId, pageId ?? ''],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return Progress.fromJson(rows.first);
  }

  Future<void> saveLocalProgress(Progress p) async {
    final db = await _db;
    await db.insert('reading_progress', {
      'user_id': p.userId,
      'story_id': p.storyId,
      'page_id': p.pageId ?? '',
      'sentence_index': p.sentenceIndex,
      'is_completed': p.isCompleted ? 1 : 0,
      'updated_at': p.updatedAt.toIso8601String(),
      'meta': p.meta == null ? null : jsonEncode(p.meta),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  /// No server in offline mode — kept for call-site compatibility.
  Future<void> enqueueForSync(Progress p) async {}

  /// No server in offline mode — kept for call-site compatibility.
  Future<void> flushPendingProgress() async {}

  /// No server in offline mode — local store is the source of truth.
  Future<Progress?> fetchServerProgress(String storyId, {String? pageId}) async {
    return null;
  }

  Future<void> upsertServerProgress(Progress p) async {
    await saveLocalProgress(p);
  }
}
