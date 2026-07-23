import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String? id;
  final String userId;
  final String type; // 'SMS' or 'Email'
  final String message;
  final int riskScore;
  final String classification; // 'Safe', 'Suspicious', 'Phishing'
  final Timestamp createdAt;

  MessageModel({
    this.id,
    required this.userId,
    required this.type,
    required this.message,
    required this.riskScore,
    required this.classification,
    required this.createdAt,
  });

  factory MessageModel.fromMap(Map<String, dynamic> map, String docId) {
    return MessageModel(
      id: docId,
      userId: map['userId'] ?? '',
      type: map['type'] ?? 'SMS',
      message: map['message'] ?? '',
      riskScore: map['riskScore'] ?? 0,
      classification: map['classification'] ?? 'Safe',
      createdAt: map['createdAt'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'type': type,
      'message': message,
      'riskScore': riskScore,
      'classification': classification,
      'createdAt': createdAt,
    };
  }
}


