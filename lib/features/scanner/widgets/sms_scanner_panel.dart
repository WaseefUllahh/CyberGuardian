import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/text_analysis_result.dart';
import '../../../services/text_analysis_service.dart';
import '../../../services/url_scan_service.dart';
import 'scan_result_card.dart';

/// Panel for analyzing SMS text for phishing or scam indicators.
///
/// Accepts a [controller] with the raw SMS body, calls
/// [TextAnalysisService.analyzeText], saves via [UrlScanService.saveScan],
/// and renders a [TextAnalysisResultCard].
class SmsScannerPanel extends StatefulWidget {
  final TextEditingController controller;
  const SmsScannerPanel({super.key, required this.controller});

  @override
  State<SmsScannerPanel> createState() => _SmsScannerPanelState();
}

class _SmsScannerPanelState extends State<SmsScannerPanel> {
  bool _loading = false;
  TextAnalysisResult? _result;

  Future<void> _scanSms() async {
    final text = widget.controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _loading = true;
      _result = null;
    });

    final result = await TextAnalysisService().analyzeText(text);

    if (mounted) {
      setState(() {
        _loading = false;
        _result = result;
      });
    }

    String snippet = text.replaceAll('\n', ' ');
    if (snippet.length > 50) snippet = '${snippet.substring(0, 47)}...';

    await UrlScanService().saveScan(
      snippet,
      result.isSafe ? 'Safe' : 'Suspicious',
      result.threatLevel,
      'SMS',
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : AppColors.dark;
    final subtitleColor = isDark ? const Color(0xFFAAAAAA) : AppColors.grey;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: cardColor, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF102842)
                      : const Color(0xFFE3F2FD),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(PhosphorIcons.chatCircleText(),
                    color: AppColors.brandGreen, size: 24),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('SMS Analyzer',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: textColor)),
                  Text('Paste a suspicious SMS message',
                      style: TextStyle(fontSize: 12, color: subtitleColor)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          TextField(
            controller: widget.controller,
            maxLines: 4,
            style: TextStyle(color: textColor),
            decoration: InputDecoration(
              hintText: 'Paste suspicious SMS text here...',
              hintStyle: TextStyle(color: subtitleColor),
              filled: true,
              fillColor: isDark ? const Color(0xFF2A2A2A) : Colors.white,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                      color: isDark
                          ? const Color(0xFF333333)
                          : AppColors.grey.withValues(alpha: 0.3))),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                      color: isDark
                          ? const Color(0xFF333333)
                          : AppColors.grey.withValues(alpha: 0.3))),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: Color(0xFF1565C0), width: 1.5),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _loading ? null : _scanSms,
              icon: _loading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white))
                  : Icon(PhosphorIcons.magnifyingGlass()),
              label: Text(_loading ? 'Analyzing...' : 'Analyze SMS',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1565C0),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
            ),
          ),
          if (_result != null) ...[
            const SizedBox(height: 16),
            TextAnalysisResultCard(result: _result!),
          ],
        ],
      ),
    );
  }
}


