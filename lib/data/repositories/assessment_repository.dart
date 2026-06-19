import 'package:sqflite/sqflite.dart';

import '../local/app_database.dart';
import '../local/session_service.dart';

/// Tracks which stories the child has completed, in the SQLite
/// `completed_stories` table.
class AssessmentRepository {
  Future<Database> get _db async => AppDatabase.instance.db;
  String? get _uid => SessionService.instance.currentUserId;

  Future<List<String>> getCompletedStoryIds() async {
    final uid = _uid;
    if (uid == null) return [];
    final db = await _db;
    final rows = await db.query(
      'completed_stories',
      columns: ['story_id'],
      where: 'user_id = ?',
      whereArgs: [uid],
    );
    return rows.map((r) => r['story_id'] as String).toList();
  }

  Future<void> addCompletedStory(String storyId) async {
    final uid = _uid;
    if (uid == null) return;
    final db = await _db;
    await db.insert('completed_stories', {
      'user_id': uid,
      'story_id': storyId,
      'completed_at': DateTime.now().toIso8601String(),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> removeCompletedStory(String storyId) async {
    final uid = _uid;
    if (uid == null) return;
    final db = await _db;
    await db.delete(
      'completed_stories',
      where: 'user_id = ? AND story_id = ?',
      whereArgs: [uid, storyId],
    );
  }
}
