import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';
import '../models/auth_models.dart';

class StorageService {
  static UserModel? _cachedUser;
  static Map<String, dynamic>? lastAssessmentResult;

  static UserModel? get cachedUser => _cachedUser;

  // ── Token ────────────────────────────────────────────────────────────
  static Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.keyAccessToken, accessToken);
    await prefs.setString(AppConstants.keyRefreshToken, refreshToken);
  }

  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConstants.keyAccessToken);
  }

  static Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConstants.keyRefreshToken);
  }

  // ── User ─────────────────────────────────────────────────────────────
  static Future<void> saveUser(UserModel user) async {
    _cachedUser = user;
    final prefs = await SharedPreferences.getInstance();
    // Exclude profilePicture from persistence — data URLs are too large for SharedPreferences
    final lean = user.toJson()..remove('profilePicture');
    await prefs.setString(AppConstants.keyUser, jsonEncode(lean));
  }

  static Future<UserModel?> getUser() async {
    if (_cachedUser != null) return _cachedUser;
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(AppConstants.keyUser);
    if (json == null) return null;
    _cachedUser = UserModel.fromJsonString(json);
    return _cachedUser;
  }

  // ── Clear (logout) ────────────────────────────────────────────────────
  static Future<void> clear() async {
    _cachedUser = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.keyAccessToken);
    await prefs.remove(AppConstants.keyRefreshToken);
    await prefs.remove(AppConstants.keyUser);
  }

  static Future<bool> isLoggedIn() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }
}
