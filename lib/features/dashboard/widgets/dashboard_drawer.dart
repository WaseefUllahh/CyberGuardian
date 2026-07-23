import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/brand_logo.dart';
import '../../../utils/user_store.dart';
import '../../../services/auth_service.dart';

/// Side drawer shown from the dashboard via the hamburger menu.
///
/// Displays user name, email, and navigation shortcuts.
class DashboardDrawer extends StatelessWidget {
  const DashboardDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AuthService().getCurrentUserDataStream(),
      builder: (context, snapshot) {
        final user = snapshot.data ?? UserStore().currentUser;
        final name = user?.name ?? 'User';
        final email = user?.email ?? 'user@email.com';
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final drawerBg = isDark ? const Color(0xFF1A1A2E) : Colors.white;
        final textColor = isDark ? Colors.white : AppColors.dark;
        final subtitleColor = isDark ? const Color(0xFFAAAAAA) : AppColors.grey;
        final dividerColor =
            isDark ? const Color(0xFF333333) : const Color(0xFFEEEEEE);

        return Drawer(
          backgroundColor: drawerBg,
          child: Stack(
            children: [
              // Background watermark logo
              Positioned(
                bottom: 90,
                left: 0,
                right: 0,
                child: Center(
                  child: Opacity(
                    opacity: isDark ? 0.04 : 0.06,
                    child: Image.asset(
                      'assets/images/cyberguardian_logo.png',
                      width: 220,
                      height: 220,
                      // Tint watermark to brand green so it blends with the theme
                      color: const Color(0xFF2E7D32),
                      colorBlendMode: BlendMode.srcIn,
                    ),
                  ),
                ),
              ),

              Column(
                children: [
                  // Drawer Header
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
                        // onGreen style: semi-transparent white circle on green gradient
                        const BrandLogo(
                          size: 72,
                          style: BrandLogoStyle.onGreen,
                        ),
                        const SizedBox(height: 14),
                        Text(name,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(height: 2),
                        Text(email,
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 13)),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.25),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: Image.asset(
                                  'assets/images/cyberguardian_logo.png',
                                  height: 24,
                                  width: 24,
                                  filterQuality: FilterQuality.high,
                                  // White tint: badge sits on green gradient
                                  color: Colors.white,
                                  colorBlendMode: BlendMode.srcIn,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text('Protected',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Navigation Items
                  const SizedBox(height: 8),
                  _drawerNavItem(context,
                      icon: PhosphorIcons.house(),
                      label: 'Home',
                      textColor: textColor,
                      subtitleColor: subtitleColor,
                      onTap: () => Navigator.pop(context)),
                  _drawerNavItem(context,
                      icon: PhosphorIcons.scan(),
                      label: 'Scanner',
                      textColor: textColor,
                      subtitleColor: subtitleColor,
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/scanner');
                      }),
                  _drawerNavItem(context,
                      icon: PhosphorIcons.fileText(),
                      label: 'Reports',
                      textColor: textColor,
                      subtitleColor: subtitleColor,
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/reports');
                      }),
                  _drawerNavItem(context,
                      icon: PhosphorIcons.user(),
                      label: 'Profile',
                      textColor: textColor,
                      subtitleColor: subtitleColor,
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/profile');
                      }),

                  const Spacer(),
                  Divider(indent: 16, endIndent: 16, color: dividerColor),

                  // Logout
                  _drawerNavItem(context,
                      icon: PhosphorIcons.signOut(),
                      label: 'Logout',
                      iconColor: Colors.red,
                      textColor: Colors.red,
                      subtitleColor: Colors.red,
                      onTap: () async {
                        await UserStore().logout();
                        if (context.mounted) {
                          Navigator.pushNamedAndRemoveUntil(
                              context, '/login', (route) => false);
                        }
                      }),
                  const SizedBox(height: 16),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _drawerNavItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? iconColor,
    Color? textColor,
    Color? subtitleColor,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultTextColor = isDark ? Colors.white : AppColors.dark;
    final defaultIconColor = isDark ? Colors.white70 : AppColors.dark;
    final trailColor =
        isDark ? const Color(0xFF666666) : AppColors.grey.withValues(alpha: 0.5);

    return ListTile(
      leading: Icon(icon, color: iconColor ?? defaultIconColor, size: 24),
      title: Text(label,
          style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: textColor ?? defaultTextColor)),
      trailing:
          Icon(PhosphorIcons.caretRight(), color: trailColor, size: 20),
      onTap: onTap,
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      horizontalTitleGap: 8,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
    );
  }
}


