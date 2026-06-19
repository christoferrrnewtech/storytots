import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

import '../local/app_database.dart';
import '../local/session_service.dart';
import '../supabase/tables/profile.dart';

/// Child profile data, stored locally in the SQLite `profiles` table.
class ProfileRepository {
  static const _table = 'profiles';

  /// Broadcasts the current avatar key so the UI (e.g. Home AppBar) can update
  /// instantly when the avatar changes — replaces the old Supabase realtime
  /// stream.
  static final ValueNotifier<String?> avatarNotifier = ValueNotifier<String?>(
    null,
  );

  Future<Database> get _db async => AppDatabase.instance.db;
  String? get _uid => SessionService.instance.currentUserId;

  Future<Profile?> getMyProfile() async {
    final uid = _uid;
    if (uid == null) return null;

    final db = await _db;
    final rows = await db.query(
      _table,
      where: 'id = ?',
      whereArgs: [uid],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return Profile.fromMap(_decodeOnboarding(rows.first));
  }

  Future<void> ensureRowExists({
    String? email,
    String? first,
    String? last,
    DateTime? birth,
  }) async {
    final uid = _uid;
    if (uid == null) return;

    final db = await _db;
    final existing = await db.query(
      _table,
      columns: ['id'],
      where: 'id = ?',
      whereArgs: [uid],
      limit: 1,
    );
    if (existing.isEmpty) {
      final birthStr = birth?.toIso8601String().split('T').first;
      await db.insert(_table, {
        'id': uid,
        'email': email,
        'first_name': first,
        'last_name': last,
        'birth_date': birthStr,
        'onboarding_complete': 0,
      }, conflictAlgorithm: ConflictAlgorithm.ignore);
    }
  }

  Future<void> updateInterests(List<String> topics) async {
    await _update({'interests': jsonEncode(topics)});
  }

  Future<void> updateGoal(String goal) async {
    await _update({'goal': goal});
  }

  Future<void> updateAvatar(String avatarKey) async {
    await _update({'avatar_key': avatarKey});
    avatarNotifier.value = avatarKey;
  }

  Future<void> setOnboardingComplete(bool value) async {
    await _update({'onboarding_complete': value ? 1 : 0});
  }

  Future<Map<String, dynamic>?> getMyProfileRaw() async {
    final uid = _uid;
    if (uid == null) return null;
    final db = await _db;
    final rows = await db.query(
      _table,
      where: 'id = ?',
      whereArgs: [uid],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return _decodeOnboarding(rows.first);
  }

  Future<void> _update(Map<String, Object?> values) async {
    final uid = _uid;
    if (uid == null) return;
    final db = await _db;
    await db.update(_table, values, where: 'id = ?', whereArgs: [uid]);
  }

  /// Normalize the SQLite `onboarding_complete` int back to a bool-ish value
  /// that the rest of the app can read. (Profile.onboardingComplete is derived
  /// from goal/interests/avatar, so this is mainly for `getMyProfileRaw`.)
  Map<String, dynamic> _decodeOnboarding(Map<String, Object?> row) {
    final m = Map<String, dynamic>.from(row);
    if (m['onboarding_complete'] is int) {
      m['onboarding_complete'] = (m['onboarding_complete'] as int) == 1;
    }
    return m;
  }
}
