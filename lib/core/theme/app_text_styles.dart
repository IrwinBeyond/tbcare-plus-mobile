import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  static const TextStyle heading1 = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.w800,
    color: AppColors.foreground,
    letterSpacing: -0.9,
    height: 1.0,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: AppColors.mutedForeground,
    height: 1.625,
  );

  static const TextStyle buttonPrimary = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w800,
    color: AppColors.primaryForeground,
  );

  static const TextStyle buttonSecondary = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
  );
}
