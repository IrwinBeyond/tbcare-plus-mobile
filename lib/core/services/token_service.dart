import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/app_constants.dart';
import '../models/auth_models.dart';
import 'storage_service.dart';

/// Renews the access token using the stored refresh token via the backend
/// `/api/v1/auth/refresh` endpoint.
///
/// Refreshes are single-flighted: concurrent callers (e.g. a screen firing
/// several authenticated requests at once) await one shared refresh. This
/// matters because Supabase rotates the refresh token on each use, so parallel
/// refreshes with the same (now-consumed) token would fail.
class TokenService {
  static Future<bool>? _inFlight;

  /// Proactively refreshes if the access token is expired (or about to be),
  /// otherwise does nothing. Returns false only when a needed refresh failed.
  static Future<bool> ensureFreshToken() async {
    if (await StorageService.isAccessTokenExpired()) {
      return refresh();
    }
    return true;
  }

  /// Forces a refresh, coalescing into any in-flight refresh. Returns true on
  /// success (new tokens persisted), false otherwise.
  static Future<bool> refresh() {
    return _inFlight ??= _performRefresh().whenComplete(() => _inFlight = null);
  }

  static Future<bool> _performRefresh() async {
    final refreshToken = await StorageService.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) return false;

    try {
      final response = await http
          .post(
            Uri.parse(AppConstants.authRefresh),
            headers: const {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({'refreshToken': refreshToken}),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode != 200) return false;

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final data = json['data'] as Map<String, dynamic>?;
      if (data == null) return false;

      final auth = AuthResponse.fromJson(data);
      await StorageService.saveTokens(
        accessToken: auth.accessToken,
        refreshToken: auth.refreshToken,
        expiresIn: auth.expiresIn,
      );
      await StorageService.saveUser(auth.user);
      return true;
    } catch (_) {
      return false;
    }
  }
}
