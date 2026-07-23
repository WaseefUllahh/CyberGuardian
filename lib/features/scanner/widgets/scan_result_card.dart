import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/virus_total_result.dart';
import '../../../models/text_analysis_result.dart';

// scan_result_card.dart
//
// Shared result cards used by URL, SMS, and Email scanner panels.
// Kept in one file because both cards share the same visual pattern
// and are always used together by the scanner panels.

/// Displays a safe / threat-detected / error badge for a VirusTotal URL scan.
class ScanResultCard extends StatelessWidget {
  final VirusTotalResult result;
  const ScanResultCard({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color bgColor;
    final Color borderColor;
    final Color iconColor;
    final IconData icon;
    final String title;
    final String subtitle;

    if (result.isError) {
      bgColor = isDark ? const Color(0xFF3A2D10) : const Color(0xFFFFF8E1);
      borderColor = const Color(0xFFFFB300);
      iconColor = const Color(0xFFFF8F00);
      icon = PhosphorIcons.warningCircle();
      title = 'Scan Error';
      subtitle = result.errorMessage!;
    } else if (result.isSafe) {
      bgColor = isDark ? const Color(0xFF1A3B22) : const Color(0xFFE8F5E9);
      borderColor = AppColors.brandGreen;
      iconColor = AppColors.brandGreen;
      icon = PhosphorIcons.shieldCheck();
      title = 'URL is Safe';
      subtitle = 'No threats detected by VirusTotal.';
    } else {
      bgColor = isDark ? const Color(0xFF3E1111) : const Color(0xFFFFEBEE);
      borderColor = Colors.red;
      iconColor = Colors.red;
      icon = PhosphorIcons.shieldWarning();
      title = 'Threat Detected!';
      subtitle = result.threatLabel;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor.withValues(alpha: 0.6), width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: iconColor)),
                const SizedBox(height: 3),
                Text(subtitle,
                    style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.white : AppColors.dark)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Displays a safe / phishing-detected badge for SMS and Email text analysis.
class TextAnalysisResultCard extends StatelessWidget {
  final TextAnalysisResult result;
  const TextAnalysisResultCard({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bgColor;
    final Color borderColor;
    final Color iconColor;
    final IconData icon;

    if (result.isSafe) {
      bgColor = isDark ? const Color(0xFF1A3B22) : const Color(0xFFE8F5E9);
      borderColor = AppColors.brandGreen;
      iconColor = AppColors.brandGreen;
      icon = PhosphorIcons.shieldCheck();
    } else {
      bgColor = isDark ? const Color(0xFF3E1111) : const Color(0xFFFFEBEE);
      borderColor = Colors.red;
      iconColor = Colors.red;
      icon = PhosphorIcons.shieldWarning();
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor.withValues(alpha: 0.6), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 26),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(result.threatLevel,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: iconColor)),
                    const SizedBox(height: 3),
                    Text(
                      result.isSafe
                          ? 'No phishing indicators found.'
                          : 'High Risk (Score: ${result.riskScore}/100)',
                      style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.white : AppColors.dark),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (!result.isSafe) ...[
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            if (result.keywordMatches.isNotEmpty) ...[
              Row(
                children: [
                  Icon(PhosphorIcons.warningCircle(),
                      color: Colors.orange, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Suspicious Keywords: ${result.keywordMatches.join(', ')}',
                      style: TextStyle(
                          fontSize: 13,
                          color: isDark
                              ? Colors.grey.shade300
                              : Colors.grey.shade800),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
            if (result.urlResults.isNotEmpty) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(PhosphorIcons.link(), color: Colors.blue, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: result.urlResults.entries.map((e) {
                        final url = e.key;
                        final vt = e.value;
                        final isUrlSafe = vt.isSafe;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(
                            '$url - ${isUrlSafe ? 'Safe' : 'Malicious'}',
                            style: TextStyle(
                                fontSize: 13,
                                color: isUrlSafe
                                    ? AppColors.brandGreen
                                    : Colors.red,
                                fontWeight: FontWeight.bold),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ],
      ),
    );
  }
}


