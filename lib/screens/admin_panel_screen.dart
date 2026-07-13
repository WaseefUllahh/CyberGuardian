import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../services/auth_service.dart';
import '../services/admin_service.dart';
import '../services/report_service.dart';
import '../models/user_model.dart';
import '../models/report_model.dart';
import '../widgets/report_widgets.dart';
import '../services/virus_total_service.dart';
import '../models/virus_total_result.dart';

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  int _currentIndex = 0;

  // ── API tab state ──────────────────────────────────────────────────────────
  final _apiKeyController = TextEditingController();
  bool _apiKeyObscured = true;
  bool _apiTestLoading = false;
  VirusTotalResult? _apiTestResult;

  @override
  void initState() {
    super.initState();
    // Pre-fill the controller with the saved API key if it exists
    _apiKeyController.text = VirusTotalService().apiKey;
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    super.dispose();
  }

  void _logout() async {
    await AuthService().logout();
    if (context.mounted) {
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }
  }

  void _saveApiKey() async {
    final key = _apiKeyController.text.trim();
    await VirusTotalService().saveApiKey(key);
    if (!mounted) return;
    setState(() {
      _apiTestResult = null;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(key.isEmpty ? 'API key cleared.' : 'API key saved!'),
        backgroundColor: key.isEmpty ? Colors.red : green,
      ),
    );
  }

  Future<void> _testConnection() async {
    if (!VirusTotalService().isConfigured) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Save an API key first.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    setState(() {
      _apiTestLoading = true;
      _apiTestResult = null;
    });
    final result = await VirusTotalService().testConnection();
    if (mounted) {
      setState(() {
        _apiTestLoading = false;
        _apiTestResult = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      _buildDashboardTab(),
      _buildUsersTab(),
      _buildReportsTab(),
      _buildSettingsTab(),
      _buildApiTab(),
    ];

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF121212) : const Color(0xFFF5F5F5);
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text('Admin Panel', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color(0xFF1B5E20),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: _logout,
          )
        ],
      ),
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF1B5E20),
        unselectedItemColor: isDark ? const Color(0xFFAAAAAA) : grey,
        backgroundColor: cardColor,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard_outlined), activeIcon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.people_outline), activeIcon: Icon(Icons.people), label: 'Users'),
          BottomNavigationBarItem(icon: Icon(Icons.description_outlined), activeIcon: Icon(Icons.description), label: 'Reports'),
          BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), activeIcon: Icon(Icons.settings), label: 'Settings'),
          BottomNavigationBarItem(icon: Icon(Icons.api_outlined), activeIcon: Icon(Icons.api), label: 'API'),
        ],
      ),
    );
  }

  // ─── Dashboard Tab ────────────────────────────────────────────────────────
  Widget _buildDashboardTab() {
    final adminService = AdminService();
    return Builder(builder: (context) {
      final isDark = Theme.of(context).brightness == Brightness.dark;
      return SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('System Overview', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: isDark ? Colors.white : dark)),
            const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: StreamBuilder<int>(
                stream: adminService.getTotalUsersCount(),
                builder: (context, snapshot) {
                  return _statCard('Total Users', snapshot.data?.toString() ?? '0', Icons.people, Colors.blue);
                }
              )),
              const SizedBox(width: 16),
              Expanded(child: _statCard('System Health', '100%', Icons.health_and_safety, green)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: StreamBuilder<int>(
                stream: adminService.getActiveScansCount(),
                builder: (context, snapshot) {
                  return _statCard('Total Scans', snapshot.data?.toString() ?? '0', Icons.radar, Colors.orange);
                }
              )),
              const SizedBox(width: 16),
              Expanded(child: StreamBuilder<int>(
                stream: adminService.getOpenReportsCount(),
                builder: (context, snapshot) {
                  return _statCard('Open Reports', snapshot.data?.toString() ?? '0', Icons.description, Colors.red);
                }
              )),
            ],
          ),
        ],
      ),
    );
    });
  }

  Widget _statCard(String title, String value, IconData icon, Color color) {
    return Builder(builder: (context) {
      final isDark = Theme.of(context).brightness == Brightness.dark;
      final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 12),
            Text(value, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: isDark ? Colors.white : dark)),
            const SizedBox(height: 4),
            Text(title, style: TextStyle(color: isDark ? const Color(0xFFAAAAAA) : grey, fontSize: 13, fontWeight: FontWeight.w500)),
          ],
        ),
      );
    });
  }

  // ─── Users Tab ────────────────────────────────────────────────────────────
  Widget _buildUsersTab() {
    return StreamBuilder<List<UserModel>>(
      stream: AdminService().getAllUsers(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        
        final users = snapshot.data ?? [];
        if (users.isEmpty) {
          return Center(child: Text('No users registered.', style: TextStyle(color: grey)));
        }

        return Builder(builder: (context) {
          final isDark = Theme.of(context).brightness == Brightness.dark;
          final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: users.length,
            itemBuilder: (context, index) {
              final u = users[index];
              return Card(
                color: cardColor,
                elevation: 0,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: isDark ? const Color(0xFF333333) : Colors.grey.shade200)),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: green.withValues(alpha: 0.1),
                    child: Text(u.name.isNotEmpty ? u.name[0].toUpperCase() : 'U', style: TextStyle(color: green, fontWeight: FontWeight.bold)),
                  ),
                  title: Text(u.name, style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : dark)),
                  subtitle: Text(u.email, style: TextStyle(color: isDark ? const Color(0xFFAAAAAA) : grey, fontSize: 12)),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () {
                      AdminService().deleteUser(u.uid);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('User deleted')));
                    },
                  ),
                ),
              );
            },
          );
        });
      }
    );
  }

  // ─── Reports Tab ──────────────────────────────────────────────────────────
  Widget _buildReportsTab() {
    return StreamBuilder<List<ReportModel>>(
      stream: ReportService().getAllReports(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        
        final reports = snapshot.data ?? [];
        if (reports.isEmpty) {
          return Center(child: Text('No reports available.', style: TextStyle(color: grey)));
        }
        
        return Builder(builder: (context) {
          final isDark = Theme.of(context).brightness == Brightness.dark;
          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: reports.length + 2, // Header + reports
            itemBuilder: (context, index) {
              if (index == 0) return Text('Recent Reports', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: isDark ? Colors.white : dark));
              if (index == 1) return const SizedBox(height: 16);
              
              final r = reports[index - 2];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: ReportItem(
                  title: r.category,
                  status: r.status,
                  time: 'Recent',
                  description: r.details,
                  severity: 'High',
                  categories: [r.source],
                ),
              );
            },
          );
        });
      }
    );
  }

  // ─── Settings Tab ─────────────────────────────────────────────────────────
  Widget _buildSettingsTab() {
    return Builder(builder: (context) {
      final isDark = Theme.of(context).brightness == Brightness.dark;
      final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
      return ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('Admin Settings', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: isDark ? Colors.white : dark)),
          const SizedBox(height: 16),
          ListTile(
            tileColor: cardColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            leading: Icon(Icons.admin_panel_settings, color: green),
            title: Text('Admin Role', style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : null)),
            subtitle: Text('Full system access', style: TextStyle(color: isDark ? const Color(0xFFAAAAAA) : null)),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _logout,
              icon: const Icon(Icons.logout),
              label: const Text('Logout', style: TextStyle(fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: isDark ? const Color(0xFF4A1A1A) : Colors.red.shade50,
                foregroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
            ),
          ),
        ],
      );
    });
  }

  // ─── API Tab ───────────────────────────────────────────────────────────────
  Widget _buildApiTab() {
    return Builder(builder: (context) {
      final bool configured = VirusTotalService().isConfigured;
      final isDark = Theme.of(context).brightness == Brightness.dark;
      final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;

      return SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'API Configuration',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: isDark ? Colors.white : dark),
            ),
            const SizedBox(height: 4),
            Text(
              'Manage external API keys used by CyberGuardian.',
              style: TextStyle(fontSize: 13, color: isDark ? const Color(0xFFAAAAAA) : grey),
            ),
            const SizedBox(height: 24),

            // ── VirusTotal Card ──
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Card Header ──
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF1B5E20).withValues(alpha: 0.2) : const Color(0xFFE8F5E9),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.shield_rounded, color: green, size: 26),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'VirusTotal',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: isDark ? Colors.white : dark,
                              ),
                            ),
                            Text(
                              'URL Scanning API · REST',
                              style: TextStyle(fontSize: 12, color: isDark ? const Color(0xFFAAAAAA) : grey),
                            ),
                          ],
                        ),
                      ),
                      // Status badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: configured
                              ? (isDark ? green.withValues(alpha: 0.1) : const Color(0xFFE8F5E9))
                              : (isDark ? Colors.orange.withValues(alpha: 0.1) : const Color(0xFFFFF3E0)),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: configured ? green : Colors.orange,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              configured ? Icons.circle : Icons.circle_outlined,
                              size: 8,
                              color: configured ? green : Colors.orange,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              configured ? 'Configured' : 'Not Set',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: configured ? green : Colors.orange,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  Divider(color: isDark ? const Color(0xFF333333) : const Color(0xFFEEEEEE)),
                  const SizedBox(height: 16),

                  // ── API Key Input ──
                  Text(
                    'API Key (Header: x-apikey)',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: isDark ? Colors.white : dark),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _apiKeyController,
                    obscureText: _apiKeyObscured,
                    style: TextStyle(fontSize: 13, fontFamily: 'monospace', color: isDark ? Colors.white : dark),
                    decoration: InputDecoration(
                      hintText: 'Paste your VirusTotal API key here...',
                      hintStyle: TextStyle(color: isDark ? const Color(0xFF666666) : grey, fontSize: 13),
                      filled: true,
                      fillColor: isDark ? const Color(0xFF2A2A2A) : Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: isDark ? const Color(0xFF333333) : grey.withValues(alpha: 0.3))),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: isDark ? const Color(0xFF333333) : grey.withValues(alpha: 0.3))),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: green, width: 1.5),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _apiKeyObscured ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                          color: isDark ? const Color(0xFFAAAAAA) : grey,
                          size: 20,
                        ),
                        onPressed: () => setState(() => _apiKeyObscured = !_apiKeyObscured),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // ── Setup hint ──
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1A3B22) : const Color(0xFFF1F8E9),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.info_outline_rounded, color: green, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(fontSize: 11, color: isDark ? const Color(0xFFCCCCCC) : dark, height: 1.5),
                              children: [
                                TextSpan(
                                  text: 'How to get a key: ',
                                  style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : dark),
                                ),
                                TextSpan(
                                  text: 'Go to virustotal.com → Sign up/Log in → Profile → API Key. Note: Free tier is limited to 4 requests/minute.',
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 16),

                // ── Action Buttons ──
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _saveApiKey,
                        icon: const Icon(Icons.save_outlined, size: 18),
                        label: const Text('Save Key', style: TextStyle(fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _apiTestLoading ? null : _testConnection,
                        icon: _apiTestLoading
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.wifi_tethering_rounded, size: 18),
                        label: Text(
                          _apiTestLoading ? 'Testing...' : 'Test Connection',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1565C0),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                      ),
                    ),
                  ],
                ),

                  // ── Test Result ──
                  if (_apiTestResult != null) ...
                    [
                      const SizedBox(height: 16),
                      _buildTestResultBanner(_apiTestResult!),
                    ],
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ── Endpoint Info ──
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Endpoint Details',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: isDark ? Colors.white : dark),
                  ),
                  const SizedBox(height: 12),
                  _endpointRow('Method', 'POST'),
                  _endpointRow('URL', 'virustotal.com/api/v3/urls'),
                  _endpointRow('Auth', 'x-apikey header'),
                  _endpointRow('Timeout', '15 seconds'),
                  _endpointRow('Threats checked',
                      'Malware, Phishing, Suspicious activity'),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildTestResultBanner(VirusTotalResult result) {
    final Color accent = result.isError
        ? Colors.red
        : green;
    final IconData icon = result.isError
        ? Icons.error_outline_rounded
        : Icons.check_circle_rounded;
    final String title = result.isError
        ? 'Connection Failed'
        : 'Connection established';
    final String body = result.isError
        ? result.errorMessage!
        : '';

    return Builder(builder: (context) {
      final isDark = Theme.of(context).brightness == Brightness.dark;
      final Color bg = result.isError
          ? (isDark ? const Color(0xFF3E1111) : const Color(0xFFFFEBEE))
          : (isDark ? const Color(0xFF1A3B22) : const Color(0xFFE8F5E9));
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: accent.withValues(alpha: 0.5)),
        ),
        child: Row(
          children: [
            Icon(icon, color: accent, size: 22),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: accent, fontSize: 13)),
                  const SizedBox(height: 3),
                  Text(body,
                      style: TextStyle(fontSize: 12, color: isDark ? Colors.white : dark)),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _endpointRow(String label, String value) {
    return Builder(builder: (context) {
      final isDark = Theme.of(context).brightness == Brightness.dark;
      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 110,
              child: Text(
                label,
                style: TextStyle(fontSize: 12, color: isDark ? const Color(0xFFAAAAAA) : grey, fontWeight: FontWeight.w500),
              ),
            ),
            Expanded(
              child: Text(
                value,
                style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.white : dark,
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      );
    });
  }
}