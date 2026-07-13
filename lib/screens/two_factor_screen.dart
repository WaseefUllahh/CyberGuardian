import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../utils/app_colors.dart';

class TwoFactorScreen extends StatelessWidget {
  const TwoFactorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Two-Factor Authentication',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.brandGreen,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 40),
            Icon(PhosphorIcons.shield(), size: 80, color: AppColors.brandGreen),
            const SizedBox(height: 24),
            Text('Two-Factor Authentication',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.dark),
                textAlign: TextAlign.center),
            const SizedBox(height: 12),
            Text(
                'Add an extra layer of security to your account. When enabled, you\'ll need to verify your identity with a second method.',
                style: TextStyle(fontSize: 14, color: AppColors.grey),
                textAlign: TextAlign.center),
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(14)),
              child: Row(
                children: [
                  Icon(PhosphorIcons.envelope(), color: AppColors.brandGreen, size: 28),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Email Verification',
                            style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.dark)),
                        Text('Receive a code via email',
                            style: TextStyle(fontSize: 12, color: AppColors.grey)),
                      ],
                    ),
                  ),
                  Switch(value: false, onChanged: (v) {}, activeColor: AppColors.brandGreen),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}