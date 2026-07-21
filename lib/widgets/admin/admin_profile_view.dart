import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../utils/app_colors.dart';
import '../../services/auth_service.dart';
import '../../models/user_model.dart';

class AdminProfileView extends StatelessWidget {
  const AdminProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final authService = AuthService();

    return StreamBuilder<UserModel?>(
      stream: authService.getCurrentUserDataStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final user = snapshot.data;
        final name = user?.name ?? 'Admin';
        final email = user?.email ?? '';
        final initials = name.isNotEmpty ? name[0].toUpperCase() : 'A';

        return SingleChildScrollView(
          child: Column(
            children: [
              // ── Header Banner ──
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF1B5E20), Color(0xFF388E3C)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 48,
                      backgroundColor: Colors.white.withOpacity(0.2),
                      backgroundImage: (user?.photoUrl != null && user!.photoUrl!.isNotEmpty)
                          ? NetworkImage(user.photoUrl!)
                          : null,
                      child: (user?.photoUrl == null || user!.photoUrl!.isEmpty)
                          ? Text(initials, style: const TextStyle(fontSize: 38, fontWeight: FontWeight.bold, color: Colors.white))
                          : null,
                    ),
                    const SizedBox(height: 16),
                    Text(name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                    const SizedBox(height: 4),
                    Text(email, style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.8))),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withOpacity(0.4)),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.admin_panel_settings, color: Colors.white, size: 16),
                          SizedBox(width: 6),
                          Text('Administrator', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Account Info ──
                    Text('Account Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : dark)),
                    const SizedBox(height: 12),
                    _infoCard(isDark, [
                      _infoRow(isDark, PhosphorIcons.user(), 'Full Name', name),
                      _infoRow(isDark, PhosphorIcons.envelope(), 'Email', email),
                      _infoRow(isDark, PhosphorIcons.shieldCheck(), 'Role', user?.role.toUpperCase() ?? 'ADMIN'),
                      _infoRow(isDark, PhosphorIcons.calendarBlank(), 'Member Since',
                        user != null ? _formatDate(user.createdAt.toDate()) : '—'),
                      _infoRow(isDark, PhosphorIcons.clockCounterClockwise(), 'Last Login',
                        user != null ? _formatDate(user.lastLogin.toDate()) : '—'),
                      _infoRow(isDark, PhosphorIcons.checkCircle(), 'Status', user?.accountStatus ?? 'Active'),
                    ]),

                    const SizedBox(height: 24),

                    // ── Security Stats ──
                    Text('Security Score', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : dark)),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10)],
                        border: Border.all(color: isDark ? const Color(0xFF333333) : const Color(0xFFEEEEEE)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _scoreChip('${user?.securityScore ?? 100}', 'Score', green),
                          _scoreChip(user?.securityGrade ?? 'A+', 'Grade', Colors.blue),
                          _scoreChip(user?.accountStatus ?? 'Active', 'Status', Colors.teal),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ── Quick Actions ──
                    Text('Admin Actions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : dark)),
                    const SizedBox(height: 12),
                    _actionTile(context, isDark, PhosphorIcons.lock(), 'Change Password', 'Update your admin password', () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Password change flow coming soon.')));
                    }),
                    const SizedBox(height: 10),
                    _actionTile(context, isDark, PhosphorIcons.signOut(), 'Logout', 'Sign out of the admin panel', () async {
                      await AuthService().logout();
                      if (context.mounted) {
                        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                      }
                    }, isDestructive: true),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatDate(DateTime d) =>
      '${d.day}/${d.month}/${d.year}  ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';

  Widget _infoCard(bool isDark, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10)],
        border: Border.all(color: isDark ? const Color(0xFF333333) : const Color(0xFFEEEEEE)),
      ),
      child: Column(children: children),
    );
  }

  Widget _infoRow(bool isDark, IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: [
          Icon(icon, color: green, size: 20),
          const SizedBox(width: 16),
          Expanded(
            child: Text(label, style: TextStyle(color: isDark ? Colors.grey.shade400 : Colors.grey.shade600, fontSize: 14)),
          ),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: isDark ? Colors.white : dark)),
        ],
      ),
    );
  }

  Widget _scoreChip(String value, String label, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
          child: Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
        ),
        const SizedBox(height: 6),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
      ],
    );
  }

  Widget _actionTile(BuildContext context, bool isDark, IconData icon, String title, String subtitle, VoidCallback onTap, {bool isDestructive = false}) {
    final color = isDestructive ? Colors.red : green;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isDestructive ? Colors.red.withOpacity(0.3) : (isDark ? const Color(0xFF333333) : const Color(0xFFEEEEEE))),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: color)),
                  Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                ],
              ),
            ),
            Icon(PhosphorIcons.caretRight(), color: Colors.grey.shade400, size: 18),
          ],
        ),
      ),
    );
  }
}
