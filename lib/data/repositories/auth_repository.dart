import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

import '../local/app_database.dart';
import '../local/password_hash.dart';
import '../local/session_service.dart';

/// Thrown for expected auth problems (duplicate email, bad credentials).
class AuthException implements Exception {
  final String message;
  AuthException(this.message);
  @override
  String toString() => message;
}

/// Local (offline) account management backed by the SQLite `users` table.
/// Replaces Supabase Auth. On success the signed-in user id is stored in
/// [SessionService].
class AuthRepository {
  static const _uuid = Uuid();

  Future<Database> get _db async => AppDatabase.instance.db;

  /// Create a new local account and its profile row, then sign in.
  Future<void> signUp({
    required String email,
    required String password,
    String? firstName,
    String? lastName,
    DateTime? birthDate,
  }) async {
    final db = await _db;
    final normalizedEmail = email.trim().toLowerCase();

    final existing = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [normalizedEmail],
      limit: 1,
    );
    if (existing.isNotEmpty) {
      throw AuthException('An account with this email already exists.');
    }

    final id = _uuid.v4();
    final salt = PasswordHash.generateSalt();
    final now = DateTime.now().toIso8601String();

    await db.insert('users', {
      'id': id,
      'email': normalizedEmail,
      'password_hash': PasswordHash.hash(password, salt),
      'password_salt': salt,
      'created_at': now,
    });

    final birthStr = birthDate?.toIso8601String().split('T').first;
    await db.insert('profiles', {
      'id': id,
      'email': normalizedEmail,
      'first_name': firstName,
      'last_name': lastName,
      'birth_date': birthStr,
      'onboarding_complete': 0,
    }, conflictAlgorithm: ConflictAlgorithm.replace);

    await SessionService.instance.setUser(id);
  }

  /// Verify credentials against the local store and sign in.
  Future<void> signIn(String email, String password) async {
    final db = await _db;
    final normalizedEmail = email.trim().toLowerCase();

    final rows = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [normalizedEmail],
      limit: 1,
    );
    if (rows.isEmpty) {
      throw AuthException('No account found for this email.');
    }

    final user = rows.first;
    final salt = user['password_salt'] as String;
    final expected = user['password_hash'] as String;
    if (!PasswordHash.verify(password, salt, expected)) {
      throw AuthException('Incorrect email or password.');
    }

    await SessionService.instance.setUser(user['id'] as String);
  }

  Future<void> signOut() => SessionService.instance.clear();
}
