import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
// import '../../../services/export_service.dart'; // To be created next

class AdminReportExportView extends StatefulWidget {
  const AdminReportExportView({super.key});

  @override
  State<AdminReportExportView> createState() => _AdminReportExportViewState();
}

class _AdminReportExportViewState extends State<AdminReportExportView> {
  String _selectedFormat = 'PDF';
  final List<String> _formats = ['PDF', 'CSV', 'Excel'];
  
  bool _isExporting = false;

  /*
  void _exportReport(String type) async {
    setState(() => _isExporting = true);
    
    // Simulate export delay
    await Future.delayed(const Duration(seconds: 2));
    
    if (!mounted) return;
    setState(() => _isExporting = false);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$type exported successfully as $_selectedFormat!'),
        backgroundColor: green,
      ),
    );
  }
  */

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Report Export', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: isDark ? Colors.white : dark)),
          const SizedBox(height: 8),
          Text('Generate and download platform data.', style: TextStyle(fontSize: 14, color: isDark ? Colors.grey.shade400 : Colors.grey.shade600)),
          const SizedBox(height: 24),
          
          // Format Selector
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Select Export Format', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isDark ? Colors.white : dark)),
                const SizedBox(height: 16),
                Row(
                  children: _formats.map((format) {
                    final isSelected = _selectedFormat == format;
                    return Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: ChoiceChip(
                        label: Text(format),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) setState(() => _selectedFormat = format);
                        },
                        selectedColor: green.withValues(alpha: 0.2),
                        labelStyle: TextStyle(
                          color: isSelected ? green : (isDark ? Colors.white : dark),
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          Text('Available Reports', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : dark)),
          const SizedBox(height: 16),
          
          if (_isExporting)
            const Center(child: Padding(
              padding: EdgeInsets.all(40.0),
              child: CircularProgressIndicator(),
            ))
          else
            Column(
              children: [
                _buildExportCard(context, 'Users Directory', 'Export all registered users and their details.', Icons.people, 'Users'),
                const SizedBox(height: 12),
                _buildExportCard(context, 'Scan History', 'Export a complete log of all system scans.', Icons.history, 'Scan History'),
                const SizedBox(height: 12),
                _buildExportCard(context, 'Scam Reports', 'Export all submitted scam and phishing reports.', Icons.report, 'Scam Reports'),
                const SizedBox(height: 12),
                _buildExportCard(context, 'Learning Statistics', 'Export user progress and completion rates.', Icons.book, 'Learning Statistics'),
                const SizedBox(height: 12),
                _buildExportCard(context, 'Quiz Results', 'Export quiz scores and averages.', Icons.quiz, 'Quiz Results'),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildExportCard(BuildContext context, String title, String subtitle, IconData icon, String type) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF2A2A2A) : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: isDark ? Colors.white70 : Colors.grey.shade700),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: isDark ? Colors.white : dark)),
                const SizedBox(height: 4),
                Text(subtitle, style: TextStyle(color: isDark ? Colors.grey.shade400 : Colors.grey.shade600, fontSize: 13)),
              ],
            ),
          ),
          ElevatedButton.icon(
            onPressed: null,
            icon: const Icon(Icons.hourglass_empty, size: 18),
            label: const Text('Soon'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey.shade400,
              foregroundColor: Colors.white,
              elevation: 0,
              disabledBackgroundColor: Colors.grey.shade300,
              disabledForegroundColor: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}




