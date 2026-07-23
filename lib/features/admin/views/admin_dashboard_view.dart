import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../core/theme/app_colors.dart';
import '../../../services/admin_service.dart';

class AdminDashboardView extends StatelessWidget {
  const AdminDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final adminService = AdminService();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(PhosphorIcons.squaresFour(), color: green, size: 28),
              const SizedBox(width: 12),
              Text('System Overview', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: isDark ? Colors.white : dark)),
            ],
          ),
          const SizedBox(height: 24),
          // Row 1: High Level Metrics
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: StreamBuilder<int>(
                  stream: adminService.getTotalUsersCount(),
                  builder: (context, snapshot) {
                    return _statCard(context, 'Total Users', snapshot.data?.toString() ?? '0', PhosphorIcons.users(), Colors.blue);
                  }
                )),
                const SizedBox(width: 16),
                Expanded(child: StreamBuilder<int>(
                  stream: adminService.getOpenReportsCount(),
                  builder: (context, snapshot) {
                    return _statCard(context, 'Open Reports', snapshot.data?.toString() ?? '0', PhosphorIcons.flagBanner(), Colors.orange);
                  }
                )),
                const SizedBox(width: 16),
                Expanded(child: _statCard(context, 'System Health', '100%', PhosphorIcons.heartbeat(), green)),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Icon(PhosphorIcons.chartBar(), color: green, size: 28),
              const SizedBox(width: 12),
              Text('Aggregated Scan Statistics', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: isDark ? Colors.white : dark)),
            ],
          ),
          const SizedBox(height: 24),
          // Row 2: Aggregated Metrics
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: StreamBuilder<int>(
                  stream: adminService.getTotalSystemScans(),
                  builder: (context, snapshot) {
                    return _statCard(context, 'Total Scans', snapshot.data?.toString() ?? '0', PhosphorIcons.scan(), Colors.indigo);
                  }
                )),
                const SizedBox(width: 16),
                Expanded(child: StreamBuilder<int>(
                  stream: adminService.getTotalSafeScans(),
                  builder: (context, snapshot) {
                    return _statCard(context, 'Safe Scans', snapshot.data?.toString() ?? '0', PhosphorIcons.shieldCheck(), Colors.green);
                  }
                )),
                const SizedBox(width: 16),
                Expanded(child: StreamBuilder<int>(
                  stream: adminService.getTotalUnsafeScans(),
                  builder: (context, snapshot) {
                    return _statCard(context, 'Unsafe Scans', snapshot.data?.toString() ?? '0', PhosphorIcons.shieldWarning(), Colors.red);
                  }
                )),
              ],
            ),
          ),
          const SizedBox(height: 32),
          // Info Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1B5E20).withValues(alpha: 0.2) : const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: green.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Icon(PhosphorIcons.info(), color: green, size: 24),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'The statistics displayed above aggregate data across all registered users on the platform in real-time.',
                    style: TextStyle(color: isDark ? Colors.white : dark, fontSize: 14),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _statCard(BuildContext context, String title, String value, IconData icon, Color color) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 15, offset: const Offset(0, 5))],
        border: Border.all(color: isDark ? const Color(0xFF333333) : const Color(0xFFEEEEEE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 16),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(value, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: isDark ? Colors.white : dark)),
          ),
          const SizedBox(height: 4),
          Text(title, style: TextStyle(color: isDark ? const Color(0xFFAAAAAA) : grey, fontSize: 14, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}





