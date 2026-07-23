import 'package:flutter/material.dart';

/// Data model representing a single onboarding slide.
class OnboardingPageModel {
  /// The slide's main heading.
  final String title;

  /// The slide's supporting description text.
  final String description;

  /// The central icon shown on the slide (use PhosphorIcons values).
  final IconData icon;

  const OnboardingPageModel({
    required this.title,
    required this.description,
    required this.icon,
  });
}
