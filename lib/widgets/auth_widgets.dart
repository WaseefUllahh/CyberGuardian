import 'package:flutter/material.dart';
import '../utils/auth_utils.dart';

class AuthField extends StatelessWidget {
  final String label, hint;
  final IconData prefixIcon;
  final TextEditingController controller;
  final bool obscure;
  final TextInputType keyboardType;
  final Widget? suffixIcon;
  final String? Function(String?) validator;

  const AuthField({
    super.key,
    required this.label,
    required this.hint,
    required this.prefixIcon,
    required this.controller,
    required this.validator,
    this.obscure = false,
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: dark)),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            obscureText: obscure,
            keyboardType: keyboardType,
            validator: validator,
            decoration: InputDecoration(
              hintText: hint,
              prefixIcon: Icon(prefixIcon, color: grey),
              suffixIcon: suffixIcon,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: green, width: 1.5),
              ),
            ),
          ),
        ],
      );
}

class AuthButton extends StatelessWidget {
  final String label;
  final bool isLoading;
  final VoidCallback onPressed;

  const AuthButton({super.key, required this.label, required this.isLoading, required this.onPressed});

  @override
  Widget build(BuildContext context) => ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: green,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
        ),
        child: isLoading
            ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
            : Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      );
}

class AuthHeader extends StatelessWidget {
  final IconData icon;
  final String title, subtitle;
  const AuthHeader({super.key, required this.icon, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) => Column(
        children: [
          const SizedBox(height: 8),
          Image.asset(
            'assets/images/cyberguardian_logo.png',
            width: 120,
            height: 120,
          ),
          const SizedBox(height: 16),
          Text(title, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: dark)),
          const SizedBox(height: 8),
          Text(subtitle, style: const TextStyle(fontSize: 14, color: grey), textAlign: TextAlign.center),
        ],
      );
}

class RedirectLink extends StatelessWidget {
  final String question, actionLabel;
  final VoidCallback onTap;
  const RedirectLink({super.key, required this.question, required this.actionLabel, required this.onTap});

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(question, style: const TextStyle(color: grey, fontSize: 14)),
          GestureDetector(
            onTap: onTap,
            child: Text(actionLabel, style: const TextStyle(color: green, fontWeight: FontWeight.bold, fontSize: 14)),
          ),
        ],
      );
}

Widget passwordToggle(bool obscure, VoidCallback onTap) => IconButton(
      icon: Icon(obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: grey),
      onPressed: onTap,
    );
