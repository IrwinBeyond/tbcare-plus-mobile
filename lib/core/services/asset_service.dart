import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';

class AssetService {
  static final Map<String, ImageProvider> _cache = {};

  static ImageProvider profileImage(String url) {
    if (_cache.containsKey(url)) return _cache[url]!;
    ImageProvider provider;
    if (url.startsWith('data:')) {
      final comma = url.indexOf(',');
      provider = MemoryImage(base64Decode(url.substring(comma + 1)));
    } else {
      provider = NetworkImage(url);
    }
    _cache[url] = provider;
    return provider;
  }
}
