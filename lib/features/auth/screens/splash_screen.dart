import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../services/auth_service.dart';
import '../../onboarding/services/onboarding_service.dart';
import '../../../shared/widgets/brand_logo.dart';

/// Initial screen shown while the app checks Firebase authentication state.
///
/// Navigation priority:
///   1. Already logged-in user   → Home or Admin (skip onboarding entirely)
///   2. First-ever launch        → Onboarding tutorial
///   3. Returning guest          → Login screen
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
      // Logged-in user → go straight to the app shell
      final userModel = await AuthService().getCurrentUserData();
      final bool isAdmin = userModel?.role == 'admin';
      if (mounted) {
        Navigator.pushReplacementNamed(context, isAdmin ? '/admin' : '/home');
      }
    } else {
      // Not logged in — check if this is the very first launch
      final seenOnboarding = await OnboardingService().hasSeenOnboarding();
      if (mounted) {
        Navigator.pushReplacementNamed(
          context,
          seenOnboarding ? '/login' : '/onboarding',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Premium logo: circular gradient bg + glow shadow
            const BrandLogo(size: 200),
            const SizedBox(height: 16),
            Text(
              'CyberGuardian',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: dark,
              ),
            ),
            const SizedBox(height: 8),
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



