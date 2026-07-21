import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import '../utils/app_colors.dart';
import '../models/learning_models.dart';
import '../services/learning_service.dart';

class LessonScreen extends StatefulWidget {
  final Course course;
  final Lesson lesson;

  const LessonScreen({super.key, required this.course, required this.lesson});

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  late YoutubePlayerController _ytController;
  final LearningService _learningService = LearningService();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _ytController = YoutubePlayerController(
      params: const YoutubePlayerParams(
        showFullscreenButton: true,
        mute: false,
        showControls: true,
        strictRelatedVideos: true,
      ),
    );
    _ytController.cueVideoById(videoId: widget.lesson.youtubeVideoId);
  }

  @override
  void dispose() {
    _ytController.close();
    super.dispose();
  }

  Future<void> _completeLesson() async {
    setState(() => _isSaving = true);
    await _learningService.markLessonCompleted(widget.lesson.id, 20);
    setState(() => _isSaving = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lesson completed! +20 XP'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF121212) : Colors.white;
    final textColor = isDark ? Colors.white : AppColors.dark;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text('Lesson', style: TextStyle(color: textColor)),
        backgroundColor: bgColor,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // YouTube Player — web-compatible via iframe (youtube_player_iframe v6)
              YoutubePlayer(
                controller: _ytController,
                aspectRatio: 16 / 9,
              ),

              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.lesson.title,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(PhosphorIcons.clock(), size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          '${widget.lesson.readingTimeMinutes} min read',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Divider(),
                    const SizedBox(height: 24),

                    // Render lesson content sections
                    ...widget.lesson.content
                        .map((section) => _buildSection(section, isDark)),

                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: _isSaving ? null : _completeLesson,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.brandGreen,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isSaving
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text(
                                'Mark as Completed',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(LessonSection section, bool isDark) {
    final textColor = isDark ? Colors.white : AppColors.dark;
    final bodyColor = isDark ? Colors.grey[300] : Colors.grey[800];

    switch (section.type) {
      case SectionType.heading:
        return Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 8),
          child: Text(
            section.content,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        );

      case SectionType.text:
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Text(
            section.content,
            style: TextStyle(fontSize: 15, color: bodyColor, height: 1.6),
          ),
        );

      case SectionType.bullet:
        return Padding(
          padding: const EdgeInsets.only(bottom: 8, left: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '• ',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.brandGreen,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                child: Text(
                  section.content,
                  style: TextStyle(fontSize: 15, color: bodyColor, height: 1.5),
                ),
              ),
            ],
          ),
        );

      case SectionType.tip:
        return _buildCallout(
          section.content,
          PhosphorIcons.lightbulb(PhosphorIconsStyle.fill),
          Colors.amber,
          isDark,
        );

      case SectionType.warning:
        return _buildCallout(
          section.content,
          PhosphorIcons.warning(PhosphorIconsStyle.fill),
          Colors.red,
          isDark,
        );

      // BUG 7 FIX: handle image section type (was silently dropped before)
      case SectionType.image:
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              section.content,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(
                height: 160,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFEEEEEE),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Icon(PhosphorIcons.image(), color: Colors.grey, size: 40),
                ),
              ),
            ),
          ),
        );
    }
  }

  Widget _buildCallout(String text, IconData icon, Color color, bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.white : AppColors.dark,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
