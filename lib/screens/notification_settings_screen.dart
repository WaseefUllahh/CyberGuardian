import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../services/auth_service.dart';
import '../services/profile_service.dart';
import '../utils/app_colors.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  bool _alertsEnabled = true;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final user = await AuthService().getCurrentUserData();
    if (mounted) {
      setState(() {
        _alertsEnabled = user?.alertsEnabled ?? true;
        _isLoading = false;
      });
    }
  }

  Future<void> _toggle(bool value) async {
    setState(() => _alertsEnabled = value);
    final user = await AuthService().getCurrentUserData();
    if (user != null) {
      await ProfileService().updateProfile(user.uid, alertsEnabled: value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Notification Settings',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.brandGreen,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E1E1E) : Colors.white, borderRadius: BorderRadius.circular(14)),
                    child: SwitchListTile(
                      secondary: Icon(PhosphorIcons.bell(), color: AppColors.brandGreen),
                      title: Text('Security Alerts',
                          style: TextStyle(fontWeight: FontWeight.w600, color: isDark ? Colors.white : AppColors.dark)),
                      subtitle: Text('Get notified about threats and scans',
                          style: TextStyle(fontSize: 12, color: isDark ? const Color(0xFFAAAAAA) : AppColors.grey)),
                      value: _alertsEnabled,
                      activeThumbColor: AppColors.brandGreen,
                      onChanged: _toggle,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}