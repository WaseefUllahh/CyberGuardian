import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/password_check_model.dart';
import 'activity_service.dart';

class PasswordService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ActivityService _activityService = ActivityService();

  Future<void> savePasswordCheck(String strength, int score) async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      final pwdCheck = PasswordCheckModel(
        userId: user.uid,
        strength: strength,
        score: score,
        createdAt: Timestamp.now(),
      );

      await _db.collection('password_checks').add(pwdCheck.toMap());
      await _activityService.logActivity('Password Check');
    } catch (e) {
      debugPrint('Error saving password check: $e');
    }
  }

  Stream<List<PasswordCheckModel>> getUserPasswordChecks() {
    final user = _auth.currentUser;
    if (user == null) return const Stream.empty();

    return _db
        .collection('password_checks')
        .where('userId', isEqualTo: user.uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => PasswordCheckModel.fromMap(doc.data(), doc.id))
            .toList());
  }
}
