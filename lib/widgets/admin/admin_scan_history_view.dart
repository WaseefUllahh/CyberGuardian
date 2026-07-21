import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../services/admin_service.dart';
import '../../models/activity_model.dart';

class AdminScanHistoryView extends StatelessWidget {
  const AdminScanHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;

    Color _getActionColor(String action) {
      if (action.contains('URL Scan')) return Colors.blue;
      if (action.contains('Message Scan')) return Colors.orange;
      if (action.contains('Password Check')) return Colors.teal;
      if (action.contains('Report Submitted')) return Colors.red;
      return Colors.green;
    }

    IconData _getActionIcon(String action) {
      if (action.contains('URL Scan')) return Icons.link;
      if (action.contains('Message Scan')) return Icons.sms;
      if (action.contains('Password Check')) return Icons.lock;
      if (action.contains('Report Submitted')) return Icons.report_problem;
      if (action.contains('Login')) return Icons.login;
      return Icons.history;
    }

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('System Activity History', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: isDark ? Colors.white : dark)),
          const SizedBox(height: 20),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
              ),
              child: StreamBuilder<List<ActivityModel>>(
                stream: AdminService().getAllActivities(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final activities = snapshot.data ?? [];

                  if (activities.isEmpty) {
                    return Center(
                      child: Text('No activity found.', style: TextStyle(color: isDark ? Colors.grey.shade400 : Colors.grey.shade600)),
                    );
                  }

                  return ListView.separated(
                    itemCount: activities.length,
                    separatorBuilder: (context, index) => Divider(color: isDark ? const Color(0xFF333333) : Colors.grey.shade200, height: 1),
                    itemBuilder: (context, index) {
                      final activity = activities[index];
                      final date = activity.createdAt.toDate();
                      final formattedDate = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
                      
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        leading: CircleAvatar(
                          backgroundColor: _getActionColor(activity.action).withOpacity(0.2),
                          child: Icon(
                            _getActionIcon(activity.action),
                            color: _getActionColor(activity.action),
                          ),
                        ),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(activity.action, style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : dark)),
                            Text(formattedDate, style: TextStyle(fontSize: 12, color: isDark ? Colors.grey.shade400 : Colors.grey.shade600)),
                          ],
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text('User ID: ${activity.userId}', 
                            style: TextStyle(color: isDark ? Colors.grey.shade300 : Colors.grey.shade700, fontSize: 13),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      );
                    },
                  );
                }
              ),
            ),
          ),
        ],
      ),
    );
  }
}
