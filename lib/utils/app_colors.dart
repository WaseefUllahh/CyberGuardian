import 'package:flutter/material.dart';

// Top-level color variables (if used)
Color green = const Color(0xFF2E7D32);
Color lightGreen = const Color(0xFFE8F5E9);
Color dark = const Color(0xFF333333);
Color grey = const Color(0xFF757575);

class AppColors {
  static Color brandGreen = const Color(0xFF2E7D32);
  static Color lightGreen = const Color(0xFFE8F5E9);
  static Color statusSafeGreen = const Color(0xFF4CAF50);
  static Color statusWarningRed = const Color(0xFFE53935);
  static Color statusMediumOrange = const Color(0xFFFF9800);
  static Color grey = const Color(0xFF757575);
  static Color dark = const Color(0xFF333333);
  static Color background = const Color(0xFFF5F7FA);

  static void setTheme(bool isDark) {
    if (isDark) {
      brandGreen = const Color(0xFF4CAF50);
      lightGreen = const Color(0xFF1E3A2F);
      grey = const Color(0xFFAAAAAA);
      dark = const Color(0xFFFFFFFF);
      background = const Color(0xFF121212);
    } else {
      brandGreen = const Color(0xFF2E7D32);
      lightGreen = const Color(0xFFE8F5E9);
      grey = const Color(0xFF757575);
      dark = const Color(0xFF333333);
      background = const Color(0xFFF5F7FA);
    }
    green = brandGreen;
    lightGreen = AppColors.lightGreen;
    dark = AppColors.dark;
    grey = AppColors.grey;
  }
}


extension CustomTextTheme on TextTheme {
  TextStyle get heroMetric => const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white);
  TextStyle get sectionHeader => TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.dark);
  TextStyle get cardTitle => TextStyle(fontSize: 15, fontWeight: FontWeight.normal, color: AppColors.dark);
  TextStyle get cardSubtitle => TextStyle(fontSize: 12, color: AppColors.grey);
}


