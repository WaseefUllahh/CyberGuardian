import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/learning_progress.dart';

class LearningService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get stream of learning progress
  Stream<LearningProgress?> getProgressStream() {
    final user = _auth.currentUser;
    if (user == null) return const Stream.empty();

    return _db
        .collection('learning_progress')
        .doc(user.uid)
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists) {
        return LearningProgress.fromMap(snapshot.data()!, snapshot.id);
      }
      return LearningProgress(uid: user.uid);
    });
  }

  // Get current progress once
  Future<LearningProgress> getProgress() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Not logged in');

    final doc = await _db.collection('learning_progress').doc(user.uid).get();
    if (doc.exists) {
      return LearningProgress.fromMap(doc.data()!, doc.id);
    }
    return LearningProgress(uid: user.uid);
  }

  // Mark lesson as completed
  Future<void> markLessonCompleted(String lessonId, int xpReward) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final docRef = _db.collection('learning_progress').doc(user.uid);
    
    await _db.runTransaction((transaction) async {
      final doc = await transaction.get(docRef);
      if (!doc.exists) {
        final newProgress = LearningProgress(
          uid: user.uid,
          completedLessonIds: [lessonId],
          totalXp: xpReward,
          lastLearnedDate: Timestamp.now(),
          currentStreak: 1,
        );
        transaction.set(docRef, newProgress.toMap());
        return;
      }

      final data = doc.data()!;
      List<String> completed = List<String>.from(data['completedLessonIds'] ?? []);
      
      if (!completed.contains(lessonId)) {
        completed.add(lessonId);
        int currentXp = data['totalXp'] ?? 0;
        
        // Handle streak logic
        int streak = data['currentStreak'] ?? 0;
        Timestamp? lastLearned = data['lastLearnedDate'];
        final now = DateTime.now();
        
        if (lastLearned != null) {
          final lastDate = lastLearned.toDate();
          final diffDays = now.difference(lastDate).inDays;
          if (diffDays == 1) {
            streak += 1;
          } else if (diffDays > 1) {
            streak = 1; // Reset streak
          }
        } else {
          streak = 1;
        }

        transaction.update(docRef, {
          'completedLessonIds': completed,
          'totalXp': currentXp + xpReward,
          'lastLearnedDate': Timestamp.now(),
          'currentStreak': streak,
        });
      }
    });
  }

  // Save quiz score and completion
  Future<void> saveQuizScore(String quizId, String courseId, int score, int passScore, int xpReward) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final docRef = _db.collection('learning_progress').doc(user.uid);

    await _db.runTransaction((transaction) async {
      final doc = await transaction.get(docRef);
      if (!doc.exists) {
        final newProgress = LearningProgress(
          uid: user.uid,
          quizScores: {quizId: score},
          totalXp: (score >= passScore) ? xpReward : 0,
        );
        transaction.set(docRef, newProgress.toMap());
        return;
      }

      final data = doc.data()!;
      Map<String, int> scores = Map<String, int>.from(data['quizScores'] ?? {});
      int previousBest = scores[quizId] ?? 0;
      
      if (score > previousBest) {
        scores[quizId] = score;
        int currentXp = data['totalXp'] ?? 0;
        
        // Only award XP if they passed for the first time
        if (score >= passScore && previousBest < passScore) {
          currentXp += xpReward;
        }

        transaction.update(docRef, {
          'quizScores': scores,
          'totalXp': currentXp,
        });
      }
    });
  }

  // Mark course completed (to generate certificate)
  Future<void> markCourseCompleted(String courseId) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final docRef = _db.collection('learning_progress').doc(user.uid);
    await docRef.set({
      'completedCourseIds': FieldValue.arrayUnion([courseId])
    }, SetOptions(merge: true));
  }
}
