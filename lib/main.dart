import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
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
      home: const SplashScreen(),
    );
  }
}