import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/scan_model.dart';
import 'activity_service.dart';

class UrlScanService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ActivityService _activityService = ActivityService();

  Future<void> saveScan(String url, String result, String threatLevel, String provider) async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      final now = DateTime.now();
      final scanModel = ScanModel(
        userId: user.uid,
        url: url,
        result: result,
        threatLevel: threatLevel,
        provider: provider,
        scanDate: '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}',
        scanTime: '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}',
        createdAt: Timestamp.now(),
      );

      await _db.collection('url_scans').add(scanModel.toMap());
      await _activityService.logActivity('URL Scan');

      final isSafe = threatLevel.toLowerCase() == 'safe' || threatLevel.isEmpty || threatLevel.toLowerCase().contains('clean');
      
      final userDoc = await _db.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        final data = userDoc.data()!;
        final int currentTotal = data['totalScans'] ?? 0;
        final int currentSafe = data['safeScans'] ?? 0;
        final int currentUnsafe = data['unsafeScans'] ?? 0;

        final newTotal = currentTotal + 1;
        final newSafe = currentSafe + (isSafe ? 1 : 0);
        final newUnsafe = currentUnsafe + (isSafe ? 0 : 1);

        int score = 100 - (newUnsafe * 5);
        if (score < 0) score = 0;
        if (score > 100) score = 100;

        String grade = 'A+';
        if (score >= 95) {
          grade = 'A+';
        } else if (score >= 90) {
          grade = 'A';
        } else if (score >= 80) {
          grade = 'B';
        } else if (score >= 70) {
          grade = 'C';
        } else if (score >= 60) {
          grade = 'D';
        } else {
          grade = 'F';
        }

        await _db.collection('users').doc(user.uid).update({
          'totalScans': newTotal,
          'safeScans': newSafe,
          'unsafeScans': newUnsafe,
          'securityScore': score,
          'securityGrade': grade,
        });
      }
    } catch (e) {
      debugPrint('Error saving URL scan: $e');
    }
  }

  /// Streams the current user's scans.
  /// Uses [authStateChanges] + [asyncExpand] instead of [currentUser] so it
  /// works correctly on Flutter Web, where Firebase Auth restores sessions
  /// asynchronously — meaning [currentUser] is null at widget build time.
  Stream<List<ScanModel>> getUserScans() {
    return _auth.authStateChanges().asyncExpand((user) {
      if (user == null) return const Stream.empty();
      return _db
          .collection('url_scans')
          .where('userId', isEqualTo: user.uid)
          .snapshots()
          .map((snapshot) {
            final docs = snapshot.docs
                .map((doc) => ScanModel.fromMap(doc.data(), doc.id))
                .toList();
            docs.sort((a, b) => b.createdAt.compareTo(a.createdAt));
            return docs;
          });
    });
  }
  
  Stream<List<ScanModel>> getAllScans() {
    return _db
        .collection('url_scans')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ScanModel.fromMap(doc.data(), doc.id))
            .toList());
  }
}
