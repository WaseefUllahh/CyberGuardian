import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/activity_model.dart';

class AdminService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<UserModel>> getAllUsers() {
    return _db.collection('users').snapshots().map((snapshot) => 
        snapshot.docs.map((doc) => UserModel.fromMap({...doc.data(), 'uid': doc.id})).toList());
  }

  Future<void> deleteUser(String uid) async {
    await _db.collection('users').doc(uid).delete();
  }

  Stream<int> getTotalUsersCount() {
    return _db.collection('users').snapshots().map((snapshot) => snapshot.docs.length);
  }

  Stream<int> getActiveScansCount() {
    return _db.collection('url_scans').snapshots().map((snapshot) => snapshot.docs.length);
  }

  Stream<int> getOpenReportsCount() {
    return _db.collection('reports').where('status', isEqualTo: 'Pending').snapshots().map((snapshot) => snapshot.docs.length);
  }

  Stream<List<ActivityModel>> getAllActivities() {
    return _db
        .collection('activity_logs')
        .orderBy('createdAt', descending: true)
        .limit(100)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ActivityModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  // Returns data for charts: map of Day -> Count
  Stream<Map<int, int>> getDailyActivityStats() {
    return _db
        .collection('activity_logs')
        .where('createdAt', isGreaterThanOrEqualTo: Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 7))))
        .snapshots()
        .map((snapshot) {
      final Map<int, int> stats = {};
      for (var doc in snapshot.docs) {
        final date = (doc.data()['createdAt'] as Timestamp).toDate();
        stats[date.weekday] = (stats[date.weekday] ?? 0) + 1;
      }
      return stats;
    });
  }

  // Aggregate Scan Counters from Users
  Stream<int> getTotalSystemScans() {
    return _db.collection('users').snapshots().map((snapshot) {
      int total = 0;
      for (var doc in snapshot.docs) {
        total += (doc.data()['totalScans'] as num?)?.toInt() ?? 0;
      }
      return total;
    });
  }

  Stream<int> getTotalSafeScans() {
    return _db.collection('users').snapshots().map((snapshot) {
      int safe = 0;
      for (var doc in snapshot.docs) {
        safe += (doc.data()['safeScans'] as num?)?.toInt() ?? 0;
      }
      return safe;
    });
  }

  Stream<int> getTotalUnsafeScans() {
    return _db.collection('users').snapshots().map((snapshot) {
      int unsafe = 0;
      for (var doc in snapshot.docs) {
        unsafe += (doc.data()['unsafeScans'] as num?)?.toInt() ?? 0;
      }
      return unsafe;
    });
  }

  // New stream methods for various admin panels
  Stream<List<Map<String, dynamic>>> getScamReports() =>
      _db.collection('scam_reports').snapshots().map((snapshot) =>
          snapshot.docs.map((doc) => doc.data()).toList());

  Stream<List<Map<String, dynamic>>> getLearningModules() =>
      _db.collection('learning_modules').snapshots().map((snapshot) =>
          snapshot.docs.map((doc) => doc.data()).toList());

  Stream<List<Map<String, dynamic>>> getQuizzes() =>
      _db.collection('quizzes').snapshots().map((snapshot) =>
          snapshot.docs.map((doc) => doc.data()).toList());

  Stream<List<Map<String, dynamic>>> getNotifications() =>
      _db.collection('notifications').snapshots().map((snapshot) =>
          snapshot.docs.map((doc) => doc.data()).toList());

  Stream<List<Map<String, dynamic>>> getApiLogs() =>
      _db.collection('api_logs').snapshots().map((snapshot) =>
          snapshot.docs.map((doc) => doc.data()).toList());
}
