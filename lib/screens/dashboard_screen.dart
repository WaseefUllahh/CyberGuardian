import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../utils/app_colors.dart';
import '../services/auth_service.dart';
import '../services/report_service.dart';
import '../models/user_model.dart';
import '../models/report_model.dart';
import '../widgets/dashboard_widgets.dart';
import '../widgets/dashboard_drawer.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF121212) : const Color(0xFFF5F5F5);
    final authService = AuthService();
    final reportService = ReportService();

    return Scaffold(
      backgroundColor: bgColor,
      drawer: const DashboardDrawer(),
      body: StreamBuilder<UserModel?>(
        stream: authService.getCurrentUserDataStream(),
        builder: (context, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final user = userSnapshot.data;
          
          return Builder(
            builder: (ctx) => SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Greeting Header ──
                    _buildGreetingHeader(ctx, user),
                    const SizedBox(height: 20),

                    // ── Security Status Card ──
                    HeroStatusCard(
                      score: user?.securityScore ?? 100,
                      statusText: (user?.securityScore ?? 100) >= 80 ? 'Protected' : 'At Risk',
                      description: 'Your account activity appears safe.',
                      progress: (user?.securityScore ?? 100) / 100.0,
                      onTap: () => Navigator.pushNamed(context, '/scanner'),
                    ),
                    const SizedBox(height: 28),

                    // ── Quick Actions ──
                    _buildSectionTitle('Quick Actions', 'See all', textTheme, onTap: () => Navigator.pushNamed(context, '/scanner')),
                    const SizedBox(height: 14),
                    _buildQuickActions(context),
                    const SizedBox(height: 28),

                    // ── Urgent Threat ──
                    _buildSectionTitle('Recent Reports', 'View all', textTheme, onTap: () => Navigator.pushNamed(context, '/reports')),
                    const SizedBox(height: 14),
                    
                    StreamBuilder<List<ReportModel>>(
                      stream: reportService.getUserReports(),
                      builder: (context, reportSnapshot) {
                        if (reportSnapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        
                        final reports = reportSnapshot.data ?? [];
                        if (reports.isEmpty) {
                          return Text('No recent reports.', style: TextStyle(color: AppColors.grey));
                        }
                        
                        final latestReport = reports.first;
                        return StatusListRow(
                          icon: PhosphorIcons.warning(),
                          statusColor: latestReport.status == 'Pending' ? AppColors.statusWarningRed : AppColors.brandGreen,
                          title: latestReport.category,
                          subtitle: latestReport.details,
                          statusText: latestReport.status,
                          onTap: () => Navigator.pushNamed(context, '/reports'),
                        );
                      }
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          );
        }
      ),
    );
  }

  // ─── Greeting Header ──────────────────────────────────────────────────────
  Widget _buildGreetingHeader(BuildContext context, UserModel? user) {
    final name = user?.name ?? 'User';
    final initials = name.isNotEmpty ? name.substring(0, 1).toUpperCase() : 'U';
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppColors.dark;
    final subtitleColor = isDark ? const Color(0xFFAAAAAA) : AppColors.grey;
    final iconColor = isDark ? Colors.white70 : AppColors.dark;

    return Row(
      children: [
        // Hamburger icon — opens the Drawer
        IconButton(
          icon: Icon(PhosphorIcons.list(), color: iconColor, size: 26),
          onPressed: () => Scaffold.of(context).openDrawer(),
          tooltip: 'Open',
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Good Morning,',
                  style: TextStyle(fontSize: 14, color: subtitleColor)),
              const SizedBox(height: 2),
              Text('$name 👋',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textColor)),
              const SizedBox(height: 2),
              Text('Stay safe online today',
                  style: TextStyle(fontSize: 13, color: subtitleColor)),
            ],
          ),
        ),
        Stack(
          children: [
            IconButton(
              icon: Icon(PhosphorIcons.bellRinging(), color: iconColor, size: 26),
              onPressed: () {},
            ),
            Positioned(
              right: 10,
              top: 10,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 4),
        CircleAvatar(
          radius: 20,
          backgroundColor: AppColors.brandGreen,
          child: Text(initials,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
        ),
      ],
    );
  }

  // ─── Section Title ────────────────────────────────────────────────────────
  Widget _buildSectionTitle(String title, String action, TextTheme textTheme, {bool isLink = true, VoidCallback? onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: textTheme.sectionHeader),
        if (isLink)
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(4),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              child: Row(
                children: [
                  Text(action,
                      style: TextStyle(
                          fontSize: 14,
                          color: AppColors.brandGreen,
                          fontWeight: FontWeight.w600)),
                  Icon(PhosphorIcons.caretRight(), color: AppColors.brandGreen, size: 20),
                ],
              ),
            ),
          )
        else
          Text(action,
              style: TextStyle(
                  fontSize: 14,
                  color: AppColors.grey,
                  fontWeight: FontWeight.w600)),
      ],
    );
  }

  // ─── Quick Actions (GridView) ─────────────────────────────────────────────
  Widget _buildQuickActions(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 14,
      mainAxisSpacing: 14,
      childAspectRatio: 1.05,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        ActionTile(
          icon: PhosphorIcons.globeHemisphereWest(),
          title: 'Scan URL',
          subtitle: 'Check link safety',
          onTap: () => Navigator.pushNamed(context, '/scanner'),
        ),
        ActionTile(
          icon: PhosphorIcons.chatCircleText(),
          title: 'Analyze SMS',
          subtitle: 'Detect phishing text',
          onTap: () => Navigator.pushNamed(context, '/scanner'),
        ),
        ActionTile(
          icon: PhosphorIcons.warningCircle(),
          title: 'Report Scam',
          subtitle: 'Submit suspicious content',
          onTap: () => Navigator.pushNamed(context, '/submit-report'),
        ),
        ActionTile(
          icon: PhosphorIcons.vault(),
          title: 'Password Check',
          subtitle: 'Test password strength',
          onTap: () => Navigator.pushNamed(context, '/scanner', arguments: 'Password'),
        ),
      ],
    );
  }
}