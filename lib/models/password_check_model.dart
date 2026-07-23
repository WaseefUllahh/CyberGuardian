import 'package:cloud_firestore/cloud_firestore.dart';

class PasswordCheckModel {
  final String? id;
  final String userId;
  final String strength; // 'Weak', 'Medium', 'Strong'
  final int score;
  final Timestamp createdAt;

  PasswordCheckModel({
    this.id,
    required this.userId,
    required this.strength,
    required this.score,
    required this.createdAt,
  });

  factory PasswordCheckModel.fromMap(Map<String, dynamic> map, String docId) {
    return PasswordCheckModel(
      id: docId,
      userId: map['userId'] ?? '',
      strength: map['strength'] ?? 'Weak',
      score: map['score'] ?? 0,
      createdAt: map['createdAt'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'strength': strength,
      'score': score,
      'createdAt': createdAt,
    };
  }
}


