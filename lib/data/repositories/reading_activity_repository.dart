import 'package:shared_preferences/shared_preferences.dart';

import '../local/app_database.dart';
import '../local/session_service.dart';

class LanguageStats {
  final int englishMinutes;
  final int filipinoMinutes;
  final int totalMinutes;
  final double activityPercent; // 0..1 against daily goal
  const LanguageStats({
    required this.englishMinutes,
    required this.filipinoMinutes,
    required this.totalMinutes,
    required this.activityPercent,
  });
}

/// Tracks reading time per language. Fully offline: daily aggregates live in
/// SharedPreferences (for fast UI) and each raw segment is also stored in the
/// SQLite `reading_activity` table.
class ReadingActivityRepository {
  static const _aggPrefix = 'reading_minutes:'; // reading_minutes:YYYY-MM-DD:en
  static const int dailyGoalMinutes = 60; // can be adjusted later
  static const _lastSessionKey = 'reading_last_session_at';

  Future<SharedPreferences> get _prefs async => SharedPreferences.getInstance();

  String _dayKey(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  Future<void> addReadingSegment({
    required String lang, // 'en' or 'tl'
    required Duration duration,
    String? storyId,
    DateTime? startedAt,
    DateTime? endedAt,
  }) async {
    // Normalize language
    final language = (lang == 'tl' || lang.toLowerCase() == 'filipino')
        ? 'tl'
        : 'en';
    final seconds = duration.inSeconds;
    if (seconds <= 0) return;

    final now = DateTime.now();
    final day = _dayKey(now);
    final start = (startedAt ?? now.subtract(duration)).toIso8601String();
    final end = (endedAt ?? now).toIso8601String();

    // Persist raw segment to SQLite.
    final db = await AppDatabase.instance.db;
    await db.insert('reading_activity', {
      'user_id': SessionService.instance.currentUserId,
      'story_id': storyId,
      'language': language,
      'duration_sec': seconds,
      'started_at': start,
      'ended_at': end,
      'day': day,
    });

    // Update local daily aggregates for quick UI.
    final prefs = await _prefs;
    final aggKey = '$_aggPrefix$day:$language';
    final current = prefs.getInt(aggKey) ?? 0;
    await prefs.setInt(aggKey, current + seconds);

    // Record last session end time for Profile metrics.
    await prefs.setString(_lastSessionKey, end);
  }

  Future<LanguageStats> getTodayLanguageStats() async {
    final prefs = await _prefs;
    final day = _dayKey(DateTime.now());
    final enSec = prefs.getInt('$_aggPrefix$day:en') ?? 0;
    final tlSec = prefs.getInt('$_aggPrefix$day:tl') ?? 0;
    final totalMin = ((enSec + tlSec) / 60).floor();
    final enMin = (enSec / 60).floor();
    final tlMin = (tlSec / 60).floor();

    final pct = ((enMin + tlMin) / dailyGoalMinutes).clamp(0, 1).toDouble();
    return LanguageStats(
      englishMinutes: enMin,
      filipinoMinutes: tlMin,
      totalMinutes: totalMin,
      activityPercent: pct,
    );
  }

  /// No server in offline mode — kept for call-site compatibility.
  Future<void> flushQueue() async {}
}
