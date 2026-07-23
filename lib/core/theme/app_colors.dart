import 'package:flutter/material.dart';

// Top-level color variables (used directly in widget files)
// These are convenience globals that mirror AppColors and are updated via
// AppColors.setTheme() for dark/light mode.
Color green = const Color(0xFF2E7D32);
Color lightGreen = const Color(0xFFE8F5E9);
Color dark = const Color(0xFF333333);
Color grey = const Color(0xFF757575);

// AppColors class
/// Central palette for CyberGuardian.
/// Call [AppColors.setTheme] whenever the brightness changes.
class AppColors {
  static Color brandGreen = const Color(0xFF2E7D32);
  static Color lightGreen = const Color(0xFFE8F5E9);
  static Color statusSafeGreen = const Color(0xFF4CAF50);
  static Color statusWarningRed = const Color(0xFFE53935);
  static Color statusMediumOrange = const Color(0xFFFF9800);
  static Color grey = const Color(0xFF757575);
  static Color dark = const Color(0xFF333333);
  static Color background = const Color(0xFFF5F7FA);

  /// Update mutable colors to match the current [isDark] brightness.
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
    // Keep top-level globals in sync
    green = brandGreen;
    AppColors.lightGreen = lightGreen;
    AppColors.dark = dark;
    AppColors.grey = grey;
  }
}


