import 'package:flutter/material.dart';

class Course {
  final String id;
  final String title;
  final String subtitle;
  final String description;
  final IconData icon;
  final String difficulty;
  final int durationMinutes;
  final int xpReward;
  final List<String> skills;
  final List<String> requirements;
  final List<String> objectives;
  final List<Lesson> lessons;
  final List<Quiz> quizzes;
  final List<Resource> resources;

  Course({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
    required this.difficulty,
    required this.durationMinutes,
    required this.xpReward,
    required this.skills,
    required this.requirements,
    required this.objectives,
    required this.lessons,
    required this.quizzes,
    required this.resources,
  });

  int get totalLessons => lessons.length;
  int get totalQuizzes => quizzes.length;
}

class Lesson {
  final String id;
  final String title;
  final int readingTimeMinutes;
  final String youtubeVideoId; // Just the ID, not the full URL
  final List<LessonSection> content;

  Lesson({
    required this.id,
    required this.title,
    required this.readingTimeMinutes,
    required this.youtubeVideoId,
    required this.content,
  });
}

enum SectionType { heading, text, tip, warning, bullet, image }

class LessonSection {
  final SectionType type;
  final String content;

  LessonSection({required this.type, required this.content});
}

class Quiz {
  final String id;
  final String title;
  final List<Question> questions;
  final int passPercentage;
  final int xpReward;

  Quiz({
    required this.id,
    required this.title,
    required this.questions,
    this.passPercentage = 80,
    required this.xpReward,
  });
}

class Question {
  final String text;
  final List<String> options;
  final int correctIndex;
  final String explanation;

  Question({
    required this.text,
    required this.options,
    required this.correctIndex,
    required this.explanation,
  });
}

class Resource {
  final String title;
  final String url;

  Resource({required this.title, required this.url});
}

class Achievement {
  final String id;
  final String title;
  final String description;
  final String iconPath;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.iconPath,
  });
}
