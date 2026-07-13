import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../utils/app_colors.dart';
import '../models/learning_models.dart';
import '../models/learning_progress.dart';
import '../services/learning_service.dart';
import '../data/learning_content.dart';
import '../widgets/learning_ui_widgets.dart';
import 'course_detail_screen.dart';

class LearningScreen extends StatefulWidget {
  const LearningScreen({super.key});

  @override
  State<LearningScreen> createState() => _LearningScreenState();
}

class _LearningScreenState extends State<LearningScreen> {
  final LearningService _learningService = LearningService();
  String _searchQuery = '';
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Beginner', 'Intermediate', 'Advanced'];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF121212) : const Color(0xFFF5F5F5);
    final textColor = isDark ? Colors.white : AppColors.dark;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: StreamBuilder<LearningProgress?>(
          stream: _learningService.getProgressStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final progress = snapshot.data ?? LearningProgress(uid: '');

            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Learning Dashboard',
                            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: textColor)),
                        const SizedBox(height: 24),
                        
                        _buildProgressSummary(progress, isDark),
                        const SizedBox(height: 24),

                        _buildSearchBar(isDark),
                        const SizedBox(height: 16),
                        
                        _buildFilters(isDark),
                        const SizedBox(height: 24),
                        
                        Text('Explore Courses',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textColor)),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: _buildCoursesGrid(progress),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 40)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildProgressSummary(LearningProgress progress, bool isDark) {
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: isDark ? [] : [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatCol(PhosphorIcons.star(PhosphorIconsStyle.fill), '${progress.totalXp}', 'Total XP', Colors.amber),
              _buildStatCol(PhosphorIcons.fire(PhosphorIconsStyle.fill), '${progress.currentStreak}', 'Day Streak', Colors.orange),
              _buildStatCol(PhosphorIcons.certificate(PhosphorIconsStyle.fill), '${progress.completedCourseIds.length}', 'Certificates', AppColors.brandGreen),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCol(IconData icon, String value, String label, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _buildSearchBar(bool isDark) {
    return TextField(
      onChanged: (val) => setState(() => _searchQuery = val),
      decoration: InputDecoration(
        hintText: 'Search courses or topics...',
        prefixIcon: Icon(PhosphorIcons.magnifyingGlass(), color: Colors.grey),
        filled: true,
        fillColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildFilters(bool isDark) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _filters.map((filter) {
          final isSelected = _selectedFilter == filter;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(filter),
              selected: isSelected,
              onSelected: (_) => setState(() => _selectedFilter = filter),
              backgroundColor: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFEEEEEE),
              selectedColor: AppColors.brandGreen.withValues(alpha: 0.2),
              labelStyle: TextStyle(
                color: isSelected ? AppColors.brandGreen : (isDark ? Colors.white : AppColors.dark),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              side: BorderSide(
                color: isSelected ? AppColors.brandGreen : Colors.transparent,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCoursesGrid(LearningProgress progress) {
    List<Course> filteredCourses = LearningContent.allCourses.where((c) {
      final matchesSearch = c.title.toLowerCase().contains(_searchQuery.toLowerCase()) || 
                            c.subtitle.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesFilter = _selectedFilter == 'All' || c.difficulty == _selectedFilter;
      return matchesSearch && matchesFilter;
    }).toList();

    if (filteredCourses.isEmpty) {
      return SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Text('No courses found.', style: TextStyle(color: Colors.grey)),
          ),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final course = filteredCourses[index];
          
          // Calculate progress percentage
          int completedLessons = course.lessons.where((l) => progress.isLessonCompleted(l.id)).length;
          double percent = course.lessons.isNotEmpty ? (completedLessons / course.lessons.length) : 0.0;
          
          return _buildCourseCard(course, percent, progress);
        },
        childCount: filteredCourses.length,
      ),
    );
  }

  Widget _buildCourseCard(Course course, double progressPercent, LearningProgress progress) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : AppColors.dark;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CourseDetailScreen(course: course, progress: progress),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: isDark ? [] : [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Hero(
                  tag: 'course_icon_${course.id}',
                  child: HeroCourseIcon(icon: course.icon, size: 36),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              course.title,
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
                            ),
                          ),
                          BadgeWidget(
                            text: course.difficulty,
                            color: course.difficulty == 'Beginner' ? Colors.blue : (course.difficulty == 'Intermediate' ? Colors.orange : Colors.red),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        course.subtitle,
                        style: const TextStyle(fontSize: 13, color: Colors.grey, height: 1.4),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(PhosphorIcons.bookOpen(), size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text('${course.totalLessons} Lessons', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(width: 16),
                Icon(PhosphorIcons.clock(), size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text('${course.durationMinutes} min', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                const Spacer(),
                if (progress.isCourseCompleted(course.id))
                  const BadgeWidget(text: 'Completed', color: Colors.amber),
              ],
            ),
            if (progressPercent > 0 && !progress.isCourseCompleted(course.id)) ...[
              const SizedBox(height: 16),
              AnimatedCourseProgress(progress: progressPercent, color: AppColors.brandGreen),
            ]
          ],
        ),
      ),
    );
  }
}