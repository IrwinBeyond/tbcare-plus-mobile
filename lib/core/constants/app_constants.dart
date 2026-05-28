import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb, kDebugMode;

class AppConstants {
  // ── Backend API base URL ─────────────────────────────────────────────
  //
  // Default: Azure App Service (production)
  // Untuk local dev, set USE_LOCAL = true dan jalankan backend via dotnet run.
  static const bool _useLocal = false;
  static const String _prodUrl =
      'https://tbcare-plus-api-cugyfka4fcaedmfp.indonesiacentral-01.azurewebsites.net';
  static const String _localUrl = 'http://localhost:5181';

  static final String baseUrl = () {
    if (_useLocal && kDebugMode) {
      if (kIsWeb) return _localUrl;
      if (Platform.isAndroid && _detectAndroidEmulator())
        return 'http://10.0.2.2:5181';
      return _localUrl;
    }
    return _prodUrl;
  }();

  static bool _detectAndroidEmulator() {
    try {
      return Platform.isAndroid &&
          (Platform.environment.containsKey('ANDROID_EMULATOR') ||
              Platform.localHostname.startsWith('emulator') ||
              Platform.localHostname == 'localhost');
    } catch (_) {
      return false;
    }
  }

  // ── API Paths ────────────────────────────────────────────────────────
  static final String authRegister = '$baseUrl/api/v1/auth/register';
  static final String authLogin = '$baseUrl/api/v1/auth/login';
  static final String usersMe = '$baseUrl/api/v1/auth/me';
  static final String usersUpdateMe = '$baseUrl/api/v1/auth/me';
  static final String quickCheckConfig =
      '$baseUrl/api/v1/assessment/quick-check-config';
  static final String fullAssessmentConfig =
      '$baseUrl/api/v1/assessment/full-assessment-config';
  static final String submitAssessment = '$baseUrl/api/v1/assessment/submit';
  static final String assessmentHistory = '$baseUrl/api/v1/assessment/history';
  static final String assessmentHistorySessions =
      '$baseUrl/api/v1/assessment/history-sessions';
  static String assessmentHistorySessionDetail(String sessionKey) =>
      '$baseUrl/api/v1/assessment/history-sessions/$sessionKey';
  static String assessmentHistoryDetail(int id) =>
      '$baseUrl/api/v1/assessment/history/$id';

  // ── SharedPreferences Keys ───────────────────────────────────────────
  static const String keyAccessToken = 'access_token';
  static const String keyRefreshToken = 'refresh_token';
  static const String keyUser = 'user_json';
  static const String keyGuestAssessment = 'guest_assessment_json';
}
