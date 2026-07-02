import 'package:flutter/material.dart';
import '../utils/auth_utils.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  final _urlController = TextEditingController();
  final _messageController = TextEditingController();
  final _emailController = TextEditingController();

  // Radio button selection: 'URL' | 'SMS' | 'Email'
  String _scanType = 'URL';

  @override
  void dispose() {
    _urlController.dispose();
    _messageController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      // ── AppBar ───────────────────────────────────────────────────────────────
      appBar: AppBar(
        title: const Text(
          'Threat Scanner',
          style: TextStyle(fontWeight: FontWeight.bold, color: dark),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: dark),
                onPressed: () => Navigator.pop(context),
              )
            : null,
        actions: [
          IconButton(
            icon: const Icon(Icons.history_rounded, color: dark),
            tooltip: 'Scan History',
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Subtitle ──
              const Text('Scan URLs and messages for threats',
                  style: TextStyle(fontSize: 14, color: grey)),
              const SizedBox(height: 20),

              // ── Radio Scan Type Selector ──────────────────────────────────
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select Scan Type',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: dark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Choose what you want to analyze',
                      style: TextStyle(fontSize: 12, color: grey),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(child: _radioOption('URL', Icons.link_rounded)),
                        const SizedBox(width: 8),
                        Expanded(child: _radioOption('SMS', Icons.sms_outlined)),
                        const SizedBox(width: 8),
                        Expanded(child: _radioOption('Email', Icons.email_outlined)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ── Scanner Panel ─────────────────────────────────────────────
              if (_scanType == 'URL') _buildUrlScanner(),
              if (_scanType == 'SMS') _buildSmsScanner(),
              if (_scanType == 'Email') _buildEmailScanner(),

              const SizedBox(height: 28),

              // ── Recent Scans ──────────────────────────────────────────────
              const Text('Recent Scans',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: dark)),
              const SizedBox(height: 14),
              _buildRecentScan('google.com', 'URL', 'Safe', green, Icons.check_circle_outline),
              const SizedBox(height: 10),
              _buildRecentScan('suspicious-link.xyz', 'URL', 'Suspicious', Colors.red, Icons.warning_amber_rounded),
              const SizedBox(height: 10),
              _buildRecentScan('bank-update.net', 'URL', 'Phishing', Colors.red, Icons.dangerous_outlined),
              const SizedBox(height: 10),
              _buildRecentScan('Win free prize message', 'SMS', 'Suspicious', Colors.red, Icons.warning_amber_rounded),
              const SizedBox(height: 10),
              _buildRecentScan('flutter.dev', 'URL', 'Safe', green, Icons.check_circle_outline),
            ],
          ),
        ),
      ),
    );
  }

  // ── Radio Option Widget ────────────────────────────────────────────────────
  Widget _radioOption(String value, IconData icon) {
    final bool selected = _scanType == value;
    return GestureDetector(
      onTap: () => setState(() => _scanType = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        decoration: BoxDecoration(
          color: selected ? green : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? green : const Color(0xFFE0E0E0),
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Radio<String>(
                  value: value,
                  groupValue: _scanType,
                  onChanged: (v) => setState(() => _scanType = v!),
                  activeColor: Colors.white,
                  fillColor: WidgetStateProperty.all(
                    selected ? Colors.white : grey,
                  ),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: const VisualDensity(
                    horizontal: VisualDensity.minimumDensity,
                    vertical: VisualDensity.minimumDensity,
                  ),
                ),
                Icon(icon, color: selected ? Colors.white : grey, size: 16),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                color: selected ? Colors.white : grey,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── URL Scanner ───────────────────────────────────────────────────────────
  Widget _buildUrlScanner() {
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
            controller: _urlController,
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
                if (_urlController.text.isNotEmpty) {
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

  // ── SMS Scanner ───────────────────────────────────────────────────────────
  Widget _buildSmsScanner() {
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
            controller: _messageController,
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
                if (_messageController.text.isNotEmpty) {
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

  // ── Email Scanner ─────────────────────────────────────────────────────────
  Widget _buildEmailScanner() {
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
            controller: _emailController,
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
                if (_emailController.text.isNotEmpty) {
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

  // ── Recent Scan Item ──────────────────────────────────────────────────────
  Widget _buildRecentScan(
      String item, String type, String status, Color color, IconData icon) {
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
                Text(item,
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
