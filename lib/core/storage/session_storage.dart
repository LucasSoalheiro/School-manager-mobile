import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/api_constants.dart';

class SessionStorage {
  static const String _keyToken = 'auth_token';
  static const String _keyUser = 'auth_user';
  static const String _keyBaseUrl = 'custom_base_url';

  final SharedPreferences _prefs;

  SessionStorage(this._prefs);

  static Future<SessionStorage> init() async {
    final prefs = await SharedPreferences.getInstance();
    return SessionStorage(prefs);
  }

  // Token JWT
  String? getToken() => _prefs.getString(_keyToken);

  Future<void> saveToken(String token) async {
    await _prefs.setString(_keyToken, token);
  }

  // User session
  Map<String, dynamic>? getUser() {
    final raw = _prefs.getString(_keyUser);
    if (raw == null) return null;
    try {
      return jsonDecode(raw) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  Future<void> saveUser(Map<String, dynamic> userJson) async {
    await _prefs.setString(_keyUser, jsonEncode(userJson));
  }

  String? getUserRole() {
    final user = getUser();
    return user?['role'] as String?;
  }

  String? getUserId() {
    final user = getUser();
    return user?['id'] as String?;
  }

  // Custom Base URL
  String getBaseUrl() {
    return _prefs.getString(_keyBaseUrl) ?? ApiConstants.defaultBaseUrl;
  }

  Future<void> saveBaseUrl(String url) async {
    final sanitized = url.endsWith('/') ? url.substring(0, url.length - 1) : url;
    await _prefs.setString(_keyBaseUrl, sanitized);
  }

  bool isLoggedIn() {
    return getToken() != null && getUser() != null;
  }

  Future<void> clearSession() async {
    await _prefs.remove(_keyToken);
    await _prefs.remove(_keyUser);
  }
}
