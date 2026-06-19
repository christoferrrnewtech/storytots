import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'data/local/app_database.dart';
import 'data/local/session_service.dart';
import 'app.dart';
import 'core/services/sound_service.dart';
import 'core/services/background_music_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Open the local SQLite database (creates tables on first run).
  await AppDatabase.instance.db;

  // Restore persistent local login (no server / offline).
  await SessionService.instance.init();

  await Permission.microphone.request();

  // Prepare global click sound
  await SoundService.instance.init();

  // Prepare background music and start playing softly
  await BackgroundMusicService.instance.init(volume: 0.35);
  await BackgroundMusicService.instance.start();

  runApp(const StoryTotsApp());
}
