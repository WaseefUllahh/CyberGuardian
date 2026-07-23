import 'package:cloud_firestore/cloud_firestore.dart';

class ScanModel {
  final String? id;
  final String userId;
  final String url;
  final String result;
  final String threatLevel;
  final String provider;
  final String scanDate;
  final String scanTime;
  final Timestamp createdAt;

  ScanModel({
    this.id,
    required this.userId,
    required this.url,
    required this.result,
    required this.threatLevel,
    required this.provider,
    required this.scanDate,
    required this.scanTime,
    required this.createdAt,
  });

  factory ScanModel.fromMap(Map<String, dynamic> map, String docId) {
    return ScanModel(
      id: docId,
      userId: map['userId'] ?? '',
      url: map['url'] ?? '',
      result: map['result'] ?? 'Safe',
      threatLevel: map['threatLevel'] ?? 'Low',
      provider: map['provider'] ?? 'VirusTotal',
      scanDate: map['scanDate'] ?? '',
      scanTime: map['scanTime'] ?? '',
      createdAt: map['createdAt'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'url': url,
      'result': result,
      'threatLevel': threatLevel,
      'provider': provider,
      'scanDate': scanDate,
      'scanTime': scanTime,
      'createdAt': createdAt,
    };
  }
}


