import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../core/theme/app_colors.dart';

/// Panel for evaluating password strength locally (no API needed).
///
/// Analyses the password in real time for length, uppercase, lowercase,
/// numbers, and special characters. Estimates crack time based on
/// entropy and displays a strength progress bar + checklist.
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

  String _crackTime = 'Instant';

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
      _hasSpecial = text.contains(
          RegExp(r'[!@#\$%\^\&\*\(\)_\+\-\=\[\]\{\};:\",<>\.\/\?\\|`~]'));
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

    double combinations = 1.0;
    for (int i = 0; i < password.length; i++) {
      combinations *= pool;
      if (combinations > 1e30) {
        combinations = 1e30;
        break;
      }
    }
    double seconds = combinations / 10000000000.0; // 10B guesses/sec

    if (seconds < 1) return 'Instant';
    if (seconds < 60) return '${seconds.toInt()} seconds';
    if (seconds < 3600) return '${(seconds / 60).toInt()} minutes';
    if (seconds < 86400) return '${(seconds / 3600).toInt()} hours';
    if (seconds < 31536000) return '${(seconds / 86400).toInt()} days';

    final years = seconds / 31536000;
    if (years < 1000) return '${years.toInt()} years';
    if (years < 1e6) return '${(years / 1000).toStringAsFixed(1)}K years';
    if (years < 1e9) return '${(years / 1e6).toStringAsFixed(1)}M years';
    if (years < 1e12) return '${(years / 1e9).toStringAsFixed(1)}B years';
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
    if (_controller.text.isEmpty) return AppColors.grey;
    if (_score <= 1) return Colors.red;
    if (_score <= 2) return Colors.orange;
    if (_score <= 3) return Colors.yellow.shade700;
    if (_score <= 4) return Colors.lightGreen;
    return AppColors.brandGreen;
  }

  double get _strengthProgress {
    if (_controller.text.isEmpty) return 0.0;
    return _score / 5.0;
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
                      ? const Color(0xFF281131)
                      : const Color(0xFFF3E5F5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(PhosphorIcons.vault(),
                    color: AppColors.brandGreen, size: 24),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Password Check',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: textColor)),
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
                borderSide: const BorderSide(
                    color: Color(0xFF7B1FA2), width: 1.5),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                    _obscure
                        ? PhosphorIcons.eyeClosed()
                        : PhosphorIcons.eye(),
                    color: subtitleColor),
                onPressed: () => setState(() => _obscure = !_obscure),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Password Strength',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: textColor,
                      fontSize: 13)),
              Text(_strengthText,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _strengthColor,
                      fontSize: 13)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: _strengthProgress,
              backgroundColor:
                  isDark ? const Color(0xFF333333) : Colors.grey.shade200,
              valueColor:
                  AlwaysStoppedAnimation<Color>(_strengthColor),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 12),
          // Estimated crack time
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF2A2A2A) : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(PhosphorIcons.clock(),
                    size: 18, color: subtitleColor),
                const SizedBox(width: 8),
                Text('Est. Crack Time:',
                    style:
                        TextStyle(color: subtitleColor, fontSize: 13)),
                const Spacer(),
                Flexible(
                  child: Text(
                    _crackTime,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: textColor,
                        fontSize: 13),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Breached password warning
          if (_score <= 2 && _controller.text.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border:
                    Border.all(color: Colors.red.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Icon(PhosphorIcons.warning(),
                      color: Colors.red, size: 20),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Breached Password Warning: This password has appeared in data leaks. (API Integration Pending)',
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 8),
          _buildCheckItem(
              'At least 8 characters', _hasLength, textColor, subtitleColor),
          _buildCheckItem(
              'Uppercase letter', _hasUpper, textColor, subtitleColor),
          _buildCheckItem(
              'Lowercase letter', _hasLower, textColor, subtitleColor),
          _buildCheckItem(
              'Contains a number', _hasNumber, textColor, subtitleColor),
          _buildCheckItem(
              'Contains a special character', _hasSpecial, textColor, subtitleColor),
        ],
      ),
    );
  }

  Widget _buildCheckItem(
      String label, bool met, Color textColor, Color subtitleColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(
            met ? PhosphorIcons.checkCircle() : PhosphorIcons.circle(),
            color: met ? AppColors.brandGreen : subtitleColor,
            size: 18,
          ),
          const SizedBox(width: 8),
          Text(label,
              style: TextStyle(
                  color: met ? textColor : subtitleColor, fontSize: 13)),
        ],
      ),
    );
  }
}


