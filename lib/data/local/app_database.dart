import 'package:sqflite/sqflite.dart';

import 'db_platform.dart';

/// Local SQLite database for fully-offline StoryTots.
///
/// Replaces the previous Supabase Postgres backend. Holds the local account
/// (`users`), the child `profiles`, and all per-user reading data. The story
/// catalog itself is NOT stored here — it is sourced from the bundled
/// `StoriesIndex` asset list.
class AppDatabase {
  AppDatabase._();
  static final AppDatabase instance = AppDatabase._();

  static const _dbName = 'storytots.db';
  static const _dbVersion = 1;

  Database? _db;

  Future<Database> get db async {
    _db ??= await _open();
    return _db!;
  }

  Future<Database> _open() async {
    return openAppDatabase(
      name: _dbName,
      version: _dbVersion,
      onConfigure: (d) async {
        await d.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database d, int version) async {
    // Local accounts (replaces Supabase Auth).
    await d.execute('''
      CREATE TABLE users (
        id TEXT PRIMARY KEY,
        email TEXT UNIQUE NOT NULL,
        password_hash TEXT NOT NULL,
        password_salt TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');

    // Child profile (one per account).
    await d.execute('''
      CREATE TABLE profiles (
        id TEXT PRIMARY KEY,
        email TEXT,
        first_name TEXT,
        last_name TEXT,
        birth_date TEXT,
        goal TEXT,
        interests TEXT,            -- JSON-encoded List<String>
        avatar_key TEXT,
        onboarding_complete INTEGER NOT NULL DEFAULT 0
      )
    ''');

    // Library / favorites / recently opened.
    await d.execute('''
      CREATE TABLE library (
        user_id TEXT NOT NULL,
        story_id TEXT NOT NULL,
        story_title TEXT,
        cover_url TEXT,
        is_favorite INTEGER NOT NULL DEFAULT 0,
        last_opened TEXT,
        PRIMARY KEY (user_id, story_id)
      )
    ''');

    // Per-page reading position.
    await d.execute('''
      CREATE TABLE reading_progress (
        user_id TEXT NOT NULL,
        story_id TEXT NOT NULL,
        page_id TEXT NOT NULL DEFAULT '',
        sentence_index INTEGER NOT NULL DEFAULT 0,
        is_completed INTEGER NOT NULL DEFAULT 0,
        updated_at TEXT NOT NULL,
        meta TEXT,                 -- JSON-encoded Map
        PRIMARY KEY (user_id, story_id, page_id)
      )
    ''');

    // Reading time segments (for stats).
    await d.execute('''
      CREATE TABLE reading_activity (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id TEXT,
        story_id TEXT,
        language TEXT NOT NULL,
        duration_sec INTEGER NOT NULL,
        started_at TEXT,
        ended_at TEXT,
        day TEXT NOT NULL
      )
    ''');
    await d.execute(
      'CREATE INDEX idx_activity_user_day ON reading_activity(user_id, day)',
    );

    // Completed stories (assessment).
    await d.execute('''
      CREATE TABLE completed_stories (
        user_id TEXT NOT NULL,
        story_id TEXT NOT NULL,
        completed_at TEXT,
        PRIMARY KEY (user_id, story_id)
      )
    ''');

    // Continue-reading history.
    await d.execute('''
      CREATE TABLE reading_history (
        user_id TEXT NOT NULL,
        story_id TEXT NOT NULL,
        last_read_at TEXT NOT NULL,
        PRIMARY KEY (user_id, story_id)
      )
    ''');
  }
}
