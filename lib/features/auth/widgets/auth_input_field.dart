import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/brand_logo.dart';

/// Shared auth input field used in [LoginScreen] and [SignUpScreen].
///
/// Styled with CyberGuardian's brand palette and supports
/// prefix icons, suffix icons, obscure text, and form validation.
class AuthField extends StatelessWidget {
  final String label, hint;
  final IconData? prefixIcon;
  final TextEditingController controller;
  final bool obscure;
  final TextInputType keyboardType;
  final Widget? suffixIcon;
  final String? Function(String?) validator;

  const AuthField({
    super.key,
    required this.label,
    required this.hint,
    this.prefixIcon,
    required this.controller,
    required this.validator,
    this.obscure = false,
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppColors.dark;
    final hintColor = isDark ? const Color(0xFF888888) : AppColors.grey;
    final iconColor = isDark ? const Color(0xFF888888) : AppColors.grey;
    final fillColor = isDark ? const Color(0xFF2A2A2A) : Colors.white;
    final borderColor =
        isDark ? const Color(0xFF3A3A3A) : AppColors.grey.withValues(alpha: 0.25);

    return TextFormField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      validator: validator,
      style: TextStyle(fontSize: 14, color: textColor),
      cursorColor: AppColors.brandGreen,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: hintColor, fontSize: 14),
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: iconColor, size: 20)
            : null,
        suffixIcon: suffixIcon,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        filled: true,
        fillColor: fillColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.brandGreen, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
        ),
        errorStyle: const TextStyle(color: Colors.redAccent),
      ),
    );
  }
}

/// Primary action button used on auth screens (Login, Sign Up).
class AuthButton extends StatelessWidget {
  final String label;
  final bool isLoading;
  final VoidCallback onPressed;

  const AuthButton({
    super.key,
    required this.label,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) => ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.brandGreen,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          elevation: 0,
        ),
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                    color: Colors.white, strokeWidth: 2))
            : Text(label,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      );
}

/// Eye / eye-closed icon button to toggle password visibility.
Widget passwordToggle(bool obscure, VoidCallback onTap) => Builder(
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return IconButton(
          icon: Icon(
            obscure ? PhosphorIcons.eyeClosed() : PhosphorIcons.eye(),
            color: isDark ? const Color(0xFF888888) : AppColors.grey,
            size: 20,
          ),
          onPressed: onTap,
        );
      },
    );

/// Auth screen header: app logo + title + subtitle.
class AuthHeader extends StatelessWidget {
  final IconData icon;
  final String title, subtitle;
  const AuthHeader({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
        const SizedBox(height: 8),
        const BrandLogo(size: 64),
        const SizedBox(height: 16),
        Text(title,
            style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : AppColors.dark)),
        const SizedBox(height: 8),
        Text(subtitle,
            style: TextStyle(
                fontSize: 14,
                color: isDark ? const Color(0xFFAAAAAA) : AppColors.grey),
            textAlign: TextAlign.center),
      ],
    );
  }
}

/// Clickable redirect link (e.g., "Don't have an account? Sign up").
class RedirectLink extends StatelessWidget {
  final String question, actionLabel;
  final VoidCallback onTap;
  const RedirectLink({
    super.key,
    required this.question,
    required this.actionLabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(question,
            style: TextStyle(
                color: isDark ? const Color(0xFFAAAAAA) : AppColors.grey,
                fontSize: 14)),
        GestureDetector(
          onTap: onTap,
          child: Text(actionLabel,
              style: TextStyle(
                  color: AppColors.brandGreen,
                  fontWeight: FontWeight.bold,
                  fontSize: 14)),
        ),
      ],
    );
  }
}

/// Full-screen scaffold with animated geometric background.
/// Wraps the login and signup forms.
class GeometricAuthLayout extends StatelessWidget {
  final Widget child;

  const GeometricAuthLayout({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor =
        isDark ? const Color(0xFF121212) : const Color(0xFFFAFAFA);

    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        children: [
          Positioned.fill(
            child: GeometricBackground(isDark: isDark),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 40, 24, 80),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: child,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// The animated geometric shapes painted in the auth screen background.
class GeometricBackground extends StatelessWidget {
  final bool isDark;
  const GeometricBackground({super.key, this.isDark = false});

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: CustomPaint(
        painter: _GeometricPainter(isDark: isDark),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _GeometricPainter extends CustomPainter {
  final bool isDark;
  const _GeometricPainter({this.isDark = false});

  @override
  void paint(Canvas canvas, Size size) {
    final Color accentColor = AppColors.brandGreen;

    final Paint gearPaint = Paint()
      ..color = accentColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 30
      ..strokeCap = StrokeCap.square;

    final Paint fillPaint = Paint()
      ..color = accentColor
      ..style = PaintingStyle.fill;

    final Paint darkFillPaint = Paint()
      ..color = isDark ? const Color(0xFF121212) : const Color(0xFFFAFAFA)
      ..style = PaintingStyle.fill;

    const Offset topLeftCenter = Offset(0, 0);
    double radius = size.width > 600 ? 200 : size.width * 0.4;

    canvas.drawArc(
        Rect.fromCircle(center: topLeftCenter, radius: radius), 0, 1.2, false, gearPaint);
    canvas.drawArc(
        Rect.fromCircle(center: topLeftCenter, radius: radius), 1.5, 1.2, false, gearPaint);
    canvas.drawArc(
        Rect.fromCircle(center: topLeftCenter, radius: radius), 3.0, 1.5, false, gearPaint);

    canvas.drawCircle(topLeftCenter, radius * 0.7, fillPaint);
    canvas.drawCircle(topLeftCenter, radius * 0.4, darkFillPaint);

    Path diamond = Path()
      ..moveTo(topLeftCenter.dx, topLeftCenter.dy - radius * 0.2)
      ..lineTo(topLeftCenter.dx + radius * 0.2, topLeftCenter.dy)
      ..lineTo(topLeftCenter.dx, topLeftCenter.dy + radius * 0.2)
      ..lineTo(topLeftCenter.dx - radius * 0.2, topLeftCenter.dy)
      ..close();
    canvas.drawPath(
        diamond,
        Paint()
          ..color = accentColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 10);

    final Paint chevronPaint = Paint()
      ..color = accentColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width > 600 ? 40 : 25
      ..strokeJoin = StrokeJoin.miter;

    double cx = size.width;
    double cy = size.height;
    double offset = size.width > 600 ? 60 : 30;

    Path chevron1 = Path()
      ..moveTo(cx - offset * 2.5, cy)
      ..lineTo(cx - offset * 0.5, cy - offset * 2)
      ..lineTo(cx, cy - offset * 2.5);
    canvas.drawPath(chevron1, chevronPaint);

    Path chevron2 = Path()
      ..moveTo(cx - offset * 4.5, cy)
      ..lineTo(cx - offset * 1.5, cy - offset * 3)
      ..lineTo(cx, cy - offset * 4.5);
    canvas.drawPath(chevron2, chevronPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}


