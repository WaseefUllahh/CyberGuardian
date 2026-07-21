import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../utils/app_colors.dart';

class AdminApiMonitorView extends StatelessWidget {
  const AdminApiMonitorView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final endpoints = [
      {'name': 'VirusTotal API', 'status': 'Operational', 'latency': '120ms', 'uptime': '99.9%'},
      {'name': 'Google Safe Browsing', 'status': 'Operational', 'latency': '45ms', 'uptime': '100%'},
      {'name': 'Firebase Auth', 'status': 'Operational', 'latency': '80ms', 'uptime': '99.9%'},
      {'name': 'Cloud Firestore', 'status': 'Operational', 'latency': '60ms', 'uptime': '99.9%'},
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(PhosphorIcons.plugsConnected(), color: green, size: 28),
              const SizedBox(width: 12),
              Text('API Monitor', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: isDark ? Colors.white : dark)),
            ],
          ),
          const SizedBox(height: 8),
          Text('Monitor the status and latency of third-party integrations and internal services.', style: TextStyle(fontSize: 14, color: isDark ? Colors.grey.shade400 : Colors.grey.shade600)),
          const SizedBox(height: 32),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: endpoints.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final endpoint = endpoints[index];
              final isOperational = endpoint['status'] == 'Operational';
              final statusColor = isOperational ? Colors.green : Colors.orange;

              return Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10)],
                  border: Border.all(color: isDark ? const Color(0xFF333333) : const Color(0xFFEEEEEE)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isOperational ? PhosphorIcons.checkCircle() : PhosphorIcons.warning(),
                        color: statusColor,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(endpoint['name']!, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: isDark ? Colors.white : dark)),
                          const SizedBox(height: 4),
                          Wrap(
                            spacing: 16,
                            runSpacing: 4,
                            children: [
                              Text('Latency: ${endpoint['latency']}', style: TextStyle(fontSize: 13, color: isDark ? Colors.grey.shade400 : Colors.grey.shade600)),
                              Text('Uptime: ${endpoint['uptime']}', style: TextStyle(fontSize: 13, color: isDark ? Colors.grey.shade400 : Colors.grey.shade600)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: statusColor.withOpacity(0.3)),
                            ),
                            child: Text(endpoint['status']!, style: TextStyle(fontWeight: FontWeight.bold, color: statusColor, fontSize: 12)),
                          ),
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
