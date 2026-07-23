import 'dart:math';
import 'package:flutter/material.dart';

/// A single floating cyber particle rendered by [CyberParticlesPainter].
class CyberParticle {
  /// Normalised X position (0.0–1.0).
  final double x;

  /// Normalised starting Y position (0.0–1.0). Particles drift upward from here.
  final double baseY;

  /// Upward drift speed multiplier.
  final double speed;

  /// Radius in logical pixels.
  final double size;

  /// Base opacity (0.0–1.0).
  final double opacity;

  /// Shape type: 0 = filled circle, 1 = hexagon outline, 2 = cross/plus.
  final int type;

  /// Parallax depth layer: 0.0 = background (slow), 1.0 = foreground (fast).
  final double layer;

  const CyberParticle({
    required this.x,
    required this.baseY,
    required this.speed,
    required this.size,
    required this.opacity,
    required this.type,
    required this.layer,
  });
}

/// Renders an animated field of floating cyber-themed particles over the
/// onboarding background. Repaints every animation frame for fluid motion.
///
/// The [pageProgress] value (from [PageController.page]) drives a subtle
/// parallax shift so foreground particles scroll faster than background ones.
class CyberParticlesPainter extends CustomPainter {
  final double animationValue; // 0.0–1.0, looping
  final double pageProgress;  // actual page scroll position for parallax
  final List<CyberParticle> particles;
  final Color color;

  const CyberParticlesPainter({
    required this.animationValue,
    required this.pageProgress,
    required this.particles,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      // Drift upward: Y decreases over time, wraps around
      final rawY = (p.baseY - animationValue * p.speed) % 1.0;
      final y = (rawY < 0 ? rawY + 1.0 : rawY) * size.height;

      // Parallax X offset based on page scroll progress and layer depth
      final parallaxShift = (pageProgress % 1.0 - 0.5) * p.layer * size.width * 0.06;
      final rawX = p.x * size.width + parallaxShift;
      final x = rawX % size.width;

      final paint = Paint()..color = color.withValues(alpha: p.opacity);

      switch (p.type) {
        case 0: // filled circle
          canvas.drawCircle(Offset(x, y), p.size, paint);
          break;
        case 1: // hexagon outline
          paint
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.0;
          _drawHexagon(canvas, Offset(x, y), p.size, paint);
          break;
        case 2: // cross / plus
          paint
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.0
            ..strokeCap = StrokeCap.round;
          final half = p.size;
          canvas.drawLine(Offset(x - half, y), Offset(x + half, y), paint);
          canvas.drawLine(Offset(x, y - half), Offset(x, y + half), paint);
          break;
      }
    }
  }

  void _drawHexagon(Canvas canvas, Offset center, double radius, Paint paint) {
    final path = Path();
    for (int i = 0; i < 6; i++) {
      final angle = (i * 60 - 30) * pi / 180;
      final px = center.dx + radius * cos(angle);
      final py = center.dy + radius * sin(angle);
      if (i == 0) {
        path.moveTo(px, py);
      } else {
        path.lineTo(px, py);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CyberParticlesPainter old) =>
      old.animationValue != animationValue ||
      old.pageProgress != pageProgress ||
      old.color != color;
}

/// Generates [count] randomised [CyberParticle] instances.
/// Uses a fixed seed so the field is deterministic across rebuilds.
List<CyberParticle> generateCyberParticles(int count) {
  final rng = Random(42);
  return List.generate(count, (_) {
    return CyberParticle(
      x: rng.nextDouble(),
      baseY: rng.nextDouble(),
      speed: 0.04 + rng.nextDouble() * 0.12,
      size: 1.5 + rng.nextDouble() * 5.0,
      opacity: 0.06 + rng.nextDouble() * 0.28,
      type: rng.nextInt(3),
      layer: rng.nextInt(2).toDouble(),
    );
  });
}
