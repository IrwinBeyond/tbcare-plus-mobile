import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

class UrlUtils {
  static Future<void> launchNearestClinicMap(BuildContext context) async {
    final Uri url = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=Puskesmas+atau+Rumah+Sakit+terdekat',
    );

    try {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tidak dapat membuka peta.')),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Gagal membuka peta.')));
      }
    }
  }
}
