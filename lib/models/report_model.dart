import 'package:cloud_firestore/cloud_firestore.dart';

class ReportModel {
  final String? id;
  final String userId;
  final String category;
  final String source;
  final String details;
  final String status; // 'Pending', 'Reviewed', 'Resolved'
  final Timestamp createdAt;

  ReportModel({
    this.id,
    required this.userId,
    required this.category,
    required this.source,
    required this.details,
    this.status = 'Pending',
    required this.createdAt,
  });

  factory ReportModel.fromMap(Map<String, dynamic> map, String docId) {
    return ReportModel(
      id: docId,
      userId: map['userId'] ?? '',
      category: map['category'] ?? '',
      source: map['source'] ?? '',
      details: map['details'] ?? '',
      status: map['status'] ?? 'Pending',
      createdAt: map['createdAt'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'category': category,
      'source': source,
      'details': details,
      'status': status,
      'createdAt': createdAt,
    };
  }
}
