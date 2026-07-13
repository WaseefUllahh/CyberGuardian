import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final int securityScore;
  final String securityGrade;
  final Timestamp createdAt;
  final Timestamp lastLogin;
  final String? photoUrl;
  final bool alertsEnabled;
  final bool biometricEnabled;
  final String role; // 'user' or 'admin'
  final String accountStatus;
  final int totalScans;
  final int safeScans;
  final int unsafeScans;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.securityScore = 100,
    this.securityGrade = 'A+',
    required this.createdAt,
    required this.lastLogin,
    this.photoUrl,
    this.alertsEnabled = true,
    this.biometricEnabled = false,
    this.role = 'user',
    this.accountStatus = 'Active',
    this.totalScans = 0,
    this.safeScans = 0,
    this.unsafeScans = 0,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      securityScore: map['securityScore'] ?? 100,
      securityGrade: map['securityGrade'] ?? 'A+',
      createdAt: map['createdAt'] ?? Timestamp.now(),
      lastLogin: map['lastLogin'] ?? Timestamp.now(),
      photoUrl: map['photoUrl'],
      alertsEnabled: map['alertsEnabled'] ?? true,
      biometricEnabled: map['biometricEnabled'] ?? false,
      role: map['role'] ?? 'user',
      accountStatus: map['accountStatus'] ?? 'Active',
      totalScans: map['totalScans'] ?? 0,
      safeScans: map['safeScans'] ?? 0,
      unsafeScans: map['unsafeScans'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'securityScore': securityScore,
      'securityGrade': securityGrade,
      'createdAt': createdAt,
      'lastLogin': lastLogin,
      'photoUrl': photoUrl,
      'alertsEnabled': alertsEnabled,
      'biometricEnabled': biometricEnabled,
      'role': role,
      'accountStatus': accountStatus,
      'totalScans': totalScans,
      'safeScans': safeScans,
      'unsafeScans': unsafeScans,
    };
  }
}
