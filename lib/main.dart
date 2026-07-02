import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/main_navigation_screen.dart';
import 'screens/scanner_screen.dart';
import 'screens/reports_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/submit_report_screen.dart';
import 'utils/auth_utils.dart';

void main() {
  runApp(const CyberGuardianApp());
}

class CyberGuardianApp extends StatelessWidget {
  const CyberGuardianApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CyberGuardian',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: green),
        useMaterial3: true,
      ),
      // ── Named Routes ──────────────────────────────────────────────────────
      initialRoute: '/',
      routes: {
        '/':              (context) => const SplashScreen(),
        '/login':         (context) => const LoginScreen(),
        '/signup':        (context) => const SignUpScreen(),
        '/home':          (context) => const MainNavigationScreen(),
        '/scanner':       (context) => const ScannerScreen(),
        '/reports':       (context) => const ReportsScreen(),
        '/profile':       (context) => const ProfileScreen(),
        '/submit-report': (context) => const SubmitReportScreen(),
      },
    );
  }
}