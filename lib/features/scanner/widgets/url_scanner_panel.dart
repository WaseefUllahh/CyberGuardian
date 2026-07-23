import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/virus_total_result.dart';
import '../../../services/virus_total_service.dart';
import '../../../services/url_scan_service.dart';
import 'scan_result_card.dart';

/// Panel for scanning a URL via the VirusTotal API.
///
/// Accepts a [controller] for the URL input field,
/// calls [VirusTotalService.scanUrl], saves the result via
/// [UrlScanService.saveScan], and displays a [ScanResultCard].
class UrlScannerPanel extends StatefulWidget {
  final TextEditingController controller;
  const UrlScannerPanel({super.key, required this.controller});

  @override
  State<UrlScannerPanel> createState() => _UrlScannerPanelState();
}

class _UrlScannerPanelState extends State<UrlScannerPanel> {
  bool _loading = false;
  VirusTotalResult? _result;

  Future<void> _scan() async {
    final url = widget.controller.text.trim();
    if (url.isEmpty) return;

    setState(() {
      _loading = true;
      _result = null;
    });

    final result = await VirusTotalService().scanUrl(url);

    if (mounted) {
      setState(() {
        _loading = false;
        _result = result;
      });
    }

    await UrlScanService().saveScan(
      url,
      result.isSafe ? 'Safe' : 'Suspicious',
      result.isSafe ? 'Clean' : result.threatLabel,
      'VirusTotal',
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
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF1B5E20).withValues(alpha: 0.2)
                      : const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(PhosphorIcons.globeHemisphereWest(),
                    color: AppColors.brandGreen, size: 24),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('URL Scanner',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: textColor)),
                  Text('Powered by VirusTotal',
                      style: TextStyle(fontSize: 12, color: subtitleColor)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          // URL Input
          TextField(
            controller: widget.controller,
            keyboardType: TextInputType.url,
            onSubmitted: (_) => _scan(),
            style: TextStyle(color: textColor),
            decoration: InputDecoration(
              hintText: 'https://example.com',
              hintStyle: TextStyle(color: subtitleColor),
              prefixIcon: Icon(PhosphorIcons.magnifyingGlass(),
                  color: subtitleColor),
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
                    BorderSide(color: AppColors.brandGreen, width: 1.5),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Scan Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _loading ? null : _scan,
              icon: _loading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white))
                  : Icon(PhosphorIcons.shieldCheck()),
              label: Text(_loading ? 'Scanning...' : 'Scan URL',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.brandGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
            ),
          ),

          // Result
          if (_result != null) ...[
            const SizedBox(height: 16),
            ScanResultCard(result: _result!),
            const SizedBox(height: 16),
            if (!_result!.isSafe) ...[
              Row(
                children: [
                  Icon(PhosphorIcons.prohibit(), color: Colors.red, size: 20),
                  const SizedBox(width: 8),
                  Text('Blacklist: ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: textColor)),
                  Text(
                      '${_result!.maliciousEngines?.length ?? 0} engines flagged',
                      style: TextStyle(color: subtitleColor)),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(PhosphorIcons.star(), color: Colors.amber, size: 20),
                  const SizedBox(width: 8),
                  Text('Reputation: ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: textColor)),
                  Text(
                      'Malicious engines: ${_result!.maliciousCount ?? 0}',
                      style: TextStyle(color: subtitleColor)),
                ],
              ),
              const SizedBox(height: 12),
            ] else ...[
              Row(
                children: [
                  Icon(PhosphorIcons.checkCircle(),
                      color: AppColors.brandGreen, size: 20),
                  const SizedBox(width: 8),
                  Text('No threats detected',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: textColor)),
                ],
              ),
              const SizedBox(height: 12),
            ],
          ],
        ],
      ),
    );
  }
}


