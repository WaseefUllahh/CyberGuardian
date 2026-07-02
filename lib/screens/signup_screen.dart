import 'package:flutter/material.dart';
import '../utils/auth_utils.dart';
import '../widgets/auth_widgets.dart';
import 'main_navigation_screen.dart';

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

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) {
        setState(() => _loading = false);
        // Push replacement using MaterialPageRoute to MainNavigationScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const MainNavigationScreen(),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const AuthHeader(
                      icon: Icons.person_add_alt_1_rounded,
                      title: 'Create Account',
                      subtitle: 'Join CyberGuardian and protect your online safety',
                    ),
                    const SizedBox(height: 28),
                    AuthField(
                      label: 'Full Name',
                      hint: 'Wajahat',
                      prefixIcon: Icons.person_outline_rounded,
                      controller: _name,
                      validator: (v) => requiredValidator(v, 'name'),
                    ),
                    const SizedBox(height: 16),
                    AuthField(
                      label: 'Email Address',
                      hint: 'wajahat@email.com',
                      prefixIcon: Icons.email_outlined,
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      validator: emailValidator,
                    ),
                    const SizedBox(height: 16),
                    AuthField(
                      label: 'Password',
                      hint: '••••••••',
                      prefixIcon: Icons.lock_outline_rounded,
                      controller: _password,
                      obscure: _obscurePass,
                      suffixIcon: passwordToggle(_obscurePass, () => setState(() => _obscurePass = !_obscurePass)),
                      validator: passwordValidator,
                    ),
                    const SizedBox(height: 16),
                    AuthField(
                      label: 'Confirm Password',
                      hint: '••••••••',
                      prefixIcon: Icons.lock_outline_rounded,
                      controller: _confirm,
                      obscure: _obscureConfirm,
                      suffixIcon: passwordToggle(_obscureConfirm, () => setState(() => _obscureConfirm = !_obscureConfirm)),
                      validator: (v) {
                        if (requiredValidator(v, 'confirm password') != null) return requiredValidator(v, 'confirm password');
                        if (v != _password.text) return 'Passwords do not match';
                        return null;
                      },
                    ),
                    const SizedBox(height: 28),
                    AuthButton(label: 'Create Account', isLoading: _loading, onPressed: _submit),
                    const SizedBox(height: 24),
                    RedirectLink(
                      question: 'Already have an account? ',
                      actionLabel: 'Login',
                      onTap: () {
                        // Pop back to LoginScreen
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}
