import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/premium_icon.dart';
import '../widgets/url_scanner_panel.dart';
import '../widgets/sms_scanner_panel.dart';
import '../widgets/email_scanner_panel.dart';
import '../widgets/password_scanner_panel.dart';
import '../widgets/recent_scan_item.dart';
import '../../../services/url_scan_service.dart';
import '../../../models/scan_model.dart';
import 'scan_history_screen.dart';

/// Main threat scanner screen with four scan type tabs:
/// URL, SMS, Email, and Password.
///
/// Each tab loads the corresponding scanner panel widget.
/// Recent scans are listed below the active panel.
class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  final _urlController = TextEditingController();
  final _messageController = TextEditingController();
  final _emailController = TextEditingController();

  // Selected tab: 'URL' | 'SMS' | 'Email' | 'Password'
  String _scanType = 'URL';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is String &&
        ['URL', 'SMS', 'Email', 'Password'].contains(args)) {
      _scanType = args;
    }
  }

  @override
  void dispose() {
    _urlController.dispose();
    _messageController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor =
        isDark ? const Color(0xFF121212) : const Color(0xFFF5F5F5);
    final appBarColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : AppColors.dark;
    final subtitleColor = isDark ? const Color(0xFFAAAAAA) : AppColors.grey;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text('Threat Scanner',
            style:
                TextStyle(fontWeight: FontWeight.bold, color: textColor)),
        backgroundColor: appBarColor,
        elevation: 0,
        surfaceTintColor: appBarColor,
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: Icon(PhosphorIcons.arrowLeft(), color: textColor),
                onPressed: () => Navigator.pop(context),
              )
            : null,
        actions: [
          IconButton(
            icon: Icon(PhosphorIcons.clockCounterClockwise(),
                color: textColor),
            tooltip: 'Scan History',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => const ScanHistoryScreen()),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Scan URLs and messages for threats',
                  style: TextStyle(fontSize: 14, color: subtitleColor)),
              const SizedBox(height: 20),

              // Scan Type Selector
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: appBarColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Select Scan Type',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: textColor)),
                    const SizedBox(height: 4),
                    Text('Choose what you want to analyze',
                        style: TextStyle(
                            fontSize: 12, color: subtitleColor)),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                            child: _radioOption('URL',
                                PhosphorIcons.globeHemisphereWest(),
                                isDark, textColor)),
                        const SizedBox(width: 8),
                        Expanded(
                            child: _radioOption('SMS',
                                PhosphorIcons.chatCircleText(),
                                isDark, textColor)),
                        const SizedBox(width: 8),
                        Expanded(
                            child: _radioOption('Email',
                                PhosphorIcons.envelopeSimple(),
                                isDark, textColor)),
                        const SizedBox(width: 8),
                        Expanded(
                            child: _radioOption('Password',
                                PhosphorIcons.vault(),
                                isDark, textColor)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Active Scanner Panel
              if (_scanType == 'URL')
                UrlScannerPanel(controller: _urlController),
              if (_scanType == 'SMS')
                SmsScannerPanel(controller: _messageController),
              if (_scanType == 'Email')
                EmailScannerPanel(controller: _emailController),
              if (_scanType == 'Password') const PasswordScannerPanel(),

              const SizedBox(height: 28),

              // Recent Scans
              Text('Recent Scans',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor)),
              const SizedBox(height: 14),
              StreamBuilder<List<ScanModel>>(
                stream: UrlScanService().getUserScans(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                        child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Text(
                        'Could not load scans. Please check your connection.',
                        style: TextStyle(
                            color: Colors.red.shade400, fontSize: 13));
                  }
                  final scans = snapshot.data ?? [];
                  if (scans.isEmpty) {
                    return Text('No recent scans.',
                        style: TextStyle(color: subtitleColor));
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: scans.length,
                    itemBuilder: (context, index) {
                      final scan = scans[index];
                      final bool isSafe =
                          scan.result.toLowerCase() == 'safe';
                      final bool isUrl = scan.url.startsWith('http') ||
                          scan.url.contains('www');
                      final bool isEmail = scan.url.contains('@');
                      final IconData icon = isUrl
                          ? PhosphorIcons.globeHemisphereWest()
                          : (isEmail
                              ? PhosphorIcons.envelopeSimple()
                              : PhosphorIcons.chatCircleText());
                      final String scanTypeLabel = isUrl
                          ? 'URL Scan'
                          : (isEmail ? 'Email Scan' : 'SMS Scan');
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: RecentScanItem(
                          title: scan.url,
                          type: scanTypeLabel,
                          status: scan.result,
                          color: isSafe
                              ? AppColors.brandGreen
                              : Colors.red,
                          icon: icon,
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _radioOption(
      String value, IconData icon, bool isDark, Color textColor) {
    final bool selected = _scanType == value;
    return GestureDetector(
      onTap: () => setState(() => _scanType = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding:
            const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.brandGreen
              : (isDark
                  ? const Color(0xFF2A2A2A)
                  : const Color(0xFFF0F4F0)),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected
                ? AppColors.brandGreen
                : (isDark
                    ? const Color(0xFF333333)
                    : const Color(0xFFE0E0E0)),
            width: 1.5,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color:
                        AppColors.brandGreen.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  )
                ]
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PremiumCyberIcon(
                icon: icon,
                size: 26,
                color: AppColors.brandGreen,
                hasBackground: true),
            const SizedBox(height: 8),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                value,
                style: TextStyle(
                  color: selected ? Colors.white : textColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


