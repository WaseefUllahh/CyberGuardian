import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Privacy Policy',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.brandGreen,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text('Privacy Policy',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.dark)),
            const SizedBox(height: 4),
            Text('Last updated: July 2025',
                style: TextStyle(
                    fontSize: 12,
                    color: isDark ? const Color(0xFFAAAAAA) : AppColors.grey)),
            const SizedBox(height: 20),
            _Section(
              title: '1. Information We Collect',
              body:
                  'We collect your email address, display name, and scan activity to provide the CyberGuardian service. This information is stored securely in Google Firebase.',
            ),
            _Section(
              title: '2. How We Use Your Information',
              body:
                  'Your data is used solely to provide, maintain, and improve CyberGuardian. We do not sell or share your personal data with third parties.',
            ),
            _Section(
              title: '3. Data Security',
              body:
                  'All data is encrypted in transit and at rest using industry-standard methods. Firebase Authentication and Firestore security rules protect your account.',
            ),
            _Section(
              title: '4. Your Rights',
              body:
                  'You may request deletion of your account and associated data at any time by contacting support@cyberguardian.app.',
            ),
            _Section(
              title: '5. Contact',
              body:
                  'If you have questions about this policy, email us at support@cyberguardian.app.',
            ),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final String body;
  const _Section({required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: isDark ? Colors.white : AppColors.dark)),
          const SizedBox(height: 6),
          Text(body,
              style: TextStyle(
                  fontSize: 14,
                  color: isDark ? const Color(0xFFCCCCCC) : AppColors.grey,
                  height: 1.5)),
        ],
      ),
    );
  }
}


