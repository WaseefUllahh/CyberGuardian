import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/report_model.dart';
import 'activity_service.dart';

class ReportService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ActivityService _activityService = ActivityService();

  Future<void> submitReport(String category, String source, String details) async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      final report = ReportModel(
        userId: user.uid,
        category: category,
        source: source,
        details: details,
        status: 'Pending',
        createdAt: Timestamp.now(),
      );

      await _db.collection('reports').add(report.toMap());
      await _activityService.logActivity('Report Submitted');
    } catch (e) {
      debugPrint('Error submitting report: $e');
    }
  }

  Stream<List<ReportModel>> getUserReports() {
    final user = _auth.currentUser;
    if (user == null) return const Stream.empty();

    return _db
        .collection('reports')
        .where('userId', isEqualTo: user.uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ReportModel.fromMap(doc.data(), doc.id))
            .toList());
  }
  
  Stream<List<ReportModel>> getAllReports() {
    return _db
        .collection('reports')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ReportModel.fromMap(doc.data(), doc.id))
            .toList());
  }
}
