import 'package:shared_preferences/shared_preferences.dart';

/// Tracks which local account is currently signed in.
///
/// Replaces `Supabase.instance.client.auth.currentUser`. The signed-in user id
/// is persisted in SharedPreferences so login survives app restarts (no daily
/// expiry — there is no server to re-validate against offline).
class SessionService {
  SessionService._();
  static final SessionService instance = SessionService._();

  static const _userIdKey = 'auth_user_id';

  String? _currentUserId;

  String? get currentUserId => _currentUserId;
  bool get isLoggedIn => _currentUserId != null;

  /// Load the persisted session id. Call once at startup.
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _currentUserId = prefs.getString(_userIdKey);
  }

  Future<void> setUser(String userId) async {
    _currentUserId = userId;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userIdKey, userId);
  }

  Future<void> clear() async {
    _currentUserId = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userIdKey);
  }
}
