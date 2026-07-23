import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/activity_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ActivityService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> logActivity(String action) async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      final activity = ActivityModel(
        userId: user.uid,
        action: action,
        createdAt: Timestamp.now(),
      );

      await _db.collection('activity_logs').add(activity.toMap());
    } catch (e) {
      debugPrint('Error logging activity: $e');
    }
  }

  Stream<List<ActivityModel>> getUserActivities(String userId) {
    return _db
        .collection('activity_logs')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ActivityModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  Stream<List<ActivityModel>> getAllActivities() {
    return _db
        .collection('activity_logs')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ActivityModel.fromMap(doc.data(), doc.id))
            .toList());
  }
}


