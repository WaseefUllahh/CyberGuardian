import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Custom [TextTheme] extensions used across the app.
/// Access via `Theme.of(context).textTheme.sectionHeader` etc.
extension CustomTextTheme on TextTheme {
  TextStyle get heroMetric =>
      const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white);

  TextStyle get sectionHeader =>
      TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.dark);

  TextStyle get cardTitle =>
      TextStyle(fontSize: 15, fontWeight: FontWeight.normal, color: AppColors.dark);

  TextStyle get cardSubtitle =>
      TextStyle(fontSize: 12, color: AppColors.grey);
}


