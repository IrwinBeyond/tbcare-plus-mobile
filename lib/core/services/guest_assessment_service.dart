import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

class GuestAssessmentService {
  static Future<void> save(Map<String, dynamic> assessment) async {
    final prefs = await SharedPreferences.getInstance();
    assessment['savedAt'] = DateTime.now().toIso8601String();
    await prefs.setString(
      AppConstants.keyGuestAssessment,
      jsonEncode(assessment),
    );
  }

  static Future<Map<String, dynamic>?> get() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(AppConstants.keyGuestAssessment);
    if (json == null) return null;
    try {
      final decoded = jsonDecode(json);
      if (decoded is Map<String, dynamic>) return decoded;
      // Wrong shape — discard corrupted entry so subsequent reads start clean.
      await prefs.remove(AppConstants.keyGuestAssessment);
      return null;
    } on FormatException {
      // Corrupted JSON (e.g., partial write, app crash mid-save, version
      // mismatch). Drop it so the user can start a fresh assessment.
      await prefs.remove(AppConstants.keyGuestAssessment);
      return null;
    }
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.keyGuestAssessment);
  }
}
