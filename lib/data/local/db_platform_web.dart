import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

/// Flutter web database opener using `sqflite_common_ffi_web` (IndexedDB).
Future<Database> openAppDatabase({
  required String name,
  required int version,
  required Future<void> Function(Database db) onConfigure,
  required Future<void> Function(Database db, int version) onCreate,
}) async {
  // Use the no-shared-worker web factory: runs in the main isolate and only
  // needs `web/sqlite3.wasm` (no generated `sqflite_sw.js` worker).
  databaseFactory = databaseFactoryFfiWebNoWebWorker;
  return databaseFactory.openDatabase(
    name,
    options: OpenDatabaseOptions(
      version: version,
      onConfigure: onConfigure,
      onCreate: onCreate,
    ),
  );
}
