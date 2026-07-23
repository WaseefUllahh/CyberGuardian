import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/text_analysis_result.dart';
import '../../../services/text_analysis_service.dart';
import '../../../services/url_scan_service.dart';
import 'scan_result_card.dart';

/// Panel for analyzing email body/subject for phishing indicators.
///
/// Works identically to [SmsScannerPanel] but targets email content
/// and is visually distinguished with an orange accent color.
class EmailScannerPanel extends StatefulWidget {
  final TextEditingController controller;
  const EmailScannerPanel({super.key, required this.controller});

  @override
  State<EmailScannerPanel> createState() => _EmailScannerPanelState();
}

class _EmailScannerPanelState extends State<EmailScannerPanel> {
  bool _loading = false;
  TextAnalysisResult? _result;

  Future<void> _scanEmail() async {
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
      'Email',
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
                      ? const Color(0xFF3B1E05)
                      : const Color(0xFFFBE9E7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(PhosphorIcons.envelopeSimple(),
                    color: AppColors.brandGreen, size: 24),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Email Analyzer',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: textColor)),
                  Text('Paste email content to detect phishing',
                      style: TextStyle(fontSize: 12, color: subtitleColor)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          TextField(
            controller: widget.controller,
            maxLines: 5,
            style: TextStyle(color: textColor),
            decoration: InputDecoration(
              hintText: 'Paste email subject, sender, or body here...',
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
                    const BorderSide(color: Color(0xFFE65100), width: 1.5),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Tip banner
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF3B2D15)
                  : const Color(0xFFFFF3E0),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(PhosphorIcons.lightbulb(),
                    color: const Color(0xFFE65100), size: 18),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Tip: Include the sender address and subject line for better results.',
                    style: TextStyle(
                        fontSize: 12, color: Color(0xFFE65100)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _loading ? null : _scanEmail,
              icon: _loading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white))
                  : Icon(PhosphorIcons.envelopeSimple()),
              label: Text(_loading ? 'Analyzing...' : 'Analyze Email',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE65100),
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


