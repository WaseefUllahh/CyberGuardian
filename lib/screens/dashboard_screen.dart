import 'package:flutter/material.dart';
import '../utils/auth_utils.dart';
import '../widgets/dashboard_widgets.dart';
import '../widgets/dashboard_drawer.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      drawer: const DashboardDrawer(),
      body: Builder(
        builder: (ctx) => SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Greeting Header ──
                _buildGreetingHeader(ctx),
                const SizedBox(height: 20),

                // ── Security Status Card ──
                _buildSecurityStatusCard(),
                const SizedBox(height: 28),

                // ── Quick Actions ──
                _buildSectionTitle('Quick Actions', 'See all'),
                const SizedBox(height: 14),
                _buildQuickActions(),
                const SizedBox(height: 28),

                // ── Recent Activity ──
                _buildSectionTitle('Recent Activity', 'View all'),
                const SizedBox(height: 14),
                _buildRecentActivity(),
                const SizedBox(height: 28),

                // ── Cyber Awareness ──
                const Text('Cyber Awareness',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: dark)),
                const SizedBox(height: 14),
                _buildCyberAwareness(),
                const SizedBox(height: 28),

                // ── Security Statistics ──
                const Text('Security Statistics',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: dark)),
                const SizedBox(height: 14),
                _buildSecurityStatistics(),
                const SizedBox(height: 28),

                // ── Daily Security Tip ──
                _buildDailyTip(),
                const SizedBox(height: 28),

                // ── Your Progress ──
                _buildSectionTitle('Your Progress', 'Details'),
                const SizedBox(height: 14),
                _buildProgressCard(),
                const SizedBox(height: 28),

                // ── Threat Digest ──
                _buildSectionTitle('Threat Digest', 'Updated today', isLink: false),
                const SizedBox(height: 14),
                _buildThreatDigest(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─── Greeting Header ──────────────────────────────────────────────────────
  Widget _buildGreetingHeader(BuildContext context) {
    return Row(
      children: [
        // Hamburger icon — opens the Drawer
        IconButton(
          icon: const Icon(Icons.menu_rounded, color: dark, size: 26),
          onPressed: () => Scaffold.of(context).openDrawer(),
          tooltip: 'Open menu',
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Good Morning,',
                  style: TextStyle(fontSize: 14, color: grey)),
              const SizedBox(height: 2),
              const Text('Waseef Ullah 👋',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: dark)),
              const SizedBox(height: 2),
              const Text('Stay safe online today',
                  style: TextStyle(fontSize: 13, color: grey)),
            ],
          ),
        ),
        Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.notifications_outlined, color: dark, size: 26),
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
        const CircleAvatar(
          radius: 20,
          backgroundColor: dark,
          child: Text('WA',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
        ),
      ],
    );
  }

  // ─── Security Status Card ─────────────────────────────────────────────────
  Widget _buildSecurityStatusCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2E7D32), Color(0xFF43A047)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.shield_outlined, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 10),
              const Text('Security Status',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              const Spacer(),
              Icon(Icons.shield, color: Colors.white.withOpacity(0.2), size: 60),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text('85',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 40)),
              const Padding(
                padding: EdgeInsets.only(bottom: 6),
                child: Text(' %',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text('Protected',
                    style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text('Your account activity appears safe.',
              style: TextStyle(color: Colors.white70, fontSize: 13)),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: 0.85,
              backgroundColor: Colors.white.withOpacity(0.2),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 6),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('0', style: TextStyle(color: Colors.white70, fontSize: 12)),
              Text('100', style: TextStyle(color: Colors.white70, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  // ─── Section Title ────────────────────────────────────────────────────────
  Widget _buildSectionTitle(String title, String action, {bool isLink = true}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: dark)),
        Row(
          children: [
            Text(action,
                style: TextStyle(
                    fontSize: 14,
                    color: isLink ? green : grey,
                    fontWeight: FontWeight.w600)),
            if (isLink)
              Icon(Icons.chevron_right, color: green, size: 20),
          ],
        ),
      ],
    );
  }

  // ─── Quick Actions (GridView) ─────────────────────────────────────────────
  Widget _buildQuickActions() {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 14,
      mainAxisSpacing: 14,
      childAspectRatio: 1.05,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: const [
        QuickActionCard(
          icon: Icons.link,
          iconColor: green,
          bgColor: Color(0xFFE8F5E9),
          title: 'Scan URL',
          subtitle: 'Check link safety',
        ),
        QuickActionCard(
          icon: Icons.chat_bubble_outline,
          iconColor: Color(0xFF1565C0),
          bgColor: Color(0xFFE3F2FD),
          title: 'Analyze SMS',
          subtitle: 'Detect phishing text',
        ),
        QuickActionCard(
          icon: Icons.flag_outlined,
          iconColor: Color(0xFFE65100),
          bgColor: Color(0xFFFBE9E7),
          title: 'Report Scam',
          subtitle: 'Submit suspicious content',
        ),
        QuickActionCard(
          icon: Icons.vpn_key_outlined,
          iconColor: Color(0xFF7B1FA2),
          bgColor: Color(0xFFF3E5F5),
          title: 'Password Check',
          subtitle: 'Test password strength',
        ),
      ],
    );
  }

  // ─── Recent Activity ──────────────────────────────────────────────────────
  Widget _buildRecentActivity() {
    final items = [
      ActivityItemData(
        icon: Icons.link,
        iconColor: green,
        bgColor: const Color(0xFFE8F5E9),
        title: 'example-site.com',
        subtitle: 'URL Scan · 10 mins ago',
        status: 'Safe',
        statusColor: green,
      ),
      ActivityItemData(
        icon: Icons.warning_amber_rounded,
        iconColor: Colors.red,
        bgColor: const Color(0xFFFFEBEE),
        title: 'login-alert-message',
        subtitle: 'SMS Analysis · 1 hour ago',
        status: 'Suspicious',
        statusColor: Colors.red,
      ),
      ActivityItemData(
        icon: Icons.link,
        iconColor: green,
        bgColor: const Color(0xFFE8F5E9),
        title: 'unknown-link.net',
        subtitle: 'URL Scan · Yesterday',
        status: 'Safe',
        statusColor: green,
      ),
    ];

    return Column(
      children: items.map((item) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: item.bgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(item.icon, color: item.iconColor, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.title,
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: dark)),
                    const SizedBox(height: 3),
                    Text(item.subtitle,
                        style: const TextStyle(color: grey, fontSize: 12)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: item.statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: item.statusColor.withOpacity(0.4)),
                ),
                child: Text(item.status,
                    style: TextStyle(
                        color: item.statusColor, fontSize: 12, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ),
      )).toList(),
    );
  }

  // ─── Cyber Awareness ──────────────────────────────────────────────────────
  Widget _buildCyberAwareness() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: AwarenessCard(
                icon: Icons.no_encryption_outlined,
                iconColor: green,
                bgColor: const Color(0xFFE8F5E9),
                title: 'Phishing Awareness',
                subtitle: 'Learn how to identify phishing emails and fake websites.',
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: AwarenessCard(
                icon: Icons.lock_outline,
                iconColor: green,
                bgColor: const Color(0xFFE8F5E9),
                title: 'Password Security',
                subtitle: 'Create strong passwords and protect your accounts.',
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: AwarenessCard(
                icon: Icons.public,
                iconColor: green,
                bgColor: const Color(0xFFE8F5E9),
                title: 'Online Safety',
                subtitle: 'Browse safely and avoid risky online behavior.',
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: AwarenessCard(
                icon: Icons.account_balance_wallet_outlined,
                iconColor: green,
                bgColor: const Color(0xFFE8F5E9),
                title: 'Fraud Prevention',
                subtitle: 'Recognize scams and protect your financial information.',
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ─── Security Statistics ──────────────────────────────────────────────────
  Widget _buildSecurityStatistics() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: StatCard(
                icon: Icons.search,
                iconColor: const Color(0xFF1565C0),
                bgColor: const Color(0xFFE3F2FD),
                value: '42',
                label: 'Total Scans',
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: StatCard(
                icon: Icons.check_circle_outline,
                iconColor: green,
                bgColor: const Color(0xFFE8F5E9),
                value: '38',
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
                icon: Icons.warning_amber_rounded,
                iconColor: const Color(0xFFE65100),
                bgColor: const Color(0xFFFBE9E7),
                value: '4',
                label: 'Suspicious',
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: StatCard(
                icon: Icons.send,
                iconColor: Colors.red,
                bgColor: const Color(0xFFFFEBEE),
                value: '3',
                label: 'Reports Sent',
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ─── Daily Security Tip ───────────────────────────────────────────────────
  Widget _buildDailyTip() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3E0),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.lightbulb_outline, color: Color(0xFFE65100), size: 20),
              ),
              const SizedBox(width: 10),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Daily Security Tip',
                      style: TextStyle(fontSize: 12, color: grey)),
                  Text('Tip of the Day',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: dark)),
                ],
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3E0),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text('#47',
                    style: TextStyle(color: Color(0xFFE65100), fontWeight: FontWeight.bold, fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            '"Avoid clicking links from unknown senders and always verify website URLs before entering personal information."',
            style: TextStyle(fontSize: 14, color: dark, height: 1.5),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              // Dot indicators
              _dot(true),
              const SizedBox(width: 4),
              _dot(false),
              const SizedBox(width: 4),
              _dot(false),
              const SizedBox(width: 4),
              _dot(false),
              const Spacer(),
              Text('Learn More',
                  style: TextStyle(color: green, fontWeight: FontWeight.bold, fontSize: 14)),
              Icon(Icons.chevron_right, color: green, size: 20),
            ],
          ),
        ],
      ),
    );
  }

  Widget _dot(bool active) {
    return Container(
      width: active ? 20 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: active ? green : const Color(0xFFE0E0E0),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  // ─── Progress Card ────────────────────────────────────────────────────────
  Widget _buildProgressCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          ProgressBar(label: 'Phishing Awareness', value: 0.80, percent: '80%',
              color: const Color(0xFFE65100)),
          const SizedBox(height: 18),
          ProgressBar(label: 'Password Security', value: 0.65, percent: '65%',
              color: const Color(0xFF7B1FA2)),
          const SizedBox(height: 18),
          ProgressBar(label: 'Safe Browsing', value: 0.90, percent: '90%',
              color: green),
          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.menu_book_outlined, color: green, size: 20),
              const SizedBox(width: 8),
              const Expanded(
                child: Text('3 of 8 modules completed this week',
                    style: TextStyle(color: dark, fontSize: 13)),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  elevation: 0,
                ),
                child: const Text('Continue', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── Threat Digest ────────────────────────────────────────────────────────
  Widget _buildThreatDigest() {
    return Column(
      children: [
        ThreatCard(
          icon: Icons.trending_up,
          iconColor: Colors.red,
          bgColor: const Color(0xFFFFEBEE),
          title: 'SMS Phishing Surge',
          subtitle: 'Fake bank OTP messages up 34% this week.',
          severity: 'High',
          severityColor: Colors.red,
        ),
        const SizedBox(height: 10),
        ThreatCard(
          icon: Icons.bar_chart,
          iconColor: const Color(0xFFE65100),
          bgColor: const Color(0xFFFBE9E7),
          title: 'New Password Leak',
          subtitle: '2.3M credentials exposed in data breach.',
          severity: 'Medium',
          severityColor: const Color(0xFFE65100),
        ),
      ],
    );
  }

}
