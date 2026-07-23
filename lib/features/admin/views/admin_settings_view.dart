import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../core/theme/app_colors.dart';

class AdminSettingsView extends StatefulWidget {
  const AdminSettingsView({super.key});

  @override
  State<AdminSettingsView> createState() => _AdminSettingsViewState();
}

class _AdminSettingsViewState extends State<AdminSettingsView> {
  bool _maintenanceMode = false;
  bool _autoBanEnabled = true;
  bool _debugLogging = false;
  bool _globalAlerts = true;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(PhosphorIcons.gear(), color: green, size: 28),
              const SizedBox(width: 12),
              Text('System Settings', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: isDark ? Colors.white : dark)),
            ],
          ),
          const SizedBox(height: 8),
          Text('Configure global platform behavior and security thresholds.', style: TextStyle(fontSize: 14, color: isDark ? Colors.grey.shade400 : Colors.grey.shade600)),
          const SizedBox(height: 32),

          _buildSectionHeader('General Configuration', PhosphorIcons.sliders(), isDark),
          _buildSwitchTile('Maintenance Mode', 'Disable access for non-admin users', _maintenanceMode, (val) => setState(() => _maintenanceMode = val), isDark),
          _buildSwitchTile('Global Alerts', 'Show system-wide banner alerts to all users', _globalAlerts, (val) => setState(() => _globalAlerts = val), isDark),

          const SizedBox(height: 24),
          _buildSectionHeader('Security Policies', PhosphorIcons.shieldCheck(), isDark),
          _buildSwitchTile('Auto-Ban Enabled', 'Automatically ban users who fail multiple phishing checks', _autoBanEnabled, (val) => setState(() => _autoBanEnabled = val), isDark),
          
          const SizedBox(height: 24),
          _buildSectionHeader('Developer & Logging', PhosphorIcons.terminalWindow(), isDark),
          _buildSwitchTile('Debug Logging', 'Enable verbose system logs for troubleshooting', _debugLogging, (val) => setState(() => _debugLogging = val), isDark),
          
          const SizedBox(height: 32),
          SizedBox(
            width: 200,
            child: ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Settings saved successfully!')));
              },
              icon: Icon(PhosphorIcons.floppyDisk()),
              label: const Text('Save Changes', style: TextStyle(fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, size: 20, color: green),
          const SizedBox(width: 8),
          Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : dark)),
        ],
      ),
    );
  }

  Widget _buildSwitchTile(String title, String subtitle, bool value, Function(bool) onChanged, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? const Color(0xFF333333) : const Color(0xFFEEEEEE)),
      ),
      child: SwitchListTile(
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : dark)),
        subtitle: Text(subtitle, style: TextStyle(fontSize: 12, color: isDark ? Colors.grey.shade400 : Colors.grey.shade600)),
        value: value,
        activeThumbColor: green,
        onChanged: onChanged,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}




