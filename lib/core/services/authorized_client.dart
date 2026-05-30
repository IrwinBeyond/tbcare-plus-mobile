import 'dart:async';
import 'package:http/http.dart' as http;
import '../utils/network_exception.dart';
import 'session_service.dart';
import 'storage_service.dart';
import 'token_service.dart';

/// HTTP wrapper for authenticated requests. Attaches the Bearer token,
/// refreshes proactively when the access token is near expiry, and on a 401
/// transparently refreshes and retries the request once. If the refresh itself
/// fails (revoked/expired refresh token), it logs the user out and throws an
/// unauthorized [NetworkException].
///
/// Transport errors (Timeout/Socket/Format) are NOT caught here — they
/// propagate so each caller keeps its own exception mapping.
class AuthorizedClient {
  static Future<http.Response> get(
    Uri url, {
    Map<String, String>? headers,
    Duration timeout = const Duration(seconds: 15),
  }) {
    return _send(
      (h) => http.get(url, headers: h).timeout(timeout),
      headers,
    );
  }

  static Future<http.Response> post(
    Uri url, {
    Object? body,
    Map<String, String>? headers,
    Duration timeout = const Duration(seconds: 30),
  }) {
    return _send(
      (h) => http.post(url, headers: h, body: body).timeout(timeout),
      headers,
      jsonContentType: true,
    );
  }

  static Future<http.Response> put(
    Uri url, {
    Object? body,
    Map<String, String>? headers,
    Duration timeout = const Duration(seconds: 15),
  }) {
    return _send(
      (h) => http.put(url, headers: h, body: body).timeout(timeout),
      headers,
      jsonContentType: true,
    );
  }

  static Future<http.Response> _send(
    Future<http.Response> Function(Map<String, String> headers) request,
    Map<String, String>? extraHeaders, {
    bool jsonContentType = false,
  }) async {
    // Proactively renew if the token is expired/near-expiry to avoid a
    // guaranteed 401 round-trip.
    await TokenService.ensureFreshToken();

    var token = await StorageService.getAccessToken();
    if (token == null || token.isEmpty) {
      await SessionService.logoutAndRedirectToLogin();
      throw NetworkException(
        'Sesi login telah berakhir. Silakan login kembali.',
        NetworkErrorType.unauthorized,
        statusCode: 401,
      );
    }

    var response = await request(_headers(token, extraHeaders, jsonContentType));

    // Reactive path: the token was rejected (expired between the proactive
    // check and the request, clock skew, etc.). Refresh once and retry.
    if (response.statusCode == 401) {
      final refreshed = await TokenService.refresh();
      if (refreshed) {
        token = await StorageService.getAccessToken();
        if (token != null && token.isNotEmpty) {
          response = await request(
            _headers(token, extraHeaders, jsonContentType),
          );
        }
      }
    }

    if (response.statusCode == 401) {
      await SessionService.logoutAndRedirectToLogin();
      throw NetworkException(
        'Sesi login telah berakhir. Silakan login kembali.',
        NetworkErrorType.unauthorized,
        statusCode: 401,
      );
    }

    return response;
  }

  static Map<String, String> _headers(
    String token,
    Map<String, String>? extra,
    bool jsonContentType,
  ) {
    return {
      'Accept': 'application/json',
      if (jsonContentType) 'Content-Type': 'application/json',
      ...?extra,
      'Authorization': 'Bearer $token',
    };
  }
}
