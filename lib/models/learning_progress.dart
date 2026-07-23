import 'package:cloud_firestore/cloud_firestore.dart';

class LearningProgress {
  final String uid;
  final int totalXp;
  final int currentStreak;
  final Timestamp? lastLearnedDate;
  final List<String> completedCourseIds;
  final List<String> completedLessonIds;
  final Map<String, int> quizScores; // Map of quizId to highest score achieved
  final List<String> achievementsUnlocked;
  final List<String> bookmarkedLessonIds;

  LearningProgress({
    required this.uid,
    this.totalXp = 0,
    this.currentStreak = 0,
    this.lastLearnedDate,
    this.completedCourseIds = const [],
    this.completedLessonIds = const [],
    this.quizScores = const {},
    this.achievementsUnlocked = const [],
    this.bookmarkedLessonIds = const [],
  });

  factory LearningProgress.fromMap(Map<String, dynamic> map, String docId) {
    return LearningProgress(
      uid: docId,
      totalXp: map['totalXp'] ?? 0,
      currentStreak: map['currentStreak'] ?? 0,
      lastLearnedDate: map['lastLearnedDate'],
      completedCourseIds: List<String>.from(map['completedCourseIds'] ?? []),
      completedLessonIds: List<String>.from(map['completedLessonIds'] ?? []),
      quizScores: Map<String, int>.from(map['quizScores'] ?? {}),
      achievementsUnlocked: List<String>.from(map['achievementsUnlocked'] ?? []),
      bookmarkedLessonIds: List<String>.from(map['bookmarkedLessonIds'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'totalXp': totalXp,
      'currentStreak': currentStreak,
      'lastLearnedDate': lastLearnedDate,
      'completedCourseIds': completedCourseIds,
      'completedLessonIds': completedLessonIds,
      'quizScores': quizScores,
      'achievementsUnlocked': achievementsUnlocked,
      'bookmarkedLessonIds': bookmarkedLessonIds,
    };
  }

  // Helper method to check if a lesson is completed
  bool isLessonCompleted(String lessonId) => completedLessonIds.contains(lessonId);

  // Helper method to check if a course is completed
  bool isCourseCompleted(String courseId) => completedCourseIds.contains(courseId);
}


