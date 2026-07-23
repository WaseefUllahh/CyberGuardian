import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../core/theme/app_colors.dart';
import '../../../utils/auth_utils.dart';
import '../../../services/auth_service.dart';
import '../widgets/auth_input_field.dart';

/// Login screen — authenticates an existing user via [AuthService].
///
/// On success, navigates to [AdminPanelScreen] for admin users
/// or [MainNavigationScreen] for regular users.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true, _loading = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    final authService = AuthService();
    String? error = await authService.login(_email.text, _password.text);

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
      final userModel = await authService.getCurrentUserData();
      if (!mounted) return;
      final bool isAdmin = userModel?.role == 'admin';
      Navigator.pushReplacementNamed(context, isAdmin ? '/admin' : '/home');
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
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(color: Colors.transparent),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Image.asset(
                    'assets/images/cyberguardian_logo.png',
                    width: 120,
                    height: 120,
                    filterQuality: FilterQuality.high,
                    errorBuilder: (c, e, s) => Icon(
                        PhosphorIcons.shieldCheck(),
                        color: AppColors.brandGreen,
                        size: 120),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          Text(
            'USER LOGIN',
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
            'Welcome back to CyberGuardian',
            style:
                TextStyle(color: subtitleColor, fontSize: 13, letterSpacing: 0.5),
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
                  hint: 'Email address',
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  validator: emailValidator,
                  prefixIcon: PhosphorIcons.user(),
                ),
                const SizedBox(height: 16),
                AuthField(
                  label: '',
                  hint: 'Password',
                  controller: _password,
                  obscure: _obscure,
                  prefixIcon: PhosphorIcons.lock(),
                  suffixIcon: passwordToggle(
                      _obscure, () => setState(() => _obscure = !_obscure)),
                  validator: passwordValidator,
                ),
                const SizedBox(height: 12),

                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () async {
                      if (_email.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text(
                                'Enter your email first to reset password.'),
                            backgroundColor: Colors.orange));
                        return;
                      }
                      final messenger = ScaffoldMessenger.of(context);
                      final error =
                          await AuthService().resetPassword(_email.text);
                      if (mounted) {
                        messenger.showSnackBar(SnackBar(
                            content: Text(error ??
                                'Reset instructions sent to your email.'),
                            backgroundColor: error == null
                                ? AppColors.brandGreen
                                : Colors.red));
                      }
                    },
                    child: Text('Forgot password?',
                        style: TextStyle(color: subtitleColor, fontSize: 12)),
                  ),
                ),
                const SizedBox(height: 32),

                AuthButton(
                    label: 'Login',
                    isLoading: _loading,
                    onPressed: _submit),
                const SizedBox(height: 32),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account? ",
                        style:
                            TextStyle(color: subtitleColor, fontSize: 13)),
                    GestureDetector(
                      onTap: () =>
                          Navigator.pushNamed(context, '/signup'),
                      child: Text('Sign Up',
                          style: TextStyle(
                              color: AppColors.brandGreen,
                              fontSize: 13,
                              fontWeight: FontWeight.bold)),
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


