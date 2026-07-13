import 'dart:async';
import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userModel = await AuthService().getCurrentUserData();
      final bool isAdmin = userModel?.role == 'admin';
      if (mounted) {
        Navigator.pushReplacementNamed(context, isAdmin ? '/admin' : '/home');
      }
    } else {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // CyberGuardian logo
            Image.asset(
              'assets/images/cyberguardian_logo.png',
              width: 200,
              height: 200,
            ),
            SizedBox(height: 16),
            Text(
              'CyberGuardian',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: dark,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Your Cybersecurity Companion',
              style: TextStyle(
                fontSize: 16,
                color: grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

