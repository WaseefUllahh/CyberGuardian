import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/message_model.dart';
import 'activity_service.dart';

class MessageScanService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ActivityService _activityService = ActivityService();

  Future<void> saveMessageScan(String type, String message, int riskScore, String classification) async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      final messageModel = MessageModel(
        userId: user.uid,
        type: type,
        message: message,
        riskScore: riskScore,
        classification: classification,
        createdAt: Timestamp.now(),
      );

      await _db.collection('message_scans').add(messageModel.toMap());
      await _activityService.logActivity('Message Scan');
    } catch (e) {
      debugPrint('Error saving message scan: $e');
    }
  }

  Stream<List<MessageModel>> getUserMessageScans() {
    final user = _auth.currentUser;
    if (user == null) return const Stream.empty();

    return _db
        .collection('message_scans')
        .where('userId', isEqualTo: user.uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MessageModel.fromMap(doc.data(), doc.id))
            .toList());
  }
}
