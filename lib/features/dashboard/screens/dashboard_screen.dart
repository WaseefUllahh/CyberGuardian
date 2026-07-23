import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../services/auth_service.dart';
import '../../../services/report_service.dart';
import '../../../services/url_scan_service.dart';
import '../../../services/profile_service.dart';
import '../../../models/user_model.dart';
import '../../../models/report_model.dart';
import '../../../models/scan_model.dart';
import '../widgets/hero_status_card.dart';
import '../widgets/action_tile.dart';
import '../widgets/dashboard_drawer.dart';
import '../../scanner/screens/scan_history_screen.dart';
import '../../news/screens/news_screen.dart';

/// Main home/dashboard screen shown after login.
///
/// Displays:
/// - Greeting header with avatar & notification bell
/// - [HeroStatusCard] with security score
/// - User stats (total scans, reports)
/// - Quick actions grid ([ActionTile])
/// - Recent activity list (last 3 scans)
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Greeting Header
                    _buildGreetingHeader(ctx, user),
                    const SizedBox(height: 20),

                    // Security Status Card
                    HeroStatusCard(
                      score: user?.securityScore ?? 100,
                      statusText:
                          (user?.securityScore ?? 100) >= 80 ? 'Protected' : 'At Risk',
                      description: 'Your account activity appears safe.',
                      progress: (user?.securityScore ?? 100) / 100.0,
                      onTap: () => Navigator.pushNamed(context, '/scanner'),
                    ),
                    const SizedBox(height: 20),

                    // User Stats
                    _buildSectionTitle('Your Statistics', '', textTheme,
                        isLink: false),
                    const SizedBox(height: 14),
                    _buildUserStats(context, user, reportService),
                    const SizedBox(height: 28),

                    // Quick Actions
                    _buildSectionTitle('Quick Actions', 'See all', textTheme,
                        onTap: () =>
                            Navigator.pushNamed(context, '/scanner')),
                    const SizedBox(height: 14),
                    _buildQuickActions(context),
                    const SizedBox(height: 28),

                    // Recent Activity Timeline
                    _buildSectionTitle(
                      'Recent Activity',
                      'View History',
                      textTheme,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const ScanHistoryScreen()),
                        );
                      },
                    ),
                    const SizedBox(height: 14),
                    _buildRecentActivity(context, isDark),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // Greeting Header
  Widget _buildGreetingHeader(BuildContext context, UserModel? user) {
    final name = user?.name ?? 'User';
    final initials =
        name.isNotEmpty ? name.substring(0, 1).toUpperCase() : 'U';
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppColors.dark;
    final subtitleColor = isDark ? const Color(0xFFAAAAAA) : AppColors.grey;
    final iconColor = isDark ? Colors.white70 : AppColors.dark;

    return Row(
      children: [
        IconButton(
          icon: Icon(PhosphorIcons.list(), color: iconColor, size: 26),
          onPressed: () => Scaffold.of(context).openDrawer(),
          tooltip: 'Open',
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name,
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: textColor)),
              const SizedBox(height: 2),
              Text('Stay safe online today',
                  style: TextStyle(fontSize: 13, color: subtitleColor)),
            ],
          ),
        ),
        Stack(
          children: [
            IconButton(
              icon: Icon(PhosphorIcons.bellRinging(),
                  color: iconColor, size: 26),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const NewsScreen()),
                );
              },
            ),
            Positioned(
              right: 10,
              top: 10,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                    color: Colors.red, shape: BoxShape.circle),
              ),
            ),
          ],
        ),
        const SizedBox(width: 4),
        // Avatar (tappable → upload photo)
        GestureDetector(
          onTap: () async {
            if (user == null) return;
            final picker = ImagePicker();
            final pickedFile =
                await picker.pickImage(source: ImageSource.gallery);
            if (!context.mounted) return;
            if (pickedFile != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Uploading photo...')));
              final url = await ProfileService()
                  .uploadAvatar(user.uid, pickedFile);
              if (!context.mounted) return;
              if (url != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Upload successful!')));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Upload failed. Please try again.')));
              }
            }
          },
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
                color: AppColors.brandGreen, shape: BoxShape.circle),
            clipBehavior: Clip.hardEdge,
            child: (user?.photoUrl != null && user!.photoUrl!.isNotEmpty)
                ? Image.network(
                    user.photoUrl!,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(
                          child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white)));
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                          child: Text(initials,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14)));
                    },
                  )
                : Center(
                    child: Text(initials,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14))),
          ),
        ),
      ],
    );
  }

  // Section Title Row
  Widget _buildSectionTitle(
    String title,
    String action,
    TextTheme textTheme, {
    bool isLink = true,
    VoidCallback? onTap,
  }) {
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
                  Icon(PhosphorIcons.caretRight(),
                      color: AppColors.brandGreen, size: 20),
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

  // Quick Actions Grid
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
          onTap: () =>
              Navigator.pushNamed(context, '/scanner', arguments: 'Password'),
        ),
      ],
    );
  }

  // User Stats Row
  Widget _buildUserStats(
      BuildContext context, UserModel? user, ReportService reportService) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;

    return Row(
      children: [
        Expanded(
          child: _statBox(
            cardColor,
            isDark,
            PhosphorIcons.scan(),
            'Total Scans',
            (user?.totalScans ?? 0).toString(),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: StreamBuilder<List<ReportModel>>(
            stream: reportService.getUserReports(),
            builder: (context, snapshot) {
              final reportCount = snapshot.data?.length ?? 0;
              return _statBox(
                cardColor,
                isDark,
                PhosphorIcons.flag(),
                'Reports',
                reportCount.toString(),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _statBox(
      Color bgColor, bool isDark, IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.brandGreen.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.brandGreen, size: 24),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : AppColors.dark)),
              Text(label,
                  style: TextStyle(
                      fontSize: 12,
                      color: isDark
                          ? const Color(0xFFAAAAAA)
                          : AppColors.grey)),
            ],
          ),
        ],
      ),
    );
  }

  String _formatRelativeTime(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    if (diff.inMinutes > 0) return '${diff.inMinutes}m ago';
    return 'Just now';
  }

  // Recent Activity
  Widget _buildRecentActivity(BuildContext context, bool isDark) {
    return StreamBuilder<List<ScanModel>>(
      stream: UrlScanService().getUserScans(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: Padding(
                  padding: EdgeInsets.all(24),
                  child: CircularProgressIndicator()));
        }

        final scans = (snapshot.data ?? []).take(3).toList();

        if (scans.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                'No recent scans. Run your first scan!',
                style: TextStyle(
                    color: isDark
                        ? const Color(0xFFAAAAAA)
                        : AppColors.grey),
              ),
            ),
          );
        }

        return Column(
          children: scans.map((scan) {
            final String type;
            final IconData icon;
            if (scan.provider.contains('SMS')) {
              type = 'SMS';
              icon = PhosphorIcons.chatCircleText();
            } else if (scan.provider.contains('Email')) {
              type = 'Email';
              icon = PhosphorIcons.envelope();
            } else if (scan.provider.contains('Password')) {
              type = 'Password';
              icon = PhosphorIcons.vault();
            } else {
              type = 'URL';
              icon = PhosphorIcons.globe();
            }

            final isSafe = scan.result.toLowerCase() == 'safe' ||
                scan.result.toLowerCase() == 'clean';
            final color = isSafe ? AppColors.brandGreen : Colors.orange;

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: isDark
                        ? const Color(0xFF333333)
                        : Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  Icon(icon, color: color),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('$type Scan',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isDark
                                    ? Colors.white
                                    : AppColors.dark)),
                        Text(scan.url,
                            style: TextStyle(
                                fontSize: 12,
                                color: isDark
                                    ? const Color(0xFFAAAAAA)
                                    : AppColors.grey),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(scan.result,
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: color)),
                      Text(
                        _formatRelativeTime(scan.createdAt.toDate()),
                        style: TextStyle(
                            fontSize: 11,
                            color: isDark
                                ? const Color(0xFFAAAAAA)
                                : AppColors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }
}


