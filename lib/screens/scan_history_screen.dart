import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../utils/app_colors.dart';
import '../models/scan_model.dart';
import '../services/url_scan_service.dart';

class ScanHistoryScreen extends StatefulWidget {
  const ScanHistoryScreen({super.key});

  @override
  State<ScanHistoryScreen> createState() => _ScanHistoryScreenState();
}

class _ScanHistoryScreenState extends State<ScanHistoryScreen> {
  String _searchQuery = '';
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'URL', 'SMS', 'Email', 'Password'];

  Color _getRiskColor(String risk) {
    switch (risk.toLowerCase()) {
      case 'safe':
      case 'clean': return Colors.green;
      case 'low risk': return Colors.yellow.shade700;
      case 'suspicious': return Colors.orange;
      case 'dangerous': 
      case 'malicious': return Colors.red;
      default: return Colors.grey;
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'URL': return PhosphorIcons.globe();
      case 'SMS': return PhosphorIcons.chatCircleText();
      case 'Email': return PhosphorIcons.envelope();
      case 'Password': return PhosphorIcons.vault();
      default: return PhosphorIcons.scan();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF121212) : const Color(0xFFF5F5F5);
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text('Scan History', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color(0xFF1B5E20),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            tooltip: 'Clear All History',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Clear history feature coming soon!')));
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and Filter Header
          Container(
            color: cardColor,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  onChanged: (val) => setState(() => _searchQuery = val),
                  style: TextStyle(color: isDark ? Colors.white : dark),
                  decoration: InputDecoration(
                    hintText: 'Search history...',
                    hintStyle: TextStyle(color: isDark ? const Color(0xFF666666) : grey),
                    prefixIcon: Icon(PhosphorIcons.magnifyingGlass(), color: grey),
                    filled: true,
                    fillColor: isDark ? const Color(0xFF2A2A2A) : Colors.grey.shade100,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  ),
                ),
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _filters.map((filter) {
                      final isSelected = _selectedFilter == filter;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          label: Text(filter),
                          selected: isSelected,
                          onSelected: (selected) {
                            if (selected) setState(() => _selectedFilter = filter);
                          },
                          selectedColor: green.withValues(alpha: 0.2),
                          backgroundColor: isDark ? const Color(0xFF2A2A2A) : Colors.grey.shade200,
                          labelStyle: TextStyle(
                            color: isSelected ? green : (isDark ? Colors.white : dark),
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide.none),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          
          // History List
          Expanded(
            child: StreamBuilder<List<ScanModel>>(
              stream: UrlScanService().getUserScans(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error loading history: ${snapshot.error}', style: TextStyle(color: isDark ? Colors.white : dark))
                  );
                }

                final scans = snapshot.data ?? [];
                
                final filteredHistory = scans.where((item) {
                  final matchesSearch = item.url.toLowerCase().contains(_searchQuery.toLowerCase())
                      || item.result.toLowerCase().contains(_searchQuery.toLowerCase())
                      || item.provider.toLowerCase().contains(_searchQuery.toLowerCase());

                  String type = 'URL';
                  if (item.provider.contains('SMS')) type = 'SMS';
                  if (item.provider.contains('Email')) type = 'Email';
                  if (item.provider.contains('Password')) type = 'Password';

                  final matchesFilter = _selectedFilter == 'All' || type == _selectedFilter;
                  return matchesSearch && matchesFilter;
                }).toList();

                if (filteredHistory.isEmpty) return _buildEmptyState(isDark);

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredHistory.length,
                  itemBuilder: (context, index) {
                    final item = filteredHistory[index];
                    
                    String type = 'URL';
                    if (item.provider.contains('SMS')) type = 'SMS';
                    if (item.provider.contains('Email')) type = 'Email';
                    if (item.provider.contains('Password')) type = 'Password';

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8, offset: const Offset(0, 2))],
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        leading: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: _getRiskColor(item.result).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(_getTypeIcon(type), color: _getRiskColor(item.result)),
                        ),
                        title: Text(item.url, style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : dark), maxLines: 1, overflow: TextOverflow.ellipsis),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Row(
                            children: [
                              Text('${item.scanDate} at ${item.scanTime}', style: TextStyle(fontSize: 12, color: isDark ? const Color(0xFFAAAAAA) : grey)),
                              const Spacer(),
                              Text(item.result, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: _getRiskColor(item.result))),
                            ],
                          ),
                        ),
                        onTap: () {
                          // Navigate to Threat Details Page
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Opening detailed threat report...')));
                        },
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
          Icon(PhosphorIcons.clock(), size: 80, color: isDark ? const Color(0xFF333333) : Colors.grey.shade300),
          const SizedBox(height: 16),
          Text('No scans found', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: isDark ? const Color(0xFFAAAAAA) : Colors.grey.shade600)),
          const SizedBox(height: 8),
          Text('Try adjusting your filters or run a new scan.', style: TextStyle(color: isDark ? const Color(0xFF666666) : grey)),
        ],
      ),
    );
  }
}
