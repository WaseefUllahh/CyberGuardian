import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../core/theme/app_colors.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('About CyberGuardian',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.brandGreen,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1B5E20), Color(0xFF2E7D32)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20)),
              child: Column(
                children: [
                  Icon(PhosphorIcons.shieldCheck(), size: 72, color: Colors.white),
                  const SizedBox(height: 16),
                  const Text('CyberGuardian',
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 4),
                  const Text('Version 1.0.0',
                      style: TextStyle(color: Colors.white70, fontSize: 14)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _infoTile(context, PhosphorIcons.info(), 'Mission',
                'Protect users from cyber threats with real-time URL and message scanning.'),
            _infoTile(context, PhosphorIcons.code(), 'Built With',
                'Flutter, Firebase, VirusTotal API'),
            _infoTile(context, PhosphorIcons.envelope(), 'Contact',
                'support@cyberguardian.app'),
            _infoTile(context, PhosphorIcons.copyright(), 'Copyright',
                '© 2025 CyberGuardian. All rights reserved.'),
          ],
        ),
      ),
    );
  }

  Widget _infoTile(BuildContext context, IconData icon, String label, String value) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: isDark ? const Color(0xFF1E1E1E) : Colors.white, borderRadius: BorderRadius.circular(14)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.brandGreen, size: 22),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 13, color: isDark ? const Color(0xFFAAAAAA) : AppColors.grey)),
                const SizedBox(height: 4),
                Text(value,
                    style: TextStyle(fontSize: 14, color: isDark ? Colors.white : AppColors.dark)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


