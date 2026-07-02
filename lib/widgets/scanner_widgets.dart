import 'package:flutter/material.dart';
import '../utils/auth_utils.dart';

class UrlScannerPanel extends StatelessWidget {
  final TextEditingController controller;

  const UrlScannerPanel({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
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
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.link, color: green, size: 24),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('URL Scanner',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: dark)),
                  Text('Enter a URL to check its safety',
                      style: TextStyle(fontSize: 12, color: grey)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          TextField(
            controller: controller,
            keyboardType: TextInputType.url,
            decoration: InputDecoration(
              hintText: 'https://example.com',
              hintStyle: const TextStyle(color: grey),
              prefixIcon: const Icon(Icons.search, color: grey),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: green, width: 1.5),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Scanning URL... Result: Safe ✓'),
                      backgroundColor: green,
                    ),
                  );
                }
              },
              icon: const Icon(Icons.security),
              label: const Text('Scan URL', style: TextStyle(fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SmsScannerPanel extends StatelessWidget {
  final TextEditingController controller;

  const SmsScannerPanel({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
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
                  color: const Color(0xFFE3F2FD),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.sms_outlined, color: Color(0xFF1565C0), size: 24),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('SMS Analyzer',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: dark)),
                  Text('Paste a suspicious SMS message',
                      style: TextStyle(fontSize: 12, color: grey)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          TextField(
            controller: controller,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Paste suspicious SMS text here...',
              hintStyle: const TextStyle(color: grey),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF1565C0), width: 1.5),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Analyzing SMS... No threats detected ✓'),
                      backgroundColor: green,
                    ),
                  );
                }
              },
              icon: const Icon(Icons.analytics_outlined),
              label: const Text('Analyze SMS', style: TextStyle(fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1565C0),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class EmailScannerPanel extends StatelessWidget {
  final TextEditingController controller;

  const EmailScannerPanel({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
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
                  color: const Color(0xFFFBE9E7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.email_outlined, color: Color(0xFFE65100), size: 24),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Email Analyzer',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: dark)),
                  Text('Paste email content to detect phishing',
                      style: TextStyle(fontSize: 12, color: grey)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          TextField(
            controller: controller,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: 'Paste email subject, sender, or body here...',
              hintStyle: const TextStyle(color: grey),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE65100), width: 1.5),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Tip
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3E0),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Row(
              children: [
                Icon(Icons.lightbulb_outline, color: Color(0xFFE65100), size: 18),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Tip: Include the sender address and subject line for better results.',
                    style: TextStyle(fontSize: 12, color: Color(0xFFE65100)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Analyzing email... Potential phishing detected ⚠️'),
                      backgroundColor: Color(0xFFE65100),
                    ),
                  );
                }
              },
              icon: const Icon(Icons.find_in_page_outlined),
              label: const Text('Analyze Email', style: TextStyle(fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE65100),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RecentScanItem extends StatelessWidget {
  final String title, type, status;
  final Color color;
  final IconData icon;

  const RecentScanItem({
    super.key,
    required this.title,
    required this.type,
    required this.status,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 14, color: dark),
                    overflow: TextOverflow.ellipsis),
                Text(type, style: const TextStyle(color: grey, fontSize: 12)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: color.withOpacity(0.4)),
            ),
            child: Text(status,
                style: TextStyle(
                    color: color, fontSize: 12, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}
