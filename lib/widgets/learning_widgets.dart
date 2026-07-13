import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import 'premium_icon.dart';

class CourseCard extends StatelessWidget {
  final IconData icon;
  final String title, subtitle, lessons, duration;
  final double progress;

  const CourseCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.lessons,
    required this.duration,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : dark;
    final subtitleColor = isDark ? const Color(0xFFAAAAAA) : grey;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              PremiumCyberIcon(icon: icon, size: 24, hasBackground: true),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: textColor)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.menu_book_outlined, size: 14, color: subtitleColor),
                        const SizedBox(width: 4),
                        Text(lessons, style: TextStyle(fontSize: 12, color: subtitleColor)),
                        const SizedBox(width: 12),
                        Icon(Icons.access_time, size: 14, color: subtitleColor),
                        const SizedBox(width: 4),
                        Text(duration, style: TextStyle(fontSize: 12, color: subtitleColor)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(subtitle, style: TextStyle(fontSize: 13, color: subtitleColor, height: 1.4)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: isDark ? const Color(0xFF333333) : const Color(0xFFEEEEEE),
                    valueColor: AlwaysStoppedAnimation<Color>(green),
                    minHeight: 6,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text('${(progress * 100).toInt()}%',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: green)),
            ],
          ),
        ],
      ),
    );
  }
}
