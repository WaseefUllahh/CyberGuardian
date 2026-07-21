import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../utils/app_colors.dart';
import '../widgets/report_widgets.dart';
import '../widgets/dashboard_widgets.dart';
import '../models/user_model.dart';
import '../models/scan_model.dart';
import '../models/report_model.dart';
import '../services/auth_service.dart';
import '../services/url_scan_service.dart';
import '../services/report_service.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _openSubmitReport() async {
    final result = await Navigator.pushNamed(context, '/submit-report');
    if (result != null && result is Map<String, dynamic>) {
      final category = result['title']?.toString() ?? 'General Threat';
      final source = (result['categories'] as List<dynamic>?)?.join(', ') ?? 'Unknown';
      final details = result['description']?.toString() ?? '';
      
      await ReportService().submitReport(category, source, details);

      _tabController.animateTo(2);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('✅ Report submitted! We\'ll review it shortly.'),
            backgroundColor: green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  String _formatTime(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inDays > 0) return '${diff.inDays} days ago';
    if (diff.inHours > 0) return '${diff.inHours} hours ago';
    if (diff.inMinutes > 0) return '${diff.inMinutes} mins ago';
    return 'Just now';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF121212) : const Color(0xFFF5F5F5);
    final appBarColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : dark;
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text('Reports',
            style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
        backgroundColor: appBarColor,
        elevation: 0,
        surfaceTintColor: appBarColor,
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: Icon(Icons.arrow_back_ios_new_rounded, color: textColor),
                onPressed: () => Navigator.pop(context),
              )
            : null,
        actions: [
          TextButton.icon(
            onPressed: _openSubmitReport,
            icon: Icon(PhosphorIcons.plusCircle(), color: green, size: 20),
            label: Text('Submit',
                style: TextStyle(
                    color: green, fontWeight: FontWeight.bold, fontSize: 14)),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: green,
          unselectedLabelColor: grey,
          indicatorColor: green,
          indicatorWeight: 3,
          labelStyle:
              const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          unselectedLabelStyle:
              const TextStyle(fontWeight: FontWeight.normal, fontSize: 13),
          tabs: const [
            Tab(text: 'Threats'),
            Tab(text: 'Scan History'),
            Tab(text: 'Submitted'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildThreatsTab(),
          _buildScanHistoryTab(),
          _buildSubmittedTab(),
        ],
      ),
    );
  }

  Widget _buildThreatsTab() {
    return Builder(builder: (context) {
      final isDark = Theme.of(context).brightness == Brightness.dark;
      return SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Security Statistics',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : AppColors.dark)),
            const SizedBox(height: 14),
            StreamBuilder<UserModel?>(
              stream: AuthService().getCurrentUserDataStream(),
              builder: (context, snapshot) {
                final totalScans = snapshot.data?.totalScans ?? 0;
                final safeScans = snapshot.data?.safeScans ?? 0;
                final unsafeScans = snapshot.data?.unsafeScans ?? 0;
                return StreamBuilder<List<ReportModel>>(
                  stream: ReportService().getUserReports(),
                  builder: (context, reportSnapshot) {
                    final reportsCount = reportSnapshot.data?.length ?? 0;
                    return Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: StatCard(
                                icon: PhosphorIcons.magnifyingGlass(),
                                value: '$totalScans',
                                label: 'Total Scans',
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: StatCard(
                                icon: PhosphorIcons.shieldCheck(),
                                value: '$safeScans',
                                label: 'Safe Results',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(
                              child: StatCard(
                                icon: PhosphorIcons.warning(),
                                value: '$unsafeScans',
                                label: 'Suspicious',
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: StatCard(
                                icon: PhosphorIcons.paperPlaneTilt(),
                                value: '$reportsCount',
                                label: 'Reports Sent',
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  }
                );
              }
            ),
            const SizedBox(height: 24),
            Text('Active Threat Digest',
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : dark)),
            const SizedBox(height: 14),
            ThreatItem(
              icon: PhosphorIcons.trendUp(),
              iconColor: Colors.red,
              bgColor: isDark ? const Color(0xFF3E1111) : const Color(0xFFFFEBEE),
              title: 'SMS Phishing Surge',
              subtitle: 'Fake bank OTP messages up 34% this week.',
              severity: 'High',
              severityColor: Colors.red,
            ),
            const SizedBox(height: 10),
            ThreatItem(
              icon: PhosphorIcons.chartBar(),
              iconColor: const Color(0xFFE65100),
              bgColor: isDark ? const Color(0xFF3B1E05) : const Color(0xFFFBE9E7),
              title: 'New Password Leak',
              subtitle: '2.3M credentials exposed in data breach.',
              severity: 'Medium',
              severityColor: const Color(0xFFE65100),
            ),
            const SizedBox(height: 10),
            ThreatItem(
              icon: PhosphorIcons.bug(),
              iconColor: isDark ? const Color(0xFFCE93D8) : const Color(0xFF7B1FA2),
              bgColor: isDark ? const Color(0xFF281131) : const Color(0xFFF3E5F5),
              title: 'Malware Variant Detected',
              subtitle: 'New trojan targeting mobile banking apps.',
              severity: 'High',
              severityColor: Colors.red,
            ),
          ],
        ),
      );
    });
  }

  Widget _buildScanHistoryTab() {
    return Builder(builder: (context) {
      final isDark = Theme.of(context).brightness == Brightness.dark;
      return SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Recent Scans',
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : dark)),
            const SizedBox(height: 14),
            StreamBuilder<List<ScanModel>>(
              stream: UrlScanService().getUserScans(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final scans = snapshot.data ?? [];
                if (scans.isEmpty) {
                  return Text('No scan history found.', style: TextStyle(color: grey));
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: scans.length,
                  itemBuilder: (context, index) {
                    final scan = scans[index];
                    final bool isSafe = scan.result.toLowerCase() == 'safe';
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: ScanHistoryItem(
                        url: scan.url,
                        type: '${scan.provider} Scan',
                        time: _formatTime(scan.createdAt.toDate()),
                        status: scan.result,
                        statusColor: isSafe ? green : Colors.red,
                      ),
                    );
                  }
                );
              }
            ),
          ],
        ),
      );
    });
  }

  Widget _buildSubmittedTab() {
    return Builder(builder: (context) {
      final isDark = Theme.of(context).brightness == Brightness.dark;
      return StreamBuilder<List<ReportModel>>(
        stream: ReportService().getUserReports(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final reports = snapshot.data ?? [];
          
          if (reports.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF5F5F5),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(PhosphorIcons.flag(), size: 56, color: grey),
                  ),
                  const SizedBox(height: 20),
                  Text('No reports submitted yet',
                      style: TextStyle(
                          fontSize: 17, fontWeight: FontWeight.bold, color: isDark ? Colors.white : dark)),
                  const SizedBox(height: 8),
                  Text('Tap "Submit" above to report a cyber threat',
                      style: TextStyle(fontSize: 13, color: isDark ? const Color(0xFFAAAAAA) : grey)),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${reports.length} Report${reports.length == 1 ? "" : "s"} Submitted',
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : dark),
                ),
                const SizedBox(height: 14),
                ...reports.map((report) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: ReportItem(
                        title: report.category,
                        description: report.details,
                        time: _formatTime(report.createdAt.toDate()),
                        status: report.status,
                        severity: 'Medium', // We can derive this based on category if needed
                        categories: [report.source],
                      ),
                    )),
              ],
            ),
          );
        }
      );
    });
  }
}