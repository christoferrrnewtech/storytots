import 'package:sqflite/sqflite.dart';

import '../local/app_database.dart';
import '../local/session_service.dart';

class LibraryEntry {
  final String storyId;
  final String? storyTitle;
  final String? coverUrl;
  final bool isFavorite;
  final DateTime? lastOpened;

  LibraryEntry({
    required this.storyId,
    this.storyTitle,
    this.coverUrl,
    required this.isFavorite,
    this.lastOpened,
  });

  factory LibraryEntry.fromMap(Map<String, dynamic> m) => LibraryEntry(
    storyId: m['story_id'] as String,
    storyTitle: m['story_title'] as String?,
    coverUrl: m['cover_url'] as String?,
    isFavorite: ((m['is_favorite'] as int?) ?? 0) == 1,
    lastOpened: m['last_opened'] != null
        ? DateTime.tryParse(m['last_opened'] as String)
        : null,
  );
}

/// User library (favorites + recently opened), stored locally in SQLite.
class LibraryRepository {
  static const _table = 'library';

  Future<Database> get _db async => AppDatabase.instance.db;
  String? get _uid => SessionService.instance.currentUserId;

  Future<void> recordOpen({
    required String storyId,
    required String title,
    String? coverUrl,
  }) async {
    final uid = _uid;
    if (uid == null) return;
    final db = await _db;
    // Preserve existing is_favorite by merging onto any existing row.
    final existing = await getByStoryId(storyId);
    await db.insert(_table, {
      'user_id': uid,
      'story_id': storyId,
      'story_title': title,
      'cover_url': coverUrl,
      'is_favorite': (existing?.isFavorite ?? false) ? 1 : 0,
      'last_opened': DateTime.now().toIso8601String(),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> ensureRow({
    required String storyId,
    required String title,
    String? coverUrl,
  }) async {
    final uid = _uid;
    if (uid == null) return;
    final existing = await getByStoryId(storyId);
    if (existing != null) return; // don't clobber favorite/last_opened
    final db = await _db;
    await db.insert(_table, {
      'user_id': uid,
      'story_id': storyId,
      'story_title': title,
      'cover_url': coverUrl,
      'is_favorite': 0,
    }, conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<LibraryEntry?> getByStoryId(String storyId) async {
    final uid = _uid;
    if (uid == null) return null;
    final db = await _db;
    final rows = await db.query(
      _table,
      where: 'user_id = ? AND story_id = ?',
      whereArgs: [uid, storyId],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return LibraryEntry.fromMap(rows.first);
  }

  Future<void> toggleFavorite(String storyId, bool makeFavorite) async {
    final uid = _uid;
    if (uid == null) return;
    final db = await _db;
    await db.update(
      _table,
      {'is_favorite': makeFavorite ? 1 : 0},
      where: 'user_id = ? AND story_id = ?',
      whereArgs: [uid, storyId],
    );
  }

  Future<List<LibraryEntry>> listAll() async {
    final uid = _uid;
    if (uid == null) return [];
    final db = await _db;
    final rows = await db.query(
      _table,
      where: 'user_id = ?',
      whereArgs: [uid],
      orderBy: 'story_title ASC',
    );
    return rows.map((m) => LibraryEntry.fromMap(m)).toList();
  }

  Future<List<LibraryEntry>> listFavorites() async {
    final uid = _uid;
    if (uid == null) return [];
    final db = await _db;
    final rows = await db.query(
      _table,
      where: 'user_id = ? AND is_favorite = 1',
      whereArgs: [uid],
      orderBy: 'story_title ASC',
    );
    return rows.map((m) => LibraryEntry.fromMap(m)).toList();
  }

  Future<List<LibraryEntry>> listHistory() async {
    final uid = _uid;
    if (uid == null) return [];
    final db = await _db;
    final rows = await db.query(
      _table,
      where: 'user_id = ?',
      whereArgs: [uid],
      orderBy: 'last_opened DESC',
    );
    return rows.map((m) => LibraryEntry.fromMap(m)).toList();
  }
}
