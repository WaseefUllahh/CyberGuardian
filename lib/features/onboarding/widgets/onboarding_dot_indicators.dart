import 'package:flutter/material.dart';

/// Animated pill-shaped page indicator row for the onboarding screen.
///
/// The active dot expands into a pill and glows. Neighbouring dots scale
/// slightly towards the active dot as the user swipes (driven by [pageProgress]).
class OnboardingDotIndicators extends StatelessWidget {
  /// Total number of pages.
  final int count;

  /// Index of the currently settled page.
  final int currentIndex;

  /// Raw fractional page position from [PageController.page], used to
  /// smoothly interpolate neighbouring dot sizes during a swipe gesture.
  final double pageProgress;

  /// Active-dot accent colour (the app's brand green).
  final Color color;

  const OnboardingDotIndicators({
    super.key,
    required this.count,
    required this.currentIndex,
    required this.pageProgress,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (i) {
        // How close is this dot to the current scroll position?
        final proximity = (pageProgress - i).abs().clamp(0.0, 1.0);
        final isActive = i == currentIndex;

        // Neighbour dots grow slightly when adjacent to the active dot
        final neighbourScale = isActive ? 1.0 : (1.0 - proximity * 0.3).clamp(0.7, 1.0);

        return AnimatedContainer(
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOutCubic,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 30 : 8 * neighbourScale,
          height: 8,
          decoration: BoxDecoration(
            color: isActive ? color : color.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(4),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: color.withValues(alpha: 0.55),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
        );
      }),
    );
  }
}
