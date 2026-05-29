import 'dart:typed_data';
import 'package:image/image.dart' as img;

class ImageUtils {
  /// Maximum dimension (px) of the longer edge after resize.
  static const int _maxEdge = 512;

  /// JPEG quality (1-100). 80 is a good balance for profile pictures.
  static const int _jpegQuality = 80;

  /// Decodes the input bytes, downscales the longer edge to [_maxEdge] if
  /// larger, re-encodes as JPEG at [_jpegQuality], and returns the result.
  /// Falls back to the original bytes if decoding fails (caller can still
  /// upload, just larger).
  static Future<Uint8List> resizeForProfilePicture(Uint8List bytes) async {
    final decoded = img.decodeImage(bytes);
    if (decoded == null) return bytes;

    final int longerEdge =
        decoded.width >= decoded.height ? decoded.width : decoded.height;

    final img.Image resized = longerEdge > _maxEdge
        ? img.copyResize(
            decoded,
            width: decoded.width >= decoded.height ? _maxEdge : null,
            height: decoded.height > decoded.width ? _maxEdge : null,
            interpolation: img.Interpolation.linear,
          )
        : decoded;

    return Uint8List.fromList(img.encodeJpg(resized, quality: _jpegQuality));
  }
}
