import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../services/auth_service.dart';
import '../../../providers/theme_provider.dart';

// Import all views
import '../views/admin_dashboard_view.dart';
import '../views/admin_users_view.dart';
import '../views/admin_scan_history_view.dart';
import '../views/admin_scam_reports_view.dart';
import '../views/admin_learning_manager_view.dart';
import '../views/admin_quiz_manager_view.dart';
import '../views/admin_notifications_view.dart';
import '../views/admin_analytics_view.dart';
import '../views/admin_api_monitor_view.dart';
import '../views/admin_system_health_view.dart';
import '../views/admin_report_export_view.dart';
import '../views/admin_settings_view.dart';
import '../views/admin_profile_view.dart';
import '../views/admin_activity_log_view.dart';
import '../views/admin_global_search_view.dart';

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  int _currentIndex = 0;

  final List<String> _titles = [
    'Dashboard',
    'Users',
    'Scan History',
    'Scam Reports',
    'Learning Modules',
    'Quiz Management',
    'Notifications',
    'Analytics',
    'API Monitor',
    'System Health',
    'Report Export',
    'Settings',
    'Admin Profile',
    'Activity Log',
    'Global Search',
  ];

  final List<IconData> _icons = [
    PhosphorIcons.squaresFour(),
    PhosphorIcons.users(),
    PhosphorIcons.clockCounterClockwise(),
    PhosphorIcons.flagBanner(),
    PhosphorIcons.bookOpen(),
    PhosphorIcons.question(),
    PhosphorIcons.bell(),
    PhosphorIcons.chartLineUp(),
    PhosphorIcons.plugsConnected(),
    PhosphorIcons.heartbeat(),
    PhosphorIcons.filePdf(),
    PhosphorIcons.gear(),
    PhosphorIcons.userCircle(),
    PhosphorIcons.listBullets(),
    PhosphorIcons.magnifyingGlass(),
  ];

  final List<Widget> _views = [
    const AdminDashboardView(),
    const AdminUsersView(),
    const AdminScanHistoryView(),
    const AdminScamReportsView(),
    const AdminLearningManagerView(),
    const AdminQuizManagerView(),
    const AdminNotificationsView(),
    const AdminAnalyticsView(),
    const AdminApiMonitorView(),
    const AdminSystemHealthView(),
    const AdminReportExportView(),
    const AdminSettingsView(),
    const AdminProfileView(),
    const AdminActivityLogView(),
    const AdminGlobalSearchView(),
  ];

  void _logout() async {
    await AuthService().logout();
    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }
  }

  void _onMenuTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Widget _buildDrawer(bool isDark) {
    return Drawer(
      backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      surfaceTintColor: Colors.transparent,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            alignment: Alignment.centerLeft,
            decoration: const BoxDecoration(
              color: Color(0xFF1B5E20),
            ),
            child: const SafeArea(
              bottom: false,
              child: Text(
                'CyberGuardian\nAdmin',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 10),
              itemCount: _titles.length,
              itemBuilder: (context, index) {
                final isSelected = _currentIndex == index;
                return ListTile(
                  leading: Icon(
                    _icons[index],
                    color: isSelected ? green : (isDark ? Colors.white70 : grey),
                  ),
                  title: Text(
                    _titles[index],
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? green : (isDark ? Colors.white : dark),
                    ),
                  ),
                  selected: isSelected,
                  selectedTileColor: green.withValues(alpha: 0.1),
                  onTap: () {
                    _onMenuTap(index);
                    if (!isDesktop(context)) {
                      Navigator.pop(context);
                    }
                  },
                );
              },
            ),
          ),
          const Divider(),
          // Dark Mode Toggle
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Consumer<ThemeProvider>(
              builder: (context, tp, _) {
                final currentlyDark = tp.themeMode == ThemeMode.dark;
                return InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => tp.toggleTheme(!currentlyDark),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF0F0F0),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: isDark ? const Color(0xFF444444) : Colors.grey.shade300),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          currentlyDark ? PhosphorIcons.moon() : PhosphorIcons.sun(),
                          color: currentlyDark ? Colors.amber : const Color(0xFFFF8F00),
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            currentlyDark ? 'Dark Mode' : 'Light Mode',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white : dark,
                            ),
                          ),
                        ),
                        Switch(
                          value: currentlyDark,
                          onChanged: (val) => tp.toggleTheme(val),
                          activeThumbColor: green,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text(
              'Logout',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
            onTap: _logout,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  bool isDesktop(BuildContext context) => MediaQuery.of(context).size.width >= 900;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final desktop = isDesktop(context);

    final bodyContent = Container(
      color: isDark ? const Color(0xFF121212) : const Color(0xFFF5F5F5),
      child: _views[_currentIndex],
    );

    return Scaffold(
      appBar: desktop
          ? null
          : AppBar(
              title: Text(_titles[_currentIndex],
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              backgroundColor: const Color(0xFF1B5E20),
              iconTheme: const IconThemeData(color: Colors.white),
              actions: [
                Consumer<ThemeProvider>(
                  builder: (context, tp, _) {
                    final currentlyDark = tp.themeMode == ThemeMode.dark;
                    return IconButton(
                      tooltip: currentlyDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
                      icon: Icon(
                        currentlyDark ? PhosphorIcons.sun() : PhosphorIcons.moon(),
                        color: Colors.white,
                      ),
                      onPressed: () => tp.toggleTheme(!currentlyDark),
                    );
                  },
                ),
              ],
            ),
      drawer: desktop ? null : _buildDrawer(isDark),
      body: desktop
          ? Row(
              children: [
                SizedBox(
                  width: 250,
                  child: _buildDrawer(isDark),
                ),
                Expanded(child: bodyContent),
              ],
            )
          : bodyContent,
    );
  }
}






