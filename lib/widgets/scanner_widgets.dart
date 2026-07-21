import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../utils/app_colors.dart';
import '../models/virus_total_result.dart';
import '../services/virus_total_service.dart';
import '../services/url_scan_service.dart';
import '../models/text_analysis_result.dart';
import '../services/text_analysis_service.dart';

// ── URL Scanner Panel ─────────────────────────────────────────────────────────

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
      'VirusTotal'
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : dark;
    final subtitleColor = isDark ? const Color(0xFFAAAAAA) : grey;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1B5E20).withValues(alpha: 0.2) : const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(PhosphorIcons.globeHemisphereWest(), color: green, size: 24),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('URL Scanner',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: textColor)),
                  Text('Powered by VirusTotal',
                      style: TextStyle(fontSize: 12, color: subtitleColor)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          // ── Input ──
          TextField(
            controller: widget.controller,
            keyboardType: TextInputType.url,
            onSubmitted: (_) => _scan(),
            style: TextStyle(color: textColor),
            decoration: InputDecoration(
              hintText: 'https://example.com',
              hintStyle: TextStyle(color: subtitleColor),
              prefixIcon: Icon(PhosphorIcons.magnifyingGlass(), color: subtitleColor),
              filled: true,
              fillColor: isDark ? const Color(0xFF2A2A2A) : Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: isDark ? const Color(0xFF333333) : grey.withValues(alpha: 0.3))),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: isDark ? const Color(0xFF333333) : grey.withValues(alpha: 0.3))),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: green, width: 1.5),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // ── Scan Button ──
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _loading ? null : _scan,
              icon: _loading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Icon(PhosphorIcons.shieldCheck()),
              label: Text(
                _loading ? 'Scanning...' : 'Scan URL',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
            ),
          ),

          // ── Result Card ──
          if (_result != null) ...[
            const SizedBox(height: 16),
            _ScanResultCard(result: _result!),
            const SizedBox(height: 16),
            // ── Additional Info ──
            if (!_result!.isSafe) ...[
              // Blacklist (show malicious engines count)
              Row(
                children: [
                  Icon(PhosphorIcons.prohibit(), color: Colors.red, size: 20),
                  const SizedBox(width: 8),
                  Text('Blacklist: ', style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
                  Text('${_result!.maliciousEngines?.length ?? 0} engines flagged', style: TextStyle(color: subtitleColor)),
                ],
              ),
              const SizedBox(height: 12),
              // Reputation (simple score based on malicious count)
              Row(
                children: [
                  Icon(PhosphorIcons.star(), color: Colors.amber, size: 20),
                  const SizedBox(width: 8),
                  Text('Reputation: ', style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
                  Text('Malicious engines: ${_result!.maliciousCount ?? 0}', style: TextStyle(color: subtitleColor)),
                ],
              ),
              const SizedBox(height: 12),
            ] else ...[
              // Safe info
              Row(
                children: [
                  Icon(PhosphorIcons.checkCircle(), color: green, size: 20),
                  const SizedBox(width: 8),
                  Text('No threats detected', style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
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

// ── Shared Result Card ────────────────────────────────────────────────────────

class _ScanResultCard extends StatelessWidget {
  final VirusTotalResult result;
  const _ScanResultCard({required this.result});

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
      borderColor = green;
      iconColor = green;
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
                    style: TextStyle(fontSize: 12, color: isDark ? Colors.white : dark)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Text Analysis Result Card ──────────────────────────────────────────────────

class _TextAnalysisResultCard extends StatelessWidget {
  final TextAnalysisResult result;
  const _TextAnalysisResultCard({required this.result});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final Color bgColor;
    final Color borderColor;
    final Color iconColor;
    final IconData icon;

    if (result.isSafe) {
      bgColor = isDark ? const Color(0xFF1A3B22) : const Color(0xFFE8F5E9);
      borderColor = green;
      iconColor = green;
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
                    Text(result.isSafe ? 'No phishing indicators found.' : 'High Risk (Score: ${result.riskScore}/100)',
                        style: TextStyle(fontSize: 12, color: isDark ? Colors.white : dark)),
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
                  Icon(PhosphorIcons.warningCircle(), color: Colors.orange, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text('Suspicious Keywords: ${result.keywordMatches.join(', ')}',
                        style: TextStyle(fontSize: 13, color: isDark ? Colors.grey.shade300 : Colors.grey.shade800)),
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
                          child: Text('$url - ${isUrlSafe ? 'Safe' : 'Malicious'}',
                              style: TextStyle(fontSize: 13, color: isUrlSafe ? green : Colors.red, fontWeight: FontWeight.bold)),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ]
          ]
        ],
      ),
    );
  }
}

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
    if (snippet.length > 50) {
      snippet = '${snippet.substring(0, 47)}...';
    }

    await UrlScanService().saveScan(
      snippet,
      result.isSafe ? 'Safe' : 'Suspicious',
      result.threatLevel,
      'SMS'
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : dark;
    final subtitleColor = isDark ? const Color(0xFFAAAAAA) : grey;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
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
                  color: isDark ? const Color(0xFF102842) : const Color(0xFFE3F2FD),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(PhosphorIcons.chatCircleText(), color: green, size: 24),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('SMS Analyzer',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: textColor)),
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
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: isDark ? const Color(0xFF333333) : grey.withValues(alpha: 0.3))),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: isDark ? const Color(0xFF333333) : grey.withValues(alpha: 0.3))),
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
              onPressed: _loading ? null : _scanSms,
              icon: _loading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : Icon(PhosphorIcons.magnifyingGlass()),
              label: Text(_loading ? 'Analyzing...' : 'Analyze SMS', style: const TextStyle(fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1565C0),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
            ),
          ),
          if (_result != null) ...[
            const SizedBox(height: 16),
            _TextAnalysisResultCard(result: _result!),
          ],
        ],
      ),
    );
  }
}


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
    if (snippet.length > 50) {
      snippet = '${snippet.substring(0, 47)}...';
    }

    await UrlScanService().saveScan(
      snippet,
      result.isSafe ? 'Safe' : 'Suspicious',
      result.threatLevel,
      'Email'
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : dark;
    final subtitleColor = isDark ? const Color(0xFFAAAAAA) : grey;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
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
                  color: isDark ? const Color(0xFF3B1E05) : const Color(0xFFFBE9E7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(PhosphorIcons.envelopeSimple(), color: green, size: 24),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Email Analyzer',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: textColor)),
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
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: isDark ? const Color(0xFF333333) : grey.withValues(alpha: 0.3))),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: isDark ? const Color(0xFF333333) : grey.withValues(alpha: 0.3))),
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
              color: isDark ? const Color(0xFF3B2D15) : const Color(0xFFFFF3E0),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(PhosphorIcons.lightbulb(), color: const Color(0xFFE65100), size: 18),
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
              onPressed: _loading ? null : _scanEmail,
              icon: _loading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : Icon(PhosphorIcons.envelopeSimple()),
              label: Text(_loading ? 'Analyzing...' : 'Analyze Email', style: const TextStyle(fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE65100),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
            ),
          ),
          if (_result != null) ...[
            const SizedBox(height: 16),
            _TextAnalysisResultCard(result: _result!),
          ],
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : dark;
    final subtitleColor = isDark ? const Color(0xFFAAAAAA) : grey;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
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
                    style: TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 14, color: textColor),
                    overflow: TextOverflow.ellipsis),
                Text(type, style: TextStyle(color: subtitleColor, fontSize: 12)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: color.withValues(alpha: 0.4)),
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

