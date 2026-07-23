import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/app_colors.dart';
import '../../../services/admin_service.dart';

class AdminAnalyticsView extends StatelessWidget {
  const AdminAnalyticsView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final labelColor = isDark ? Colors.white70 : Colors.grey;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Platform Analytics', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: isDark ? Colors.white : dark)),
          const SizedBox(height: 8),
          Text('Visualize user activity and scan distribution.', style: TextStyle(fontSize: 14, color: isDark ? Colors.grey.shade400 : Colors.grey.shade600)),
          const SizedBox(height: 24),
          
          Text('7-Day Activity Trends', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : dark)),
          const SizedBox(height: 16),
          
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
            ),
            child: AspectRatio(
              aspectRatio: 1.5,
              child: StreamBuilder<Map<int, int>>(
                stream: AdminService().getDailyActivityStats(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final stats = snapshot.data ?? {};
                  final List<BarChartGroupData> barGroups = [];
                  for (int i = 1; i <= 7; i++) {
                    barGroups.add(
                      BarChartGroupData(
                        x: i,
                        barRods: [
                          BarChartRodData(
                            toY: (stats[i] ?? 0).toDouble(),
                            color: green,
                            width: 16,
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                          )
                        ],
                      ),
                    );
                  }

                  return BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      // maxY is removed to allow auto-scaling based on data
                      barTouchData: BarTouchData(enabled: true),
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 28,
                            getTitlesWidget: (double value, TitleMeta meta) {
                              final style = TextStyle(color: labelColor, fontWeight: FontWeight.bold, fontSize: 12);
                              String text;
                              switch (value.toInt()) {
                                case 1: text = 'Mon'; break;
                                case 2: text = 'Tue'; break;
                                case 3: text = 'Wed'; break;
                                case 4: text = 'Thu'; break;
                                case 5: text = 'Fri'; break;
                                case 6: text = 'Sat'; break;
                                case 7: text = 'Sun'; break;
                                default: text = ''; break;
                              }
                              return SideTitleWidget(
                                axisSide: meta.axisSide,
                                space: 8,
                                child: Text(text, style: style),
                              );
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      gridData: FlGridData(show: false),
                      borderData: FlBorderData(show: false),
                      barGroups: barGroups,
                    ),
                  );
                }
              ),
            ),
          ),

          const SizedBox(height: 24),
          Text('Scan Types Distribution', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : dark)),
          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
            ),
            child: StreamBuilder<Map<String, int>>(
              stream: AdminService().getScanTypeDistribution(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(
                    height: 200,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                final data = snapshot.data ?? {};
                final total = data.values.fold(0, (a, b) => a + b);

                if (total == 0) {
                  return SizedBox(
                    height: 160,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.pie_chart_outline, size: 56, color: Colors.grey.shade400),
                          const SizedBox(height: 12),
                          Text('No scan data yet', style: TextStyle(color: Colors.grey.shade500, fontSize: 14)),
                        ],
                      ),
                    ),
                  );
                }

                final colors = [Colors.blue, Colors.green, Colors.orange, Colors.purple];
                final keys = ['URL', 'SMS', 'Email', 'Password'];

                final sections = <PieChartSectionData>[];
                for (int i = 0; i < keys.length; i++) {
                  final count = data[keys[i]] ?? 0;
                  if (count == 0) continue;
                  final pct = (count / total * 100).toStringAsFixed(0);
                  sections.add(PieChartSectionData(
                    color: colors[i],
                    value: count.toDouble(),
                    title: '$pct%',
                    radius: 50,
                    titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                  ));
                }

                return Column(
                  children: [
                    AspectRatio(
                      aspectRatio: 1.6,
                      child: PieChart(
                        PieChartData(
                          sectionsSpace: 3,
                          centerSpaceRadius: 55,
                          sections: sections,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 20,
                      runSpacing: 8,
                      alignment: WrapAlignment.center,
                      children: [
                        for (int i = 0; i < keys.length; i++)
                          if ((data[keys[i]] ?? 0) > 0)
                            _legendItem(colors[i], '${keys[i]} (${data[keys[i]]})', isDark),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),

        ],
      ),
    );
  }

  Widget _legendItem(Color color, String label, bool isDark) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: isDark ? Colors.white : Colors.black87)),
      ],
    );
  }
}



