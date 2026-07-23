import 'package:flutter/material.dart';
import '../../../core/theme/text_styles.dart';
import '../../../shared/widgets/premium_icon.dart';

/// Quick-action grid tile shown on the dashboard.
///
/// Displays an icon, bold title, and subtitle. Tapping [onTap] navigates
/// to the relevant feature (Scanner, Submit Report, etc.).
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



