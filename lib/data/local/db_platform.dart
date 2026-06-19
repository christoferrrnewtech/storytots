// Platform-conditional database opener.
//
// On mobile (Android/iOS) we use the native `sqflite` plugin; on Flutter web we
// use `sqflite_common_ffi_web` (IndexedDB-backed). The correct implementation is
// selected at compile time so web-only / io-only imports never clash.
export 'db_platform_io.dart' if (dart.library.html) 'db_platform_web.dart';
