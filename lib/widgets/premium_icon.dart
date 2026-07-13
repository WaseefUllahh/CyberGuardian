import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class PremiumCyberIcon extends StatelessWidget {
  final IconData icon;
  final double size;
  final Color? color;
  final bool hasBackground;
  final bool hasGlow;

  const PremiumCyberIcon({
    super.key,
    required this.icon,
    this.size = 24,
    this.color,
    this.hasBackground = true,
    this.hasGlow = false,
  });

  @override
  Widget build(BuildContext context) {
    if (!hasBackground) {
      return Icon(icon, color: color ?? AppColors.brandGreen, size: size);
    }

    return Container(
      width: size * 1.8,
      height: size * 1.8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 0.5),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF81C784), // Light vibrant green
            AppColors.brandGreen,
            Color(0xFF1B5E20), // Dark green
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.brandGreen.withValues(alpha: 0.4),
            blurRadius: hasGlow ? 12 : 6,
            offset: const Offset(0, 4),
          ),
          const BoxShadow(
            color: Colors.white,
            blurRadius: 8,
            spreadRadius: 1,
            offset: Offset(-2, -2),
          ),
        ],
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.9),
          width: 2,
        ),
      ),
      child: Center(
        child: Icon(
          icon,
          size: size,
          color: Colors.white,
          shadows: [
            Shadow(
              color: Colors.black.withValues(alpha: 0.2),
              offset: const Offset(1, 1),
              blurRadius: 2,
            ),
          ],
        ),
      ),
    );
  }
}