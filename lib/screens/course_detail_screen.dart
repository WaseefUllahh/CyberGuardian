import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../utils/app_colors.dart';
import '../models/learning_models.dart';
import '../models/learning_progress.dart';
import '../widgets/learning_ui_widgets.dart';
import '../services/learning_service.dart';
import '../services/certificate_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'lesson_screen.dart';
import 'quiz_screen.dart';

class CourseDetailScreen extends StatelessWidget {
  final Course course;
  final LearningProgress progress;

  const CourseDetailScreen({super.key, required this.course, required this.progress});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF121212) : const Color(0xFFF5F5F5);
    final textColor = isDark ? Colors.white : AppColors.dark;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;

    int completedLessons = course.lessons.where((l) => progress.isLessonCompleted(l.id)).length;
    double percent = course.lessons.isNotEmpty ? (completedLessons / course.lessons.length) : 0.0;

    return Scaffold(
      backgroundColor: bgColor,
      body: CustomScrollView(
        slivers: [
          // ── App Bar with Hero Animation ──
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: AppColors.brandGreen,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.brandGreen, AppColors.brandGreen.withValues(alpha: 0.7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: Hero(
                    tag: 'course_icon_${course.id}',
                    child: Icon(course.icon, size: 80, color: Colors.white.withValues(alpha: 0.9)),
                  ),
                ),
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          
          // ── Course Info ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BadgeWidget(
                        text: course.difficulty,
                        color: course.difficulty == 'Beginner' ? Colors.blue : (course.difficulty == 'Intermediate' ? Colors.orange : Colors.red),
                      ),
                      Row(
                        children: [
                          Icon(PhosphorIcons.star(PhosphorIconsStyle.fill), color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text('${course.xpReward} XP', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.amber)),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(course.title, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textColor)),
                  const SizedBox(height: 8),
                  Text(course.subtitle, style: const TextStyle(fontSize: 14, color: Colors.grey, height: 1.4)),
                  const SizedBox(height: 20),

                  // Progress
                  if (percent > 0) ...[
                    AnimatedCourseProgress(progress: percent, color: AppColors.brandGreen),
                    const SizedBox(height: 24),
                  ],

                  // Stats Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildInfoItem(PhosphorIcons.bookOpen(), '${course.totalLessons} Lessons'),
                      _buildInfoItem(PhosphorIcons.clock(), '${course.durationMinutes} min'),
                      _buildInfoItem(PhosphorIcons.question(), '${course.totalQuizzes} Quizzes'),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Description
                  Text('About this course', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
                  const SizedBox(height: 12),
                  Text(course.description, style: TextStyle(fontSize: 14, color: isDark ? Colors.grey[400] : Colors.grey[800], height: 1.5)),
                  const SizedBox(height: 24),

                  // Syllabus
                  Text('Syllabus', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
          
          // ── Lessons List ──
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final lesson = course.lessons[index];
                final isCompleted = progress.isLessonCompleted(lesson.id);
                // The first lesson is always unlocked. Others unlock if the previous is completed.
                final isUnlocked = index == 0 || progress.isLessonCompleted(course.lessons[index - 1].id);

                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: isUnlocked ? AppColors.brandGreen.withValues(alpha: 0.3) : Colors.transparent),
                    boxShadow: isDark ? [] : [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 4)],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isCompleted ? AppColors.brandGreen.withValues(alpha: 0.1) : (isDark ? const Color(0xFF2A2A2A) : const Color(0xFFEEEEEE)),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isCompleted ? PhosphorIcons.checkCircle(PhosphorIconsStyle.fill) : (isUnlocked ? PhosphorIcons.play() : PhosphorIcons.lockKey()),
                        color: isCompleted ? AppColors.brandGreen : Colors.grey,
                      ),
                    ),
                    title: Text(
                      'Lesson ${index + 1}: ${lesson.title}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isUnlocked ? textColor : Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                    subtitle: Text(
                      '${lesson.readingTimeMinutes} min read',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    trailing: isUnlocked
                        ? Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.brandGreen)
                        : null,
                    onTap: isUnlocked
                        ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LessonScreen(course: course, lesson: lesson),
                              ),
                            );
                          }
                        : null,
                  ),
                );
              },
              childCount: course.lessons.length,
            ),
          ),
          
          // ── Quizzes List ──
          if (course.quizzes.isNotEmpty) ...[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 24, bottom: 12),
                child: Text('Quizzes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final quiz = course.quizzes[index];
                  // Quizzes are unlocked if all lessons are complete.
                  final isUnlocked = progress.completedLessonIds.length >= course.lessons.length; 
                  final previousScore = progress.quizScores[quiz.id] ?? 0;
                  final isPassed = previousScore >= quiz.passPercentage;

                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: isUnlocked ? AppColors.brandGreen.withValues(alpha: 0.3) : Colors.transparent),
                      boxShadow: isDark ? [] : [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 4)],
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      leading: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isPassed ? AppColors.brandGreen.withValues(alpha: 0.1) : (isDark ? const Color(0xFF2A2A2A) : const Color(0xFFEEEEEE)),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isPassed ? PhosphorIcons.checkCircle(PhosphorIconsStyle.fill) : (isUnlocked ? PhosphorIcons.question() : PhosphorIcons.lockKey()),
                          color: isPassed ? AppColors.brandGreen : Colors.grey,
                        ),
                      ),
                      title: Text(
                        quiz.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isUnlocked ? textColor : Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                      subtitle: Text(
                        isPassed ? 'Passed (Score: $previousScore%)' : (isUnlocked ? '${quiz.passPercentage}% to pass' : 'Complete lessons to unlock'),
                        style: TextStyle(fontSize: 12, color: isPassed ? AppColors.brandGreen : Colors.grey),
                      ),
                      trailing: isUnlocked
                          ? Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.brandGreen)
                          : null,
                      onTap: isUnlocked
                          ? () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => QuizScreen(course: course, quiz: quiz),
                                ),
                              ).then((_) {
                                // If they passed, mark course as complete
                                if (progress.quizScores[quiz.id] != null && progress.quizScores[quiz.id]! >= quiz.passPercentage) {
                                  LearningService().markCourseCompleted(course.id);
                                }
                              });
                            }
                          : null,
                    ),
                  );
                },
                childCount: course.quizzes.length,
              ),
            ),
          ],
          
          // ── Certificate Button ──
          if (progress.isCourseCompleted(course.id))
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final user = FirebaseAuth.instance.currentUser;
                      final name = user?.displayName ?? user?.email ?? 'Student';
                      final date = DateTime.now();
                      final dateStr = '${date.month}/${date.day}/${date.year}';
                      await CertificateService().generateAndShowCertificate(name, course.title, dateStr);
                    },
                    icon: Icon(PhosphorIcons.certificate(PhosphorIconsStyle.fill), color: Colors.white),
                    label: const Text('View Certificate', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ),
            ),
            
          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String text) {
    return Column(
      children: [
        Icon(icon, color: AppColors.brandGreen, size: 24),
        const SizedBox(height: 6),
        Text(text, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
