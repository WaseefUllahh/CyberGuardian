import 'package:flutter/material.dart';
import '../utils/auth_utils.dart';

class LearningScreen extends StatelessWidget {
  const LearningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ──
              const Text('Learning',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: dark)),
              const SizedBox(height: 4),
              const Text('Build your cybersecurity knowledge',
                  style: TextStyle(fontSize: 14, color: grey)),
              const SizedBox(height: 24),

              // ── Your Progress ──
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2E7D32), Color(0xFF43A047)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.emoji_events, color: Colors.amber, size: 28),
                        SizedBox(width: 10),
                        Text('Your Learning Progress',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Text('3/8',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 32)),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: Text('modules completed this week',
                              style: TextStyle(color: Colors.white70, fontSize: 14)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: 3 / 8,
                        backgroundColor: Colors.white.withOpacity(0.2),
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                        minHeight: 8,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // ── Courses ──
              const Text('Courses',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: dark)),
              const SizedBox(height: 14),

              _CourseCard(
                icon: Icons.no_encryption_outlined,
                iconColor: const Color(0xFFE65100),
                bgColor: const Color(0xFFFBE9E7),
                title: 'Phishing Awareness',
                subtitle: 'Learn how to identify phishing emails, fake websites, and social engineering attacks.',
                lessons: '8 Lessons',
                duration: '45 min',
                progress: 0.80,
              ),
              const SizedBox(height: 14),
              _CourseCard(
                icon: Icons.lock_outline,
                iconColor: const Color(0xFF7B1FA2),
                bgColor: const Color(0xFFF3E5F5),
                title: 'Password Security',
                subtitle: 'Create strong passwords, use password managers, and enable two-factor authentication.',
                lessons: '6 Lessons',
                duration: '30 min',
                progress: 0.65,
              ),
              const SizedBox(height: 14),
              _CourseCard(
                icon: Icons.public,
                iconColor: green,
                bgColor: const Color(0xFFE8F5E9),
                title: 'Safe Browsing',
                subtitle: 'Browse safely, identify dangerous sites, and protect your personal data online.',
                lessons: '5 Lessons',
                duration: '25 min',
                progress: 0.90,
              ),
              const SizedBox(height: 14),
              _CourseCard(
                icon: Icons.account_balance_wallet_outlined,
                iconColor: const Color(0xFF1565C0),
                bgColor: const Color(0xFFE3F2FD),
                title: 'Fraud Prevention',
                subtitle: 'Recognize scams, protect your financial information, and report fraudulent activity.',
                lessons: '7 Lessons',
                duration: '40 min',
                progress: 0.30,
              ),
              const SizedBox(height: 14),
              _CourseCard(
                icon: Icons.wifi_lock,
                iconColor: const Color(0xFFE65100),
                bgColor: const Color(0xFFFFF3E0),
                title: 'Network Security',
                subtitle: 'Secure your Wi-Fi, use VPNs, and protect devices on public networks.',
                lessons: '6 Lessons',
                duration: '35 min',
                progress: 0.0,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _CourseCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor, bgColor;
  final String title, subtitle, lessons, duration;
  final double progress;

  const _CourseCard({
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
                        Icon(Icons.menu_book_outlined, size: 14, color: grey),
                        const SizedBox(width: 4),
                        Text(lessons, style: const TextStyle(fontSize: 12, color: grey)),
                        const SizedBox(width: 12),
                        Icon(Icons.access_time, size: 14, color: grey),
                        const SizedBox(width: 4),
                        Text(duration, style: const TextStyle(fontSize: 12, color: grey)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(subtitle, style: const TextStyle(color: grey, fontSize: 13, height: 1.4)),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: const Color(0xFFEEEEEE),
                    valueColor: AlwaysStoppedAnimation<Color>(iconColor),
                    minHeight: 6,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text('${(progress * 100).toInt()}%',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: iconColor)),
            ],
          ),
        ],
      ),
    );
  }
}
