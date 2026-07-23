import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../core/theme/app_colors.dart';
import '../../../services/admin_service.dart';
import '../../../models/scan_model.dart';

class AdminScanHistoryView extends StatefulWidget {
  const AdminScanHistoryView({super.key});

  @override
  State<AdminScanHistoryView> createState() => _AdminScanHistoryViewState();
}

class _AdminScanHistoryViewState extends State<AdminScanHistoryView> {
  String _searchQuery = '';
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Safe', 'Suspicious', 'Dangerous'];

  Color _getRiskColor(String result) {
    switch (result.toLowerCase()) {
      case 'safe':
      case 'clean':
        return Colors.green;
      case 'low risk':
        return Colors.yellow.shade700;
      case 'suspicious':
        return Colors.orange;
      case 'dangerous':
      case 'malicious':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getTypeIcon(ScanModel scan) {
    if (scan.provider.contains('SMS')) return PhosphorIcons.chatCircleText();
    if (scan.provider.contains('Email')) return PhosphorIcons.envelopeSimple();
    if (scan.provider.contains('Password')) return PhosphorIcons.vault();
    if (scan.url.contains('@')) return PhosphorIcons.envelopeSimple();
    return PhosphorIcons.globeHemisphereWest();
  }

  String _getScanTypeLabel(ScanModel scan) {
    if (scan.provider.contains('SMS')) return 'SMS Scan';
    if (scan.provider.contains('Email')) return 'Email Scan';
    if (scan.provider.contains('Password')) return 'Password Check';
    if (scan.url.contains('@')) return 'Email Scan';
    return 'URL Scan';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : dark;
    final subtitleColor = isDark ? const Color(0xFFAAAAAA) : grey;

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(PhosphorIcons.clockCounterClockwise(), color: green, size: 28),
              const SizedBox(width: 12),
              Text(
                'Scan History',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Search
          TextField(
            onChanged: (val) => setState(() => _searchQuery = val.toLowerCase()),
            style: TextStyle(color: textColor),
            decoration: InputDecoration(
              hintText: 'Search by URL or user ID...',
              hintStyle: TextStyle(color: subtitleColor),
              prefixIcon: Icon(PhosphorIcons.magnifyingGlass(), color: subtitleColor),
              filled: true,
              fillColor: cardColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: isDark ? const Color(0xFF333333) : Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: isDark ? const Color(0xFF333333) : Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: green, width: 1.5),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
            ),
          ),
          const SizedBox(height: 12),

          // Filter Chips
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
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide.none,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),

          // Scan List
          Expanded(
            child: StreamBuilder<List<ScanModel>>(
              stream: AdminService().getAllScans(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error loading scans: ${snapshot.error}',
                      style: TextStyle(color: Colors.red.shade400),
                    ),
                  );
                }

                final allScans = snapshot.data ?? [];

                final filtered = allScans.where((scan) {
                  final matchesSearch = _searchQuery.isEmpty ||
                      scan.url.toLowerCase().contains(_searchQuery) ||
                      scan.userId.toLowerCase().contains(_searchQuery);

                  final matchesFilter = _selectedFilter == 'All' ||
                      scan.result.toLowerCase().contains(_selectedFilter.toLowerCase());

                  return matchesSearch && matchesFilter;
                }).toList();

                if (filtered.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          PhosphorIcons.clockCounterClockwise(),
                          size: 64,
                          color: isDark ? const Color(0xFF333333) : Colors.grey.shade300,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No scans found',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: subtitleColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Try adjusting your search or filters.',
                          style: TextStyle(color: subtitleColor, fontSize: 13),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  itemCount: filtered.length,
                  separatorBuilder: (context, index) => Divider(
                    color: isDark ? const Color(0xFF2A2A2A) : Colors.grey.shade100,
                    height: 1,
                  ),
                  itemBuilder: (context, index) {
                    final scan = filtered[index];
                    final riskColor = _getRiskColor(scan.result);
                    final typeIcon = _getTypeIcon(scan);
                    final typeLabel = _getScanTypeLabel(scan);

                    return Container(
                      color: cardColor,
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        leading: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: riskColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(typeIcon, color: riskColor, size: 22),
                        ),
                        title: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                scan.url,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: textColor,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: riskColor.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: riskColor.withValues(alpha: 0.4),
                                ),
                              ),
                              child: Text(
                                scan.result,
                                style: TextStyle(
                                  color: riskColor,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    PhosphorIcons.tag(),
                                    size: 12,
                                    color: subtitleColor,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    typeLabel,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: subtitleColor,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Icon(
                                    PhosphorIcons.calendarBlank(),
                                    size: 12,
                                    color: subtitleColor,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${scan.scanDate}  ${scan.scanTime}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: subtitleColor,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'UID: ${scan.userId}',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: isDark
                                      ? const Color(0xFF666666)
                                      : Colors.grey.shade500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}



