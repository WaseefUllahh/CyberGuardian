import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';
import '../utils/app_colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _logout(BuildContext context) async {
    await AuthService().logout();
    if (context.mounted) {
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _logout(context);
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(dynamic ts) {
    if (ts == null) return '—';
    try {
      final dt = (ts as dynamic).toDate() as DateTime;
      return '${dt.day}/${dt.month}/${dt.year}  ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return '—';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF5F5F5),
      body: StreamBuilder<UserModel?>(
        stream: AuthService().getCurrentUserDataStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final user = snapshot.data;
          final name = user?.name ?? 'User';
          final email = user?.email ?? '—';

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),

                  // ── Profile Header Card ──────────────────────────────
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF1B5E20), Color(0xFF2E7D32)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        // Avatar
                        CircleAvatar(
                          radius: 46,
                          backgroundColor: Colors.white.withValues(alpha: 0.2),
                          backgroundImage: (user?.photoUrl != null && user!.photoUrl!.isNotEmpty)
                              ? NetworkImage(user.photoUrl!)
                              : null,
                          child: (user?.photoUrl == null || user!.photoUrl!.isEmpty)
                              ? Icon(PhosphorIcons.identificationBadge(), size: 52, color: Colors.white)
                              : null,
                        ),
                        const SizedBox(height: 14),
                        Text(name,
                            style: const TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                        const SizedBox(height: 4),
                        Text(email,
                            style: const TextStyle(color: Colors.white70, fontSize: 13)),
                        const SizedBox(height: 16),

                        // Security Score + Grade row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _statChip('Score', '${user?.securityScore ?? 100}', PhosphorIcons.shieldCheck()),
                            const SizedBox(width: 12),
                            _statChip('Grade', user?.securityGrade ?? 'A+', PhosphorIcons.medal()),
                            const SizedBox(width: 12),
                            _statChip('Status', user?.accountStatus ?? 'Active', PhosphorIcons.checkCircle()),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ── Firestore Data Card ──────────────────────────────
                  _sectionLabel('Account Information'),
                  const SizedBox(height: 10),
                  _infoCard(children: [
                    _infoRow(PhosphorIcons.user(), 'Full Name', name),
                    _divider(),
                    _infoRow(PhosphorIcons.envelope(), 'Email', email),
                    _divider(),
                    _infoRow(PhosphorIcons.fingerprint(), 'Role', user?.role ?? 'user'),
                    _divider(),
                    _infoRow(PhosphorIcons.calendar(), 'Member Since', _formatTimestamp(user?.createdAt)),
                    _divider(),
                    _infoRow(PhosphorIcons.clockClockwise(), 'Last Login', _formatTimestamp(user?.lastLogin)),
                  ]),

                  const SizedBox(height: 20),

                  // ── Scan Statistics ───────────────────────────────────
                  _sectionLabel('Scan Statistics'),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(child: _scanStatCard('Total Scans', '${user?.totalScans ?? 0}',
                          AppColors.brandGreen, PhosphorIcons.scan())),
                      const SizedBox(width: 10),
                      Expanded(child: _scanStatCard('Safe', '${user?.safeScans ?? 0}',
                          AppColors.statusSafeGreen, PhosphorIcons.checkCircle())),
                      const SizedBox(width: 10),
                      Expanded(child: _scanStatCard('Unsafe', '${user?.unsafeScans ?? 0}',
                          AppColors.statusWarningRed, PhosphorIcons.warningCircle())),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // ── Account Actions ───────────────────────────────────
                  _sectionLabel('Account'),
                  const SizedBox(height: 10),
                  _buildTile(context, PhosphorIcons.userGear(), 'Edit Profile',
                      () => Navigator.pushNamed(context, '/edit-profile')),
                  _buildTile(context, PhosphorIcons.lockKey(), 'Change Password',
                      () => Navigator.pushNamed(context, '/change-password')),
                  _buildTile(context, PhosphorIcons.shield(), 'Two-Factor Authentication',
                      () => Navigator.pushNamed(context, '/two-factor')),

                  const SizedBox(height: 20),

                  // ── Preferences ───────────────────────────────────────
                  _sectionLabel('Preferences'),
                  const SizedBox(height: 10),
                  Consumer<ThemeProvider>(
                    builder: (context, themeProvider, child) {
                      final isDark = themeProvider.themeMode == ThemeMode.dark;
                      final cardColor = Theme.of(context).cardTheme.color ?? Colors.white;
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: SwitchListTile(
                          title: Text('Dark Mode',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: isDark ? Colors.white : AppColors.dark,
                                  fontSize: 14)),
                          secondary: Icon(
                              isDark ? PhosphorIcons.moon() : PhosphorIcons.sun(),
                              color: AppColors.brandGreen,
                              size: 22),
                          value: isDark,
                          activeThumbColor: AppColors.brandGreen,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          onChanged: (value) => themeProvider.toggleTheme(value),
                        ),
                      );
                    }
                  ),
                  _buildTile(context, PhosphorIcons.bell(), 'Notifications',
                      () => Navigator.pushNamed(context, '/notifications')),
                  _buildTile(context, PhosphorIcons.translate(), 'Language',
                      () => Navigator.pushNamed(context, '/language')),

                  const SizedBox(height: 20),

                  // ── Support ───────────────────────────────────────────
                  _sectionLabel('Support'),
                  const SizedBox(height: 10),
                  _buildTile(context, PhosphorIcons.question(), 'Help Center',
                      () => Navigator.pushNamed(context, '/help-center')),
                  _buildTile(context, PhosphorIcons.info(), 'About CyberGuardian',
                      () => Navigator.pushNamed(context, '/about')),
                  _buildTile(context, PhosphorIcons.shieldCheck(), 'Privacy Policy',
                      () => Navigator.pushNamed(context, '/privacy')),

                  const SizedBox(height: 28),

                  // ── Logout Button ─────────────────────────────────────
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _showLogoutDialog(context),
                      icon: Icon(PhosphorIcons.signOut()),
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
                  const SizedBox(height: 28),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ── Helper Widgets ──────────────────────────────────────────────────────────

  Widget _sectionLabel(String label) {
    return Builder(builder: (context) {
      final isDark = Theme.of(context).brightness == Brightness.dark;
      return Text(label,
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColors.dark));
    });
  }

  Widget _infoCard({required List<Widget> children}) {
    return Builder(builder: (context) {
      final isDark = Theme.of(context).brightness == Brightness.dark;
      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            borderRadius: BorderRadius.circular(16)),
        child: Column(children: children),
      );
    });
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Builder(builder: (context) {
      final isDark = Theme.of(context).brightness == Brightness.dark;
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: AppColors.brandGreen, size: 20),
            const SizedBox(width: 12),
            Text(label,
                style: TextStyle(
                    fontSize: 13,
                    color: isDark ? const Color(0xFFAAAAAA) : AppColors.grey,
                    fontWeight: FontWeight.w500)),
            const Spacer(),
            Flexible(
              child: Text(value,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                      fontSize: 14,
                      color: isDark ? Colors.white : AppColors.dark,
                      fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      );
    });
  }

  Widget _divider() => Builder(builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Divider(
            height: 1,
            indent: 48,
            endIndent: 16,
            color: isDark ? const Color(0xFF333333) : const Color(0xFFEEEEEE));
      });

  Widget _statChip(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white70, size: 18),
          const SizedBox(height: 4),
          Text(value,
              style: const TextStyle(
                  color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          Text(label,
              style: const TextStyle(color: Colors.white60, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _scanStatCard(String label, String value, Color color, IconData icon) {
    return Builder(builder: (context) {
      final isDark = Theme.of(context).brightness == Brightness.dark;
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            borderRadius: BorderRadius.circular(14)),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 6),
            Text(value,
                style: TextStyle(
                    fontSize: 22, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 2),
            Text(label,
                style: TextStyle(
                    fontSize: 11,
                    color: isDark ? const Color(0xFFAAAAAA) : AppColors.grey)),
          ],
        ),
      );
    });
  }

  Widget _buildTile(
      BuildContext context, IconData icon, String title, VoidCallback onTap) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        leading: Icon(icon, color: AppColors.brandGreen),
        title: Text(title,
            style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 15,
                color: isDark ? Colors.white : AppColors.dark)),
        trailing:
            Icon(PhosphorIcons.caretRight(),
                color: isDark ? const Color(0xFF666666) : AppColors.grey,
                size: 20),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        onTap: onTap,
      ),
    );
  }
}