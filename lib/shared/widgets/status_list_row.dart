import 'package:flutter/material.dart';
import '../../core/theme/text_styles.dart';

/// A tappable list row with a coloured left-border accent and a status badge.
///
/// Used in dashboard threat lists, reports lists, and admin views.
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
                        fontWeight:
                            isHighSeverity ? FontWeight.w600 : FontWeight.normal,
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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



