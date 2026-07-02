import 'dart:async';
import 'package:flutter/material.dart';
import '../utils/auth_utils.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // 3 seconds delay before transitioning to Login Screen
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
        );
      }
    });
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
