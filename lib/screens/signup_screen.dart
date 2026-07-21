import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../utils/app_colors.dart';
import '../utils/auth_utils.dart';
import '../services/auth_service.dart';
import '../widgets/auth_widgets.dart';
import '../widgets/password_strength_widget.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _obscurePass = true, _obscureConfirm = true, _loading = false;
  String _passwordText = '';

  @override
  void initState() {
    super.initState();
    _password.addListener(() {
      setState(() => _passwordText = _password.text);
    });
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    final error = await AuthService().signUp(_name.text, _email.text, _password.text);
    if (error != null) {
      if (mounted) {
        setState(() => _loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error), backgroundColor: Colors.red),
        );
      }
      return;
    }

    if (mounted) {
      setState(() => _loading = false);
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final subtitleColor = isDark ? const Color(0xFFAAAAAA) : AppColors.grey;

    return GeometricAuthLayout(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Logo header
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Image.asset(
                    'assets/images/cyberguardian_logo.png',
                    width: 56,
                    height: 56,
                    filterQuality: FilterQuality.high,
                    errorBuilder: (c, e, s) => Icon(PhosphorIcons.shieldCheck(), color: AppColors.brandGreen, size: 56),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Welcome text
          Text(
            'USER SIGNUP',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: AppColors.brandGreen,
              letterSpacing: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Join CyberGuardian today',
            style: TextStyle(color: subtitleColor, fontSize: 13, letterSpacing: 0.5),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),

          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AuthField(
                  label: '',
                  hint: 'Full Name',
                  controller: _name,
                  validator: (v) {
                    final req = requiredValidator(v, 'name');
                    if (req != null) return req;
                    if (!RegExp(r'[a-zA-Z]').hasMatch(v!)) {
                      return 'Name must contain at least one letter';
                    }
                    return null;
                  },
                  prefixIcon: PhosphorIcons.user(),
                ),
                const SizedBox(height: 16),

                AuthField(
                  label: '',
                  hint: 'Email address',
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  validator: emailValidator,
                  prefixIcon: PhosphorIcons.envelope(),
                ),
                const SizedBox(height: 16),

                AuthField(
                  label: '',
                  hint: 'Password',
                  controller: _password,
                  obscure: _obscurePass,
                  prefixIcon: PhosphorIcons.lock(),
                  suffixIcon: passwordToggle(_obscurePass, () => setState(() => _obscurePass = !_obscurePass)),
                  validator: (v) {
                    if (requiredValidator(v, 'password') != null) return requiredValidator(v, 'password');
                    if (v!.length < 8) return 'Password must be at least 8 characters';
                    if (!v.contains(RegExp(r'[A-Z]'))) return 'Add at least one uppercase letter (A–Z)';
                    if (!v.contains(RegExp(r'[0-9]'))) return 'Add at least one number (0–9)';
                    if (!v.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>_\-=+\[\]\\;~/`]'))) {
                      return r'Add at least one special character (!@#$%…)';
                    }
                    return null;
                  },
                ),

                // Real-time password strength indicator
                PasswordStrengthIndicator(password: _passwordText),

                const SizedBox(height: 16),

                AuthField(
                  label: '',
                  hint: 'Confirm Password',
                  controller: _confirm,
                  obscure: _obscureConfirm,
                  prefixIcon: PhosphorIcons.lockKey(),
                  suffixIcon: passwordToggle(_obscureConfirm, () => setState(() => _obscureConfirm = !_obscureConfirm)),
                  validator: (v) {
                    if (requiredValidator(v, 'confirm password') != null) return requiredValidator(v, 'confirm password');
                    if (v != _password.text) return 'Passwords do not match';
                    return null;
                  },
                ),
                const SizedBox(height: 32),

                AuthButton(label: 'Sign Up', isLoading: _loading, onPressed: _submit),
                const SizedBox(height: 32),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account? ", style: TextStyle(color: subtitleColor, fontSize: 13)),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Text('Log In', style: TextStyle(color: AppColors.brandGreen, fontSize: 13, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}