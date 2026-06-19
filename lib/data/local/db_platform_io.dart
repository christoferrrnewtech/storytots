import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

/// Native (Android/iOS) database opener using the default `sqflite` plugin.
Future<Database> openAppDatabase({
  required String name,
  required int version,
  required Future<void> Function(Database db) onConfigure,
  required Future<void> Function(Database db, int version) onCreate,
}) async {
  final dir = await getDatabasesPath();
  final path = p.join(dir, name);
  return openDatabase(
    path,
    version: version,
    onConfigure: onConfigure,
    onCreate: onCreate,
  );
}
