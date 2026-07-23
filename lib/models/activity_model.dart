import 'package:cloud_firestore/cloud_firestore.dart';

class ActivityModel {
  final String? id;
  final String userId;
  final String action; // 'URL Scan', 'Message Scan', 'Password Check', 'Report Submitted', 'Login', 'Logout'
  final Timestamp createdAt;

  ActivityModel({
    this.id,
    required this.userId,
    required this.action,
    required this.createdAt,
  });

  factory ActivityModel.fromMap(Map<String, dynamic> map, String docId) {
    return ActivityModel(
      id: docId,
      userId: map['userId'] ?? '',
      action: map['action'] ?? '',
      createdAt: map['createdAt'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'action': action,
      'createdAt': createdAt,
    };
  }
}


