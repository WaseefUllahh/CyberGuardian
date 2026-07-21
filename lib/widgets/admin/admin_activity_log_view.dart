import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../services/admin_service.dart';
import '../../models/activity_model.dart';

class AdminActivityLogView extends StatelessWidget {
  const AdminActivityLogView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Platform Activity Log', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: isDark ? Colors.white : dark)),
          const SizedBox(height: 8),
          Text('Real-time stream of all user and system actions.', style: TextStyle(fontSize: 14, color: isDark ? Colors.grey.shade400 : Colors.grey.shade600)),
          const SizedBox(height: 20),
          Expanded(
            child: StreamBuilder<List<ActivityModel>>(
              stream: AdminService().getAllActivities(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                final activities = snapshot.data ?? [];
                if (activities.isEmpty) {
                  return _buildEmptyState(isDark);
                }
                
                return Container(
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
                  ),
                  child: ListView.separated(
                    itemCount: activities.length,
                    separatorBuilder: (context, index) => Divider(color: isDark ? const Color(0xFF333333) : Colors.grey.shade200, height: 1),
                    itemBuilder: (context, index) {
                      final log = activities[index];
                      final date = log.createdAt.toDate();
                      final timeString = "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
                      final dateString = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
                      
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        leading: CircleAvatar(
                          backgroundColor: _getActionColor(log.action).withValues(alpha: 0.1),
                          child: Icon(
                            _getActionIcon(log.action),
                            color: _getActionColor(log.action),
                          ),
                        ),
                      title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(log.action,
                                style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : dark),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text('$dateString $timeString', style: TextStyle(fontSize: 12, color: isDark ? Colors.grey.shade400 : Colors.grey.shade600)),
                          ],
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text('User: ${log.userId}', 
                            style: TextStyle(color: isDark ? Colors.grey.shade400 : Colors.grey.shade700, fontSize: 13),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
            ),
          ),
        ],
      ),
    );
  }

  IconData _getActionIcon(String action) {
    if (action.contains('Scan')) return Icons.search;
    if (action.contains('Login')) return Icons.login;
    if (action.contains('Report')) return Icons.report;
    if (action.contains('Password')) return Icons.lock;
    return Icons.local_activity;
  }

  Color _getActionColor(String action) {
    if (action.contains('Scan')) return Colors.blue;
    if (action.contains('Login')) return Colors.green;
    if (action.contains('Report')) return Colors.red;
    if (action.contains('Password')) return Colors.orange;
    return Colors.purple;
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history_toggle_off, size: 80, color: isDark ? Colors.grey.shade800 : Colors.grey.shade300),
          const SizedBox(height: 16),
          Text('No activity recorded', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: isDark ? Colors.grey.shade400 : Colors.grey.shade600)),
          const SizedBox(height: 8),
          Text('System actions will appear here in real-time.', style: TextStyle(color: isDark ? Colors.grey.shade600 : Colors.grey.shade500)),
        ],
      ),
    );
  }
}
