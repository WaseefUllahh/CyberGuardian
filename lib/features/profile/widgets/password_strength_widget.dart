import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Returns a 0–4 score for the given password.
int passwordStrengthScore(String password) {
  int score = 0;
  if (password.length >= 8) score++;
  if (password.contains(RegExp(r'[A-Z]'))) score++;
  if (password.contains(RegExp(r'[0-9]'))) score++;
  if (password.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>_\-=+\[\]\\;~/`]'))) score++;
  return score;
}

class PasswordStrengthIndicator extends StatelessWidget {
  final String password;

  const PasswordStrengthIndicator({super.key, required this.password});

  @override
  Widget build(BuildContext context) {
    if (password.isEmpty) return const SizedBox.shrink();

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final score = passwordStrengthScore(password);

    final List<_Requirement> requirements = [
      _Requirement(
        label: 'At least 8 characters',
        met: password.length >= 8,
        hint: 'Use 8 or more characters',
      ),
      _Requirement(
        label: '1 uppercase letter (A–Z)',
        met: password.contains(RegExp(r'[A-Z]')),
        hint: 'Add a capital letter like A, B, C…',
      ),
      _Requirement(
        label: '1 number (0–9)',
        met: password.contains(RegExp(r'[0-9]')),
        hint: 'Add a digit like 1, 2, 3…',
      ),
      _Requirement(
        label: r'1 special character (!@#$%…)',
        met: password.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>_\-=+\[\]\\;~/`]')),
        hint: r'Add a symbol like @, #, !, $',
      ),
    ];

    final Color barColor;
    final String strengthLabel;

    switch (score) {
      case 0:
      case 1:
        barColor = const Color(0xFFE53935);
        strengthLabel = 'Very Weak';
        break;
      case 2:
        barColor = const Color(0xFFFF7043);
        strengthLabel = 'Weak';
        break;
      case 3:
        barColor = const Color(0xFFFFA726);
        strengthLabel = 'Fair';
        break;
      default:
        barColor = const Color(0xFF43A047);
        strengthLabel = 'Strong';
    }

    final trackColor = isDark ? const Color(0xFF333333) : const Color(0xFFE0E0E0);
    final textColor = isDark ? const Color(0xFFAAAAAA) : AppColors.grey;

    return AnimatedSize(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          // Strength bar + label row
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Stack(
                    children: [
                      // Track
                      Container(height: 6, color: trackColor),
                      // Fill
                      AnimatedFractionallySizedBox(
                        duration: const Duration(milliseconds: 350),
                        curve: Curves.easeOut,
                        widthFactor: score / 4.0,
                        child: Container(
                          height: 6,
                          decoration: BoxDecoration(
                            color: barColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Text(
                  strengthLabel,
                  key: ValueKey(strengthLabel),
                  style: TextStyle(
                    color: barColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Checklist
          ...requirements.map((req) => _RequirementRow(req: req, textColor: textColor)),
        ],
      ),
    );
  }
}

class _Requirement {
  final String label;
  final bool met;
  final String hint;
  const _Requirement({required this.label, required this.met, required this.hint});
}

class _RequirementRow extends StatelessWidget {
  final _Requirement req;
  final Color textColor;
  const _RequirementRow({super.key, required this.req, required this.textColor});

  @override
  Widget build(BuildContext context) {
    final Color iconColor = req.met ? const Color(0xFF43A047) : const Color(0xFFE53935);
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Icon(
              req.met ? Icons.check_circle_rounded : Icons.cancel_rounded,
              key: ValueKey(req.met),
              size: 15,
              color: iconColor,
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              req.met ? req.label : '${req.label} — ${req.hint}',
              style: TextStyle(
                fontSize: 11.5,
                color: req.met ? iconColor : textColor,
                fontWeight: req.met ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}




