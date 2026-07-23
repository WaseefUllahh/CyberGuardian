import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../services/report_service.dart';
import '../../../models/report_model.dart';
import '../../reports/widgets/report_widgets.dart';

class AdminScamReportsView extends StatelessWidget {
  const AdminScamReportsView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Scam Reports Management', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: isDark ? Colors.white : dark)),
          const SizedBox(height: 20),
          Expanded(
            child: StreamBuilder<List<ReportModel>>(
              stream: ReportService().getAllReports(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                final reports = snapshot.data ?? [];
                if (reports.isEmpty) {
                  return _buildEmptyState(isDark);
                }
                
                return ListView.builder(
                  itemCount: reports.length,
                  itemBuilder: (context, index) {
                    final r = reports[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: ReportItem(
                        title: r.category,
                        status: r.status,
                        time: 'Recent',
                        description: r.details,
                        severity: r.status == 'Pending' ? 'High' : 'Low',
                        categories: [r.source],
                      ),
                    );
                  },
                );
              }
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.report_off, size: 80, color: isDark ? Colors.grey.shade800 : Colors.grey.shade300),
          const SizedBox(height: 16),
          Text('No reports', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: isDark ? Colors.grey.shade400 : Colors.grey.shade600)),
          const SizedBox(height: 8),
          Text('All scam reports have been resolved.', style: TextStyle(color: isDark ? Colors.grey.shade600 : Colors.grey.shade500)),
        ],
      ),
    );
  }
}




