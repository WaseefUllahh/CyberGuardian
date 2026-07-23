import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../core/theme/app_colors.dart';

class AdminNotificationsView extends StatelessWidget {
  const AdminNotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final notifications = [
      {'title': 'New Scam Report', 'body': 'User reported a new phishing email.', 'time': '5m ago', 'type': 'alert', 'read': false},
      {'title': 'System Update', 'body': 'Platform updated to version 1.0.4', 'time': '2h ago', 'type': 'info', 'read': true},
      {'title': 'High Threat Level', 'body': 'Multiple users scanned malicious links from the same domain.', 'time': '4h ago', 'type': 'warning', 'read': false},
      {'title': 'API Latency Spike', 'body': 'VirusTotal API latency exceeded 500ms.', 'time': '1d ago', 'type': 'warning', 'read': true},
    ];

    Color getTypeColor(String type) {
      switch (type) {
        case 'alert': return Colors.red;
        case 'warning': return Colors.orange;
        case 'info': return Colors.blue;
        default: return Colors.grey;
      }
    }

    IconData getTypeIcon(String type) {
      switch (type) {
        case 'alert': return PhosphorIcons.shieldWarning();
        case 'warning': return PhosphorIcons.warning();
        case 'info': return PhosphorIcons.info();
        default: return PhosphorIcons.bell();
      }
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(PhosphorIcons.bell(), color: green, size: 28),
              const SizedBox(width: 12),
              Text('System Notifications', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: isDark ? Colors.white : dark)),
            ],
          ),
          const SizedBox(height: 8),
          Text('View and manage alerts, system updates, and administrative warnings.', style: TextStyle(fontSize: 14, color: isDark ? Colors.grey.shade400 : Colors.grey.shade600)),
          const SizedBox(height: 32),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: notifications.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final notif = notifications[index];
              final color = getTypeColor(notif['type'] as String);
              final isRead = notif['read'] as bool;

              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? (isRead ? const Color(0xFF1E1E1E) : const Color(0xFF2A2A2A)) : (isRead ? Colors.white : const Color(0xFFF0FDF4)),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10)],
                  border: Border.all(color: isDark ? const Color(0xFF333333) : const Color(0xFFEEEEEE)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(getTypeIcon(notif['type'] as String), color: color, size: 20),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  notif['title'] as String,
                                  style: TextStyle(fontWeight: isRead ? FontWeight.w600 : FontWeight.bold, fontSize: 16, color: isDark ? Colors.white : dark),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(notif['time'] as String, style: TextStyle(fontSize: 12, color: isDark ? Colors.grey.shade500 : Colors.grey.shade600)),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(notif['body'] as String, style: TextStyle(fontSize: 14, color: isDark ? Colors.grey.shade400 : Colors.grey.shade700)),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}



