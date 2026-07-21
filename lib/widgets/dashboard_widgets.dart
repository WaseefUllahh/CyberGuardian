import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../utils/app_colors.dart';
import 'premium_icon.dart';

class ActionTile extends StatelessWidget {
  final IconData icon;
  final String title, subtitle;
  final VoidCallback? onTap;

  const ActionTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    return Material(
      color: cardColor,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              PremiumCyberIcon(icon: icon, size: 24, hasBackground: true, hasGlow: false),
              const SizedBox(height: 8),
              Text(title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.cardTitle.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : null)),
              const SizedBox(height: 2),
              Expanded(
                child: Text(subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.cardSubtitle.copyWith(
                        color: isDark ? const Color(0xFFAAAAAA) : null)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class AwarenessCard extends StatelessWidget {
  final IconData icon;
  final String title, subtitle;

  const AwarenessCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PremiumCyberIcon(icon: icon, size: 24, hasBackground: true),
          const SizedBox(height: 14),
          Text(title,
              style: textTheme.cardTitle.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : null)),
          const SizedBox(height: 6),
          Text(subtitle,
              style: textTheme.cardSubtitle.copyWith(
                  height: 1.4,
                  color: isDark ? const Color(0xFFAAAAAA) : null)),
          const SizedBox(height: 10),
          Text('Learn More',
              style: TextStyle(
                  color: AppColors.brandGreen,
                  fontWeight: FontWeight.bold,
                  fontSize: 13)),
        ],
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final IconData icon;
  final String value, label;

  const StatCard({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : AppColors.dark;
    final subtitleColor = isDark ? const Color(0xFFAAAAAA) : AppColors.grey;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          PremiumCyberIcon(icon: icon, size: 22, hasBackground: true),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: textColor)),
              Text(label,
                  style: TextStyle(color: subtitleColor, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}

class ActivityItemData {
  final IconData icon;
  final Color iconColor, bgColor, statusColor;
  final String title, subtitle, status;

  ActivityItemData({
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    required this.title,
    required this.subtitle,
    required this.status,
    required this.statusColor,
  });
}

class ProgressBar extends StatelessWidget {
  final String label, percent;
  final double value;
  final Color color;

  const ProgressBar({
    super.key,
    required this.label,
    required this.value,
    required this.percent,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppColors.dark;
    final trackColor = isDark ? const Color(0xFF333333) : const Color(0xFFEEEEEE);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: TextStyle(fontSize: 14, color: textColor, fontWeight: FontWeight.w500)),
            Text(percent, style: TextStyle(fontSize: 14, color: color, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: value,
            backgroundColor: trackColor,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 8,
          ),
        ),
      ],
    );
  }
}

class StatusListRow extends StatelessWidget {
  final IconData icon;
  final Color statusColor;
  final String title, subtitle, statusText;
  final VoidCallback? onTap;

  const StatusListRow({
    super.key,
    required this.icon,
    required this.statusColor,
    required this.title,
    required this.subtitle,
    required this.statusText,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final bool isHighSeverity = (statusText == 'High');

    return Material(
      color: cardColor,
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: 72,
          child: Row(
        children: [
          Container(
            width: 3,
            decoration: BoxDecoration(color: statusColor),
          ),
          const SizedBox(width: 14),
          Icon(icon, color: statusColor, size: 22),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: textTheme.cardTitle.copyWith(
                    fontWeight: isHighSeverity ? FontWeight.w600 : FontWeight.normal,
                    color: isDark ? Colors.white : null,
                  ),
                ),
                const SizedBox(height: 4),
                Text(subtitle,
                    style: textTheme.cardSubtitle.copyWith(
                        color: isDark ? const Color(0xFFAAAAAA) : null)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                statusText,
                style: TextStyle(
                  color: statusColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
        ),
      ),
    );
  }
}

// ─── Wave Painter ────────────────────────────────────────────────────────────
class _WavePainter extends CustomPainter {
  final double phase;

  _WavePainter(this.phase);

  /// Draw a single sine wave line across the full canvas width.
  void _drawWaveLine(
    Canvas canvas,
    Size size, {
    required double centerY,    // 0.0 – 1.0 fraction of height
    required double amplitude,  // 0.0 – 1.0 fraction of height
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
    // ── Three wave lines spread top-to-bottom ──
    // Bottom wave (deepest, most transparent)
    _drawWaveLine(canvas, size,
        centerY: 0.75, amplitude: 0.10,
        phaseOffset: 0.0, opacity: 0.07, strokeWidth: 2.5);

    // Mid wave
    _drawWaveLine(canvas, size,
        centerY: 0.55, amplitude: 0.12,
        phaseOffset: 1.1, opacity: 0.11, strokeWidth: 2.0);

    // Top-front wave (most visible)
    _drawWaveLine(canvas, size,
        centerY: 0.35, amplitude: 0.10,
        phaseOffset: 2.2, opacity: 0.20, strokeWidth: 1.5);

    // ── Glowing dot riding the top-front wave ──
    // The dot's X position advances with phase so it moves across the card.
    // Use a fixed X fraction that drifts with phase, wrapping around.
    const waveCount = 1.5;
    // Map phase to an x position in [0, width], cycling
    final rawFrac = ((phase / (2 * math.pi)) % 1.0);
    final dotFrac = (rawFrac + 0.5) % 1.0; // offset so dot starts mid-card
    final dotX = dotFrac * size.width;
    final t = (dotFrac * waveCount * 2 * math.pi);
    final dotY = size.height * 0.35 +
        0.10 * size.height * math.sin(t + phase + 2.2);

    // Draw glowing dot
    final glowPaint = Paint()
      ..color = const Color(0xFF69F0AE).withValues(alpha: 0.30)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(dotX, dotY), 12, glowPaint);

    final dotPaint = Paint()
      ..color = const Color(0xFF69F0AE)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(dotX, dotY), 6, dotPaint);

    // Inner bright core
    final corePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.85)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(dotX, dotY), 2.5, corePaint);
  }

  @override
  bool shouldRepaint(_WavePainter old) => old.phase != phase;
}

// ─── Hero Status Card ─────────────────────────────────────────────────────────
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
                // ── Animated Wave Background ──
                Positioned.fill(
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, _) {
                      return CustomPaint(
                        painter: _WavePainter(_controller.value * 2 * 3.14159 * 2),
                      );
                    },
                  ),
                ),

                // ── Card Content ──
                Padding(
                  padding: const EdgeInsets.fromLTRB(22, 20, 22, 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.25), width: 1),
                            ),
                            child: Icon(PhosphorIcons.shieldStar(),
                                color: Colors.white, size: 22),
                          ),
                          const SizedBox(width: 14),
                          const Text(
                            'Security Status',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 22),

                      // Score + Protected pill row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Score
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: widget.score.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 56,
                                    fontWeight: FontWeight.bold,
                                    height: 1.0,
                                  ),
                                ),
                                const TextSpan(
                                  text: '%',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),

                          // Protected pill
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
                            child: Text(
                              widget.statusText,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      // Description
                      Text(
                        widget.description,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),

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

                      // Last scanned
                      Row(
                        children: [
                          Icon(PhosphorIcons.clock(),
                              color: Colors.white60, size: 14),
                          const SizedBox(width: 6),
                          const Text(
                            'Last scanned: Just now',
                            style:
                                TextStyle(color: Colors.white60, fontSize: 13),
                          ),
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