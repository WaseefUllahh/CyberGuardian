import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../core/theme/app_colors.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final faqs = [
      {'q': 'How do I scan a URL?', 'a': 'Go to the Scanner tab, paste a URL, and tap "Scan Now". Results appear within seconds.'},
      {'q': 'What is the Security Score?', 'a': 'Your Security Score reflects your scanning activity and safe browsing habits. Higher is better.'},
      {'q': 'How do I report phishing?', 'a': 'Use the Reports section to submit a suspicious URL or message for investigation.'},
      {'q': 'Is my data private?', 'a': 'Yes. CyberGuardian does not share your personal data with third parties.'},
    ];
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Help Center',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.brandGreen,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SizedBox(height: 8),
          Center(child: Icon(PhosphorIcons.question(), size: 64, color: AppColors.brandGreen)),
          const SizedBox(height: 12),
          Center(
            child: Text('Frequently Asked Questions',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : AppColors.dark)),
          ),
          const SizedBox(height: 20),
          ...faqs.map((faq) => Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E1E1E) : Colors.white, borderRadius: BorderRadius.circular(14)),
                child: ExpansionTile(
                  leading: Icon(PhosphorIcons.caretRight(), color: AppColors.brandGreen, size: 18),
                  title: Text(faq['q']!,
                      style: TextStyle(fontWeight: FontWeight.w600, color: isDark ? Colors.white : AppColors.dark, fontSize: 14)),
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Text(faq['a']!,
                          style: TextStyle(fontSize: 13, color: isDark ? const Color(0xFFAAAAAA) : AppColors.grey)),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}


