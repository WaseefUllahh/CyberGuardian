import 'package:flutter/material.dart';
import '../utils/auth_utils.dart';

class CourseCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor, bgColor;
  final String title, subtitle, lessons, duration;
  final double progress;

  const CourseCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    required this.title,
    required this.subtitle,
    required this.lessons,
    required this.duration,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: dark)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.menu_book_outlined, size: 14, color: grey),
                        const SizedBox(width: 4),
                        Text(lessons, style: const TextStyle(fontSize: 12, color: grey)),
                        const SizedBox(width: 12),
                        const Icon(Icons.access_time, size: 14, color: grey),
                        const SizedBox(width: 4),
                        Text(duration, style: const TextStyle(fontSize: 12, color: grey)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(subtitle, style: const TextStyle(fontSize: 13, color: grey, height: 1.4)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: const Color(0xFFEEEEEE),
                    valueColor: const AlwaysStoppedAnimation<Color>(green),
                    minHeight: 6,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text('${(progress * 100).toInt()}%',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: green)),
            ],
          ),
        ],
      ),
    );
  }
}