class PasswordScannerPanel extends StatefulWidget {
  const PasswordScannerPanel({super.key});

  @override
  State<PasswordScannerPanel> createState() => _PasswordScannerPanelState();
}

class _PasswordScannerPanelState extends State<PasswordScannerPanel> {
  final _controller = TextEditingController();
  bool _obscure = true;

  bool _hasLength = false;
  bool _hasUpper = false;
  bool _hasLower = false;
  bool _hasNumber = false;
  bool _hasSpecial = false;

  String _crackTime = "Instant";

  @override
  void initState() {
    super.initState();
    _controller.addListener(_evaluatePassword);
  }

  @override
  void dispose() {
    _controller.removeListener(_evaluatePassword);
    _controller.dispose();
    super.dispose();
  }

  void _evaluatePassword() {
    final text = _controller.text;
    setState(() {
      _hasLength = text.length >= 8;
      _hasUpper = text.contains(RegExp(r'[A-Z]'));
      _hasLower = text.contains(RegExp(r'[a-z]'));
      _hasNumber = text.contains(RegExp(r'[0-9]'));
      _hasSpecial = text.contains(RegExp(r'[!@#\$%\^&\*\(\)_\+\-\=\[\]\{\};:\",<>\./\?\\|`~]'));
      _crackTime = _estimateCrackTime(text);
    });
  }

  String _estimateCrackTime(String password) {
    if (password.isEmpty) return 'Instant';
    int pool = 0;
    if (_hasLower) pool += 26;
    if (_hasUpper) pool += 26;
    if (_hasNumber) pool += 10;
    if (_hasSpecial) pool += 32;
    if (pool == 0) return 'Instant';

    // Simple entropy calc: (pool ^ length) / guesses_per_sec
    double combinations = 1.0;
    for (int i = 0; i < password.length; i++) {
      combinations *= pool;
      // Avoid overflow — cap at 1e30
      if (combinations > 1e30) { combinations = 1e30; break; }
    }
    double seconds = combinations / 10000000000.0; // 10B guesses/sec

    if (seconds < 1)           return 'Instant';
    if (seconds < 60)          return '${seconds.toInt()} seconds';
    if (seconds < 3600)        return '${(seconds / 60).toInt()} minutes';
    if (seconds < 86400)       return '${(seconds / 3600).toInt()} hours';
    if (seconds < 31536000)    return '${(seconds / 86400).toInt()} days';

    final years = seconds / 31536000;
    if (years < 1000)          return '${years.toInt()} years';
    if (years < 1e6)           return '${(years / 1000).toStringAsFixed(1)}K years';
    if (years < 1e9)           return '${(years / 1e6).toStringAsFixed(1)}M years';
    if (years < 1e12)          return '${(years / 1e9).toStringAsFixed(1)}B years';
    return '> 1 trillion years';
  }

