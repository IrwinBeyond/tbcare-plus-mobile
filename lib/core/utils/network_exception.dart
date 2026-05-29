import 'dart:async';
import 'dart:io';

/// What kind of network failure occurred. Useful for choosing icons, retry
/// behavior, or whether to offer a "log in again" CTA.
enum NetworkErrorType { timeout, offline, http, format, unauthorized, server, unknown }

/// A normalized network failure with a user-facing Indonesian message.
/// API layer wraps any raw exception in this type so UI code can render a
/// consistent error state without knowing the underlying transport.
class NetworkException implements Exception {
  final String userMessage;
  final NetworkErrorType type;
  final int? statusCode;

  NetworkException(this.userMessage, this.type, {this.statusCode});

  /// Map any caught error to a user-friendly NetworkException.
  ///
  /// Preserves any existing NetworkException unchanged. For raw transport
  /// errors, picks an Indonesian copy that tells the user what to do next.
  static NetworkException from(Object e) {
    if (e is NetworkException) return e;
    if (e is TimeoutException) {
      return NetworkException(
        'Server tidak merespons. Coba lagi sebentar.',
        NetworkErrorType.timeout,
      );
    }
    if (e is SocketException) {
      return NetworkException(
        'Tidak dapat terhubung ke server. Periksa koneksi internet Anda.',
        NetworkErrorType.offline,
      );
    }
    if (e is HttpException) {
      return NetworkException(
        'Terjadi kesalahan jaringan. Coba lagi.',
        NetworkErrorType.http,
      );
    }
    if (e is FormatException) {
      return NetworkException(
        'Respons server tidak valid.',
        NetworkErrorType.format,
      );
    }
    // Strip "Exception: " prefix from Dart's default toString
    final raw = e.toString().replaceFirst('Exception: ', '');
    return NetworkException(raw, NetworkErrorType.unknown);
  }

  /// Wraps an async block so the call site can write `try` and only worry
  /// about `NetworkException`. Use sparingly — only when a single block is
  /// the whole request lifecycle.
  static Future<T> guard<T>(Future<T> Function() body) async {
    try {
      return await body();
    } catch (e) {
      throw NetworkException.from(e);
    }
  }

  @override
  String toString() => userMessage;
}
