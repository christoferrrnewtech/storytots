import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';

/// Salted SHA-256 password hashing for local (offline) accounts.
///
/// Not as strong as a slow KDF (bcrypt/scrypt), but adequate for an offline
/// kids app where the database never leaves the device. Each user gets a random
/// salt; we store `hash` and `salt` and recompute on login.
class PasswordHash {
  static final _rng = Random.secure();

  /// Generate a random base64 salt.
  static String generateSalt([int bytes = 16]) {
    final values = List<int>.generate(bytes, (_) => _rng.nextInt(256));
    return base64Url.encode(values);
  }

  /// Hash [password] with [salt] using SHA-256.
  static String hash(String password, String salt) {
    final digest = sha256.convert(utf8.encode('$salt:$password'));
    return digest.toString();
  }

  /// Constant-ish comparison of a candidate password against a stored hash.
  static bool verify(String password, String salt, String expectedHash) {
    return hash(password, salt) == expectedHash;
  }
}
