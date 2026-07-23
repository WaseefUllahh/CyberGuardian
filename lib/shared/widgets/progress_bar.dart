import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// A labelled linear progress bar used on the dashboard and elsewhere.
///
/// Displays [label] on the left, [percent] string on the right,
/// and a coloured progress track beneath.
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
            Text(label,
                style: TextStyle(fontSize: 14, color: textColor, fontWeight: FontWeight.w500)),
            Text(percent,
                style: TextStyle(fontSize: 14, color: color, fontWeight: FontWeight.bold)),
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


