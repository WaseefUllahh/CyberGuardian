import 'package:flutter/material.dart';
import '../utils/auth_utils.dart';
import '../widgets/scanner_widgets.dart';

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
              if (_scanType == 'URL') UrlScannerPanel(controller: _urlController),
              if (_scanType == 'SMS') SmsScannerPanel(controller: _messageController),
              if (_scanType == 'Email') EmailScannerPanel(controller: _emailController),

              const SizedBox(height: 28),

              // ── Recent Scans ──────────────────────────────────────────────
              const Text('Recent Scans',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: dark)),
              const SizedBox(height: 14),
              const RecentScanItem(title: 'google.com', type: 'URL', status: 'Safe', color: green, icon: Icons.check_circle_outline),
              const SizedBox(height: 10),
              const RecentScanItem(title: 'suspicious-link.xyz', type: 'URL', status: 'Suspicious', color: Colors.red, icon: Icons.warning_amber_rounded),
              const SizedBox(height: 10),
              const RecentScanItem(title: 'bank-update.net', type: 'URL', status: 'Phishing', color: Colors.red, icon: Icons.dangerous_outlined),
              const SizedBox(height: 10),
              const RecentScanItem(title: 'Win free prize message', type: 'SMS', status: 'Suspicious', color: Colors.red, icon: Icons.warning_amber_rounded),
              const SizedBox(height: 10),
              const RecentScanItem(title: 'flutter.dev', type: 'URL', status: 'Safe', color: green, icon: Icons.check_circle_outline),
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
}
