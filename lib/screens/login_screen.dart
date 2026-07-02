import 'package:flutter/material.dart';
import '../utils/auth_utils.dart';
import '../widgets/auth_widgets.dart';
import 'signup_screen.dart';
import 'main_navigation_screen.dart';

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

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) {
        setState(() => _loading = false);
        // Push replacement using MaterialPageRoute
        Navigator.pushReplacementNamed(context, '/home');
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
                      icon: Icons.lock_outline_rounded,
                      title: 'Welcome Back',
                      subtitle: 'Log in to access your security dashboard',
                    ),
                    const SizedBox(height: 36),
                    AuthField(
                      label: 'Email Address',
                      hint: 'wajahat@email.com',
                      prefixIcon: Icons.email_outlined,
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      validator: emailValidator,
                    ),
                    const SizedBox(height: 20),
                    AuthField(
                      label: 'Password',
                      hint: '••••••••',
                      prefixIcon: Icons.lock_outline_rounded,
                      controller: _password,
                      obscure: _obscure,
                      suffixIcon: passwordToggle(_obscure, () => setState(() => _obscure = !_obscure)),
                      validator: passwordValidator,
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Reset instructions sent to your email.'), backgroundColor: green),
                        ),
                        child: const Text('Forgot Password?',
                            style: TextStyle(color: green, fontWeight: FontWeight.bold, fontSize: 13)),
                      ),
                    ),
                    const SizedBox(height: 32),
                    AuthButton(label: 'Login', isLoading: _loading, onPressed: _submit),
                    const SizedBox(height: 24),
                    RedirectLink(
                      question: "Don't have an account? ",
                      actionLabel: 'Sign Up',
                      onTap: () {
                        // Push to SignUpScreen (user can pop back)
                      Navigator.pushNamed(context, '/signup');
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
