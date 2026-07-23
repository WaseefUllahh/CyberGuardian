import 'dart:math';
import 'package:flutter/material.dart';

/// Renders a radial burst of particles that expands outward when the user
/// taps "Get Started". Driven by [progress] (0.0 → 1.0).
class BurstPainter extends CustomPainter {
  /// Animation progress: 0.0 = burst start, 1.0 = fully expanded + faded.
  final double progress;

  /// Accent colour for the burst particles.
  final Color color;

  const BurstPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0) return;

    // Burst originates from the centre-bottom (near the button)
    final center = Offset(size.width / 2, size.height * 0.78);
    final maxRadius = size.width * 0.65;
    const particleCount = 24;

    for (int i = 0; i < particleCount; i++) {
      final angle = (i / particleCount) * 2 * pi;
      // Each particle travels on a slightly randomised radius for a natural look
      final spread = 0.7 + (sin(i * 1.7) * 0.3);
      final distance = progress * maxRadius * spread;
      final opacity = ((1.0 - progress) * 0.9).clamp(0.0, 1.0);
      final particleSize = ((1.0 - progress) * 7 + 1.5).clamp(0.0, 10.0);

      final px = center.dx + cos(angle) * distance;
      final py = center.dy + sin(angle) * distance;

      canvas.drawCircle(
        Offset(px, py),
        particleSize,
        Paint()..color = color.withValues(alpha: opacity),
      );
    }

    // Expanding ring
    final ringOpacity = ((1.0 - progress) * 0.5).clamp(0.0, 1.0);
    canvas.drawCircle(
      center,
      progress * maxRadius,
      Paint()
        ..color = color.withValues(alpha: ringOpacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5,
    );

    // Second smaller ring with slight delay effect
    if (progress > 0.15) {
      final p2 = (progress - 0.15) / 0.85;
      final ring2Opacity = ((1.0 - p2) * 0.3).clamp(0.0, 1.0);
      canvas.drawCircle(
        center,
        p2 * maxRadius * 0.6,
        Paint()
          ..color = color.withValues(alpha: ring2Opacity)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5,
      );
    }
  }

  @override
  bool shouldRepaint(BurstPainter old) => old.progress != progress;
}
