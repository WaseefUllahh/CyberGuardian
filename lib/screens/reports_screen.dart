import 'package:flutter/material.dart';
import '../utils/auth_utils.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ──
              const Text('Reports',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: dark)),
              const SizedBox(height: 4),
              const Text('Your security activity overview',
                  style: TextStyle(fontSize: 14, color: grey)),
              const SizedBox(height: 24),

              // ── Stats Summary ──
              Row(
                children: [
                  Expanded(
                    child: _MiniStat(
                      value: '42',
                      label: 'Total Scans',
                      icon: Icons.search,
                      color: const Color(0xFF1565C0),
                      bgColor: const Color(0xFFE3F2FD),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _MiniStat(
                      value: '38',
                      label: 'Safe',
                      icon: Icons.check_circle_outline,
                      color: green,
                      bgColor: const Color(0xFFE8F5E9),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _MiniStat(
                      value: '4',
                      label: 'Threats',
                      icon: Icons.warning_amber_rounded,
                      color: Colors.red,
                      bgColor: const Color(0xFFFFEBEE),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // ── Threat Digest ──
              const Text('Threat Digest',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: dark)),
              const SizedBox(height: 14),
              _ThreatItem(
                icon: Icons.trending_up,
                iconColor: Colors.red,
                bgColor: const Color(0xFFFFEBEE),
                title: 'SMS Phishing Surge',
                subtitle: 'Fake bank OTP messages up 34% this week.',
                severity: 'High',
                severityColor: Colors.red,
              ),
              const SizedBox(height: 10),
              _ThreatItem(
                icon: Icons.bar_chart,
                iconColor: const Color(0xFFE65100),
                bgColor: const Color(0xFFFBE9E7),
                title: 'New Password Leak',
                subtitle: '2.3M credentials exposed in data breach.',
                severity: 'Medium',
                severityColor: const Color(0xFFE65100),
              ),
              const SizedBox(height: 10),
              _ThreatItem(
                icon: Icons.bug_report_outlined,
                iconColor: const Color(0xFF7B1FA2),
                bgColor: const Color(0xFFF3E5F5),
                title: 'Malware Variant Detected',
                subtitle: 'New trojan targeting mobile banking apps.',
                severity: 'High',
                severityColor: Colors.red,
              ),
              const SizedBox(height: 28),

              // ── Scan History ──
              const Text('Scan History',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: dark)),
              const SizedBox(height: 14),
              _ScanHistoryItem(
                url: 'example-site.com',
                type: 'URL Scan',
                time: '10 mins ago',
                status: 'Safe',
                statusColor: green,
              ),
              const SizedBox(height: 10),
              _ScanHistoryItem(
                url: 'login-alert-message',
                type: 'SMS Analysis',
                time: '1 hour ago',
                status: 'Suspicious',
                statusColor: Colors.red,
              ),
              const SizedBox(height: 10),
              _ScanHistoryItem(
                url: 'unknown-link.net',
                type: 'URL Scan',
                time: 'Yesterday',
                status: 'Safe',
                statusColor: green,
              ),
              const SizedBox(height: 10),
              _ScanHistoryItem(
                url: 'free-prize.xyz',
                type: 'URL Scan',
                time: '2 days ago',
                status: 'Phishing',
                statusColor: Colors.red,
              ),
              const SizedBox(height: 10),
              _ScanHistoryItem(
                url: 'bank-notification',
                type: 'SMS Analysis',
                time: '3 days ago',
                status: 'Safe',
                statusColor: green,
              ),
              const SizedBox(height: 28),

              // ── Reports Submitted ──
              const Text('Reports Submitted',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: dark)),
              const SizedBox(height: 14),
              _ReportItem(
                title: 'Phishing Email Reported',
                description: 'Fake Apple ID verification email submitted for review.',
                time: '2 days ago',
                status: 'Under Review',
              ),
              const SizedBox(height: 10),
              _ReportItem(
                title: 'Scam SMS Reported',
                description: 'Fraudulent bank OTP message flagged and sent.',
                time: '5 days ago',
                status: 'Resolved',
              ),
              const SizedBox(height: 10),
              _ReportItem(
                title: 'Suspicious Link Reported',
                description: 'Malware-hosting URL reported to security team.',
                time: '1 week ago',
                status: 'Resolved',
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Helper Widgets ─────────────────────────────────────────────────────────

class _MiniStat extends StatelessWidget {
  final String value, label;
  final IconData icon;
  final Color color, bgColor;

  const _MiniStat({
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 10),
          Text(value,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: dark)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(fontSize: 12, color: grey)),
        ],
      ),
    );
  }
}

class _ThreatItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor, bgColor, severityColor;
  final String title, subtitle, severity;

  const _ThreatItem({
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    required this.title,
    required this.subtitle,
    required this.severity,
    required this.severityColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: dark)),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(color: grey, fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: severityColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(severity,
                style: TextStyle(color: severityColor, fontSize: 12, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

class _ScanHistoryItem extends StatelessWidget {
  final String url, type, time, status;
  final Color statusColor;

  const _ScanHistoryItem({
    required this.url,
    required this.type,
    required this.time,
    required this.status,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              statusColor == green ? Icons.link : Icons.warning_amber_rounded,
              color: statusColor,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(url,
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: dark)),
                const SizedBox(height: 3),
                Text('$type · $time', style: const TextStyle(color: grey, fontSize: 12)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: statusColor.withOpacity(0.4)),
            ),
            child: Text(status,
                style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}

class _ReportItem extends StatelessWidget {
  final String title, description, time, status;

  const _ReportItem({
    required this.title,
    required this.description,
    required this.time,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final bool isResolved = status == 'Resolved';
    final Color statusColor = isResolved ? green : const Color(0xFFE65100);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: dark)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(status,
                    style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(description, style: const TextStyle(color: grey, fontSize: 13)),
          const SizedBox(height: 6),
          Text(time, style: const TextStyle(color: grey, fontSize: 11)),
        ],
      ),
    );
  }
}