  int get _score {
    int s = 0;
    if (_hasLength) s++;
    if (_hasUpper) s++;
    if (_hasLower) s++;
    if (_hasNumber) s++;
    if (_hasSpecial) s++;
    return s;
  }

  String get _strengthText {
    if (_controller.text.isEmpty) return 'Enter a password';
    if (_score <= 1) return 'Weak';
    if (_score <= 2) return 'Fair';
    if (_score <= 3) return 'Good';
    if (_score <= 4) return 'Strong';
    return 'Excellent';
  }

  Color get _strengthColor {
    if (_controller.text.isEmpty) return grey;
    if (_score <= 1) return Colors.red;
    if (_score <= 2) return Colors.orange;
    if (_score <= 3) return Colors.yellow.shade700;
    if (_score <= 4) return Colors.lightGreen;
    return green;
  }

  double get _strengthProgress {
    if (_controller.text.isEmpty) return 0.0;
    return _score / 5.0;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : dark;
    final subtitleColor = isDark ? const Color(0xFFAAAAAA) : grey;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
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
                  color: isDark ? const Color(0xFF281131) : const Color(0xFFF3E5F5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(PhosphorIcons.vault(), color: green, size: 24),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Password Check',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: textColor)),
                  Text('Test password strength',
                      style: TextStyle(fontSize: 12, color: subtitleColor)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _controller,
            obscureText: _obscure,
            style: TextStyle(color: textColor),
            decoration: InputDecoration(
              hintText: 'Enter password...',
              hintStyle: TextStyle(color: subtitleColor),
              filled: true,
              fillColor: isDark ? const Color(0xFF2A2A2A) : Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: isDark ? const Color(0xFF333333) : grey.withValues(alpha: 0.3))),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: isDark ? const Color(0xFF333333) : grey.withValues(alpha: 0.3))),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF7B1FA2), width: 1.5),
              ),
              suffixIcon: IconButton(
                icon: Icon(_obscure ? PhosphorIcons.eyeClosed() : PhosphorIcons.eye(), color: subtitleColor),
                onPressed: () => setState(() => _obscure = !_obscure),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Password Strength', style: TextStyle(fontWeight: FontWeight.bold, color: textColor, fontSize: 13)),
              Text(_strengthText, style: TextStyle(fontWeight: FontWeight.bold, color: _strengthColor, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: _strengthProgress,
              backgroundColor: isDark ? const Color(0xFF333333) : Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(_strengthColor),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 12),
          // Estimated Crack Time
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF2A2A2A) : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(PhosphorIcons.clock(), size: 18, color: subtitleColor),
                const SizedBox(width: 8),
                Text('Est. Crack Time:', style: TextStyle(color: subtitleColor, fontSize: 13)),
                const Spacer(),
                Flexible(
                  child: Text(
                    _crackTime,
                    style: TextStyle(fontWeight: FontWeight.bold, color: textColor, fontSize: 13),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Breached Password Warning Placeholder
          if (_score <= 2 && _controller.text.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Icon(PhosphorIcons.warning(), color: Colors.red, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text('Breached Password Warning: This password has appeared in data leaks. (API Integration Pending)',
                      style: TextStyle(color: Colors.red, fontSize: 12)),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 8),
          _buildCheckItem('At least 8 characters', _hasLength, isDark, textColor, subtitleColor),
          _buildCheckItem('Uppercase letter', _hasUpper, isDark, textColor, subtitleColor),
          _buildCheckItem('Lowercase letter', _hasLower, isDark, textColor, subtitleColor),
          _buildCheckItem('Contains a number', _hasNumber, isDark, textColor, subtitleColor),
          _buildCheckItem('Contains a special character', _hasSpecial, isDark, textColor, subtitleColor),
        ],
      ),
    );
  }

  Widget _buildCheckItem(String label, bool met, bool isDark, Color textColor, Color subtitleColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(met ? PhosphorIcons.checkCircle() : PhosphorIcons.circle(),
               color: met ? green : subtitleColor, size: 18),
          const SizedBox(width: 8),
          Text(label, style: TextStyle(color: met ? textColor : subtitleColor, fontSize: 13)),
        ],
      ),
    );
  }
}
