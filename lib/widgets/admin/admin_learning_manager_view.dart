import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../utils/app_colors.dart';

class AdminLearningManagerView extends StatelessWidget {
  const AdminLearningManagerView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final modules = [
      {'title': 'Introduction to Cybersecurity', 'chapters': 4, 'enrolled': 340, 'status': 'Published'},
      {'title': 'Advanced Phishing Tactics', 'chapters': 6, 'enrolled': 150, 'status': 'Published'},
      {'title': 'Device Security Basics', 'chapters': 3, 'enrolled': 0, 'status': 'Draft'},
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            runSpacing: 16,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(PhosphorIcons.bookOpen(), color: green, size: 28),
                  const SizedBox(width: 12),
                  Text('Learning Modules', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: isDark ? Colors.white : dark)),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Module creation interface opened. (Integration pending)'))
                  );
                },
                icon: Icon(PhosphorIcons.plus(), size: 18),
                label: const Text('Add Module'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text('Manage educational content, chapters, and track user enrollment.', style: TextStyle(fontSize: 14, color: isDark ? Colors.grey.shade400 : Colors.grey.shade600)),
          const SizedBox(height: 32),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: modules.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final module = modules[index];
              final isPublished = module['status'] == 'Published';

              return Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10)],
                  border: Border.all(color: isDark ? const Color(0xFF333333) : const Color(0xFFEEEEEE)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isPublished ? Colors.purple.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(PhosphorIcons.bookBookmark(), color: isPublished ? Colors.purple : Colors.grey, size: 28),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(module['title'] as String, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: isDark ? Colors.white : dark)),
                          const SizedBox(height: 4),
                          Wrap(
                            spacing: 16,
                            runSpacing: 4,
                            children: [
                              Text('${module['chapters']} Chapters', style: TextStyle(fontSize: 13, color: isDark ? Colors.grey.shade400 : Colors.grey.shade600)),
                              Text('${module['enrolled']} Enrolled', style: TextStyle(fontSize: 13, color: isDark ? Colors.grey.shade400 : Colors.grey.shade600)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: isPublished ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(module['status'] as String, style: TextStyle(fontWeight: FontWeight.bold, color: isPublished ? Colors.green : Colors.orange, fontSize: 12)),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        IconButton(
                          icon: Icon(PhosphorIcons.pencilSimple(), color: isDark ? Colors.grey.shade400 : Colors.grey.shade700),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: Icon(PhosphorIcons.trash(), color: Colors.red.shade400),
                          onPressed: () {},
                        ),
                      ],
                    )
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
