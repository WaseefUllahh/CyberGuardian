import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

/// Wave-line painter used inside [HeroStatusCard].
///
/// Draws three animated sine-wave lines and a glowing dot
/// riding the front wave. Phase is driven by an [AnimationController].
class WavePainter extends CustomPainter {
  final double phase;

  WavePainter(this.phase);

  void _drawWaveLine(
    Canvas canvas,
    Size size, {
    required double centerY,
    required double amplitude,
    required double phaseOffset,
    required double opacity,
    required double strokeWidth,
    double waveCount = 1.5,
  }) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final path = Path();
    const step = 2.0;
    bool first = true;
    for (double x = 0; x <= size.width + step; x += step) {
      final t = (x / size.width) * waveCount * 2 * math.pi;
      final y = size.height * centerY +
          amplitude * size.height * math.sin(t + phase + phaseOffset);
      if (first) {
        path.moveTo(x, y);
        first = false;
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(path, paint);
  }

  @override
  void paint(Canvas canvas, Size size) {
    _drawWaveLine(canvas, size,
        centerY: 0.75, amplitude: 0.10, phaseOffset: 0.0, opacity: 0.07, strokeWidth: 2.5);
    _drawWaveLine(canvas, size,
        centerY: 0.55, amplitude: 0.12, phaseOffset: 1.1, opacity: 0.11, strokeWidth: 2.0);
    _drawWaveLine(canvas, size,
        centerY: 0.35, amplitude: 0.10, phaseOffset: 2.2, opacity: 0.20, strokeWidth: 1.5);

    const waveCount = 1.5;
    final rawFrac = ((phase / (2 * math.pi)) % 1.0);
    final dotFrac = (rawFrac + 0.5) % 1.0;
    final dotX = dotFrac * size.width;
    final t = (dotFrac * waveCount * 2 * math.pi);
    final dotY =
        size.height * 0.35 + 0.10 * size.height * math.sin(t + phase + 2.2);

    final glowPaint = Paint()
      ..color = const Color(0xFF69F0AE).withValues(alpha: 0.30)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(dotX, dotY), 12, glowPaint);

    final dotPaint = Paint()
      ..color = const Color(0xFF69F0AE)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(dotX, dotY), 6, dotPaint);

    final corePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.85)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(dotX, dotY), 2.5, corePaint);
  }

  @override
  bool shouldRepaint(WavePainter old) => old.phase != phase;
}


/// The animated green gradient security-score card shown at the top of
/// the dashboard. Tapping it navigates to the scanner.
class HeroStatusCard extends StatefulWidget {
  final int score;
  final String statusText;
  final String description;
  final double progress;
  final VoidCallback? onTap;

  const HeroStatusCard({
    super.key,
    required this.score,
    required this.statusText,
    required this.description,
    required this.progress,
    this.onTap,
  });

  @override
  State<HeroStatusCard> createState() => _HeroStatusCardState();
}

class _HeroStatusCardState extends State<HeroStatusCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(24),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1B5E20), Color(0xFF2E7D32), Color(0xFF43A047)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Stack(
              children: [
                // Animated Wave Background
                Positioned.fill(
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, _) => CustomPaint(
                      painter: WavePainter(
                          _controller.value * 2 * 3.14159 * 2),
                    ),
                  ),
                ),

                // Card Content
                Padding(
                  padding: const EdgeInsets.fromLTRB(22, 20, 22, 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.25),
                                  width: 1),
                            ),
                            child: Icon(PhosphorIcons.shieldStar(),
                                color: Colors.white, size: 22),
                          ),
                          const SizedBox(width: 14),
                          const Text('Security Status',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  letterSpacing: 0.3)),
                        ],
                      ),
                      const SizedBox(height: 22),

                      // Score + status pill
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          RichText(
                            text: TextSpan(children: [
                              TextSpan(
                                text: widget.score.toString(),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 56,
                                    fontWeight: FontWeight.bold,
                                    height: 1.0),
                              ),
                              const TextSpan(
                                text: '%',
                                style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w500),
                              ),
                            ]),
                          ),
                          const SizedBox(width: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.18),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.25),
                                  width: 1),
                            ),
                            child: Text(widget.statusText,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      Text(widget.description,
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 14, height: 1.4)),
                      const SizedBox(height: 24),

                      // Progress bar
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: widget.progress,
                          backgroundColor: Colors.white.withValues(alpha: 0.2),
                          valueColor:
                              const AlwaysStoppedAnimation<Color>(Colors.white),
                          minHeight: 7,
                        ),
                      ),
                      const SizedBox(height: 12),

                      Row(
                        children: [
                          Icon(PhosphorIcons.clock(),
                              color: Colors.white60, size: 14),
                          const SizedBox(width: 6),
                          const Text('Last scanned: Just now',
                              style: TextStyle(
                                  color: Colors.white60, fontSize: 13)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


