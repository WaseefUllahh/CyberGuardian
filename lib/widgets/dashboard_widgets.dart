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
        children: [
          PremiumCyberIcon(icon: icon, size: 24, hasBackground: true, hasGlow: false),
          const SizedBox(height: 14),
          Text(title,
              style: textTheme.cardTitle.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : null)),
          const SizedBox(height: 4),
          Text(subtitle,
              style: textTheme.cardSubtitle.copyWith(
                  color: isDark ? const Color(0xFFAAAAAA) : null)),
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

class HeroStatusCard extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF2E7D32), Color(0xFF43A047)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(PhosphorIcons.shieldStar(), color: Colors.white, size: 20),
              ),
              const SizedBox(width: 10),
              const Text('Security Status',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(score.toString(), style: textTheme.heroMetric),
              const Padding(
                padding: EdgeInsets.only(bottom: 6),
                child: Text(' %',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(statusText,
                    style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(description,
              style: const TextStyle(color: Colors.white70, fontSize: 13)),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.white.withValues(alpha: 0.2),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 6),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Last scanned: Just now', style: TextStyle(color: Colors.white70, fontSize: 12)),
            ],
          ),
        ],
      ),
        ),
      ),
    );
  }
}