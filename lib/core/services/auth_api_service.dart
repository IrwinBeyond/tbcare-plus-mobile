import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../constants/app_constants.dart';
import '../models/auth_models.dart';
import '../utils/network_exception.dart';
import 'authorized_client.dart';
import 'storage_service.dart';

class AuthApiService {
  static const _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // ── Register ──────────────────────────────────────────────────────────
  static Future<AuthResponse> register({
    required String email,
    required String password,
    String? nickname,
  }) async {
    final body = jsonEncode({
      'email': email,
      'password': password,
      if (nickname != null && nickname.isNotEmpty) 'nickname': nickname,
    });

    try {
      final response = await http
          .post(
            Uri.parse(AppConstants.authRegister),
            headers: _headers,
            body: body,
          )
          .timeout(const Duration(seconds: 30));

      return _handleAuthResponse(response);
    } on TimeoutException {
      throw Exception(
        'Server tidak merespons. Pastikan backend sedang berjalan.',
      );
    } on SocketException {
      throw Exception(
        'Tidak dapat terhubung ke server. Periksa koneksi internet Anda.',
      );
    } on HttpException {
      throw Exception('Terjadi kesalahan jaringan. Coba lagi.');
    } on FormatException {
      throw Exception('Respons server tidak valid.');
    }
  }

  // ── Login ─────────────────────────────────────────────────────────────
  static Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    final body = jsonEncode({'email': email, 'password': password});

    try {
      final response = await http
          .post(
            Uri.parse(AppConstants.authLogin),
            headers: _headers,
            body: body,
          )
          .timeout(const Duration(seconds: 30));

      return _handleAuthResponse(response);
    } on TimeoutException {
      throw Exception(
        'Server tidak merespons. Pastikan backend sedang berjalan.',
      );
    } on SocketException {
      throw Exception(
        'Tidak dapat terhubung ke server. Periksa koneksi internet Anda.',
      );
    } on HttpException {
      throw Exception('Terjadi kesalahan jaringan. Coba lagi.');
    } on FormatException {
      throw Exception('Respons server tidak valid.');
    }
  }

  // ── Fetch Current User (Profile) ──────────────────────────────────────
  static Future<UserModel> fetchCurrentUser() async {
    try {
      final response = await AuthorizedClient.get(
        Uri.parse(AppConstants.usersMe),
        timeout: const Duration(seconds: 30),
      );

      final json = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        final data = json['data'] as Map<String, dynamic>;
        final user = UserModel.fromJson(data);
        await StorageService.saveUser(
          user,
        ); // Cache updated user profile locally
        return user;
      }

      final message = json['message'] as String? ?? 'Gagal memuat profil.';
      throw Exception(message);
    } on TimeoutException {
      throw Exception(
        'Server tidak merespons. Pastikan backend sedang berjalan.',
      );
    } on SocketException {
      throw Exception(
        'Tidak dapat terhubung ke server. Periksa koneksi internet Anda.',
      );
    } on HttpException {
      throw Exception('Terjadi kesalahan jaringan. Coba lagi.');
    } on FormatException {
      throw Exception('Respons server tidak valid.');
    }
  }

  // ── Update Profile ─────────────────────────────────────────────────────
  static Future<void> updateProfile({
    String? nickname,
    String? profilePicture,
  }) async {
    final body = <String, dynamic>{};
    if (nickname != null) body['nickname'] = nickname;
    if (profilePicture != null) body['profilePicture'] = profilePicture;

    // Picture uploads can take a while on slow networks even after
    // client-side compression. Caller catches TimeoutException to verify
    // server-side state before reporting failure.
    final timeout = profilePicture != null
        ? const Duration(seconds: 60)
        : const Duration(seconds: 15);

    try {
      final response = await AuthorizedClient.put(
        Uri.parse(AppConstants.usersUpdateMe),
        body: jsonEncode(body),
        timeout: timeout,
      );

      if (response.statusCode == 413) {
        throw Exception(
          'Gambar terlalu besar untuk diunggah. Coba pilih gambar yang lebih kecil.',
        );
      }

      if (response.statusCode != 200) {
        try {
          final json = jsonDecode(response.body) as Map<String, dynamic>;
          final message =
              (json['message'] as String?) ?? 'Gagal memperbarui profil.';
          throw Exception(message);
        } catch (e) {
          if (e is Exception) rethrow;
          throw Exception('Gagal memperbarui profil.');
        }
      }
    } on SocketException {
      throw Exception(
        'Tidak dapat terhubung ke server. Periksa koneksi internet Anda.',
      );
    } on HttpException {
      throw Exception('Terjadi kesalahan jaringan. Coba lagi.');
    } on FormatException {
      throw Exception('Respons server tidak valid.');
    }
  }

  // ── Change Password ──────────────────────────────────────────────────
  static Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    final body = jsonEncode({
      'currentPassword': currentPassword,
      'newPassword': newPassword,
      'confirmPassword': confirmPassword,
    });

    try {
      final response = await AuthorizedClient.post(
        Uri.parse(AppConstants.authChangePassword),
        body: body,
        timeout: const Duration(seconds: 15),
      );

      if (response.statusCode != 200) {
        String message = 'Gagal mengubah kata sandi.';
        try {
          final json = jsonDecode(response.body) as Map<String, dynamic>;
          final m = json['message'];
          if (m is String && m.isNotEmpty) message = _localizePasswordError(m);
        } catch (_) {}
        final type = response.statusCode >= 500
            ? NetworkErrorType.server
            : NetworkErrorType.http;
        throw NetworkException(message, type, statusCode: response.statusCode);
      }
    } on TimeoutException {
      throw NetworkException(
        'Server tidak merespons. Coba lagi sebentar.',
        NetworkErrorType.timeout,
      );
    } on SocketException {
      throw NetworkException(
        'Tidak dapat terhubung ke server. Periksa koneksi internet Anda.',
        NetworkErrorType.offline,
      );
    } on HttpException {
      throw NetworkException(
        'Terjadi kesalahan jaringan. Coba lagi.',
        NetworkErrorType.http,
      );
    } on FormatException {
      throw NetworkException(
        'Respons server tidak valid.',
        NetworkErrorType.format,
      );
    }
  }

  /// Maps known Supabase password-error messages (which the backend forwards
  /// verbatim) to Indonesian copy. Anything else passes through unchanged.
  static String _localizePasswordError(String raw) {
    final lower = raw.toLowerCase();
    if (lower.contains('different from the old password') ||
        lower.contains('should be different')) {
      return 'Kata sandi baru harus berbeda dari kata sandi lama.';
    }
    if (lower.contains('password should be at least')) {
      return 'Kata sandi terlalu pendek.';
    }
    if (lower.contains('weak password')) {
      return 'Kata sandi terlalu mudah ditebak. Gunakan kombinasi huruf, angka, dan simbol.';
    }
    return raw;
  }

  // ── Logout ────────────────────────────────────────────────────────────
  static Future<void> logout() async {
    await StorageService.clear();
  }

  // ── Private Helper ────────────────────────────────────────────────────
  static AuthResponse _handleAuthResponse(http.Response response) {
    final json = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = json['data'] as Map<String, dynamic>;
      return AuthResponse.fromJson(data);
    }

    // Extract error message from backend ApiResponse shape
    final message = json['message'] as String? ?? 'Terjadi kesalahan.';
    final errors = (json['errors'] as List?)?.cast<String>();
    final detail = errors != null && errors.isNotEmpty
        ? '$message\n${errors.join('\n')}'
        : message;

    throw Exception(detail);
  }
}
