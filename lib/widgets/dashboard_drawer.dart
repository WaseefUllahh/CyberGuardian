import 'package:flutter/material.dart';
import '../utils/auth_utils.dart';

class DashboardDrawer extends StatelessWidget {
  const DashboardDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          // ── Drawer Header ──
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 52, 20, 28),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1B5E20), Color(0xFF2E7D32)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/images/cyberguardian_logo.png',
                  width: 72,
                  height: 72,
                ),
                const SizedBox(height: 14),
                const Text(
                  'Waseef Ullah', // Updated name to match dashboard
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'waseef@email.com',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    '🛡️  Protected',
                    style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),

          // ── Navigation Items ──
          const SizedBox(height: 8),
          _drawerNavItem(
            context,
            icon: Icons.home_rounded,
            label: 'Home',
            onTap: () => Navigator.pop(context), // just close drawer
          ),
          _drawerNavItem(
            context,
            icon: Icons.document_scanner_outlined,
            label: 'Scanner',
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/scanner');
            },
          ),
          _drawerNavItem(
            context,
            icon: Icons.description_outlined,
            label: 'Reports',
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/reports');
            },
          ),
          _drawerNavItem(
            context,
            icon: Icons.person_outline,
            label: 'Profile',
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/profile');
            },
          ),

          const Spacer(),
          const Divider(indent: 16, endIndent: 16),

          // ── Logout ──
          _drawerNavItem(
            context,
            icon: Icons.logout_rounded,
            label: 'Logout',
            iconColor: Colors.red,
            labelColor: Colors.red,
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(
                context, '/login', (route) => false);
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _drawerNavItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color iconColor = dark,
    Color labelColor = dark,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor, size: 24),
      title: Text(
        label,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: labelColor,
        ),
      ),
      trailing: Icon(Icons.chevron_right, color: grey.withOpacity(0.5), size: 20),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      horizontalTitleGap: 8,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
    );
  }
}
