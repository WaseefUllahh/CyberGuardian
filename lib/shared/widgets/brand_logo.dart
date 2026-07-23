import 'package:flutter/material.dart';

/// Display style for [BrandLogo].
enum BrandLogoStyle {
  /// Dark→bright green gradient background with a green glow shadow.
  /// Use on neutral (white / dark) backgrounds — splash, login, onboarding.
  standard,

  /// Semi-transparent white background with no glow.
  /// Use when the logo already sits on a green surface (e.g. drawer header).
  onGreen,
}

/// Reusable CyberGuardian logo widget.
///
/// Wraps `cyberguardian_logo.png` in a circular gradient container with a
/// coloured glow shadow, giving the logo the premium depth it was missing.
///
/// Usage:
/// ```dart
/// BrandLogo(size: 120)                        // standard — green circle
/// BrandLogo(size: 72, style: BrandLogoStyle.onGreen)  // on green bg
/// ```
class BrandLogo extends StatelessWidget {
  /// Diameter of the circular container (and overall widget size).
  final double size;

  /// Background / glow style — see [BrandLogoStyle].
  final BrandLogoStyle style;

  const BrandLogo({
    super.key,
    this.size = 120,
    this.style = BrandLogoStyle.standard,
  });

  @override
  Widget build(BuildContext context) {
    // Inner padding scales with size so the logo doesn't touch the edge
    final padding = size * 0.20;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: style == BrandLogoStyle.standard
            ? const LinearGradient(
                colors: [Color(0xFF1B5E20), Color(0xFF4CAF50)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: style == BrandLogoStyle.onGreen
            ? Colors.white.withValues(alpha: 0.18)
            : null,
        boxShadow: style == BrandLogoStyle.standard
            ? [
                BoxShadow(
                  color: const Color(0xFF2E7D32).withValues(alpha: 0.45),
                  blurRadius: 28,
                  spreadRadius: 3,
                  offset: const Offset(0, 6),
                ),
                // Inner highlight — adds subtle depth
                BoxShadow(
                  color: const Color(0xFF4CAF50).withValues(alpha: 0.15),
                  blurRadius: 10,
                  spreadRadius: -2,
                ),
              ]
            : null,
      ),
      padding: EdgeInsets.all(padding),
      child: Image.asset(
        'assets/images/cyberguardian_logo.png',
        filterQuality: FilterQuality.high,
        // White logo on the green circle — crisp, readable, professional
        color: Colors.white,
        colorBlendMode: BlendMode.srcIn,
        errorBuilder: (context, error, stack) => Icon(
          Icons.shield_rounded,
          color: Colors.white,
          size: size * 0.5,
        ),
      ),
    );
  }
}
