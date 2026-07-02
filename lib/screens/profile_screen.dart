import 'package:flutter/material.dart';
import '../utils/auth_utils.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _logout(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/login',
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            children: [
              const SizedBox(height: 20),
              // ── Avatar ──
              const CircleAvatar(
                radius: 50,
                backgroundColor: Color(0xFFE8F5E9),
                child: Icon(Icons.person, size: 56, color: green),
              ),
              const SizedBox(height: 16),
              const Text('Wajahat',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: dark)),
              const SizedBox(height: 4),
              const Text('wajahat@email.com',
                  style: TextStyle(color: grey, fontSize: 14)),
              const SizedBox(height: 28),

              // ── Account Section ──
              _buildSectionLabel('Account'),
              const SizedBox(height: 10),
              _buildTile(Icons.person_outline, 'Edit Profile', () {}),
              _buildTile(Icons.lock_outline, 'Change Password', () {}),
              _buildTile(Icons.security, 'Two-Factor Authentication', () {}),
              const SizedBox(height: 24),

              // ── Preferences ──
              _buildSectionLabel('Preferences'),
              const SizedBox(height: 10),
              _buildTile(Icons.notifications_outlined, 'Notifications', () {}),
              _buildTile(Icons.language, 'Language', () {}),
              _buildTile(Icons.dark_mode_outlined, 'Dark Mode', () {}),
              const SizedBox(height: 24),

              // ── Support ──
              _buildSectionLabel('Support'),
              const SizedBox(height: 10),
              _buildTile(Icons.help_outline, 'Help Center', () {}),
              _buildTile(Icons.info_outline, 'About CyberGuardian', () {}),
              _buildTile(Icons.privacy_tip_outlined, 'Privacy Policy', () {}),
              const SizedBox(height: 28),

              // ── Logout ──
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _logout(context),
                  icon: const Icon(Icons.logout),
                  label: const Text('Logout', style: TextStyle(fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade50,
                    foregroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: grey)),
    );
  }

  Widget _buildTile(IconData icon, String title, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        leading: Icon(icon, color: green),
        title: Text(title,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15, color: dark)),
        trailing: const Icon(Icons.chevron_right, color: grey, size: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        onTap: onTap,
      ),
    );
  }
}
