import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/text_styles.dart';
import 'premium_icon.dart';

/// An awareness/tip card used on the dashboard and learning screens.
///
/// Shows an icon, title, subtitle, and a "Learn More" label.
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
              style: textTheme.cardSubtitle
                  .copyWith(height: 1.4, color: isDark ? const Color(0xFFAAAAAA) : null)),
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


