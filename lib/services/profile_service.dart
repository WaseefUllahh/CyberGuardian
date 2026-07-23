import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:image_picker/image_picker.dart';

class ProfileService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Upload avatar image and return download URL
  Future<String?> uploadAvatar(String uid, XFile pickedFile) async {
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final ref = _storage.ref().child('user_avatars').child('${uid}_$timestamp.jpg');
      final bytes = await pickedFile.readAsBytes();
      final metadata = SettableMetadata(contentType: pickedFile.mimeType ?? 'image/jpeg');
      final uploadTask = await ref.putData(bytes, metadata);
      final url = await uploadTask.ref.getDownloadURL();
      await _db.collection('users').doc(uid).update({
        'photoUrl': url,
        'lastLogin': Timestamp.now(),
      });
      return url;
    } catch (e) {
      // print('Avatar upload error: $e');
      return null;
    }
  }

  // Update basic profile fields (name, email, etc.)
  Future<void> updateProfile(String uid, {String? name, String? email, bool? alertsEnabled, bool? biometricEnabled}) async {
    final Map<String, dynamic> updates = {};
    if (name != null) updates['name'] = name.trim();
    if (email != null) updates['email'] = email.trim();
    if (alertsEnabled != null) updates['alertsEnabled'] = alertsEnabled;
    if (biometricEnabled != null) updates['biometricEnabled'] = biometricEnabled;
    if (updates.isNotEmpty) {
      updates['lastLogin'] = Timestamp.now();
      await _db.collection('users').doc(uid).update(updates);
    }
  }

  // Persist preference toggles locally and optionally to Firestore
  Future<void> setPreference(String uid, String key, dynamic value, {bool syncToFirestore = true}) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is String) {
      await prefs.setString(key, value);
    } else if (value is int) {
      await prefs.setInt(key, value);
    } else if (value is double) {
      await prefs.setDouble(key, value);
    }
    if (syncToFirestore) {
      await _db.collection('users').doc(uid).set({
        'settings': {key: value}
      }, SetOptions(merge: true));
    }
  }

  // Retrieve a preference value (local first, then Firestore)
  Future<dynamic> getPreference(String uid, String key) async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(key)) {
      return prefs.get(key);
    }
    final doc = await _db.collection('users').doc(uid).get();
    if (doc.exists && doc.data() != null) {
      final settings = (doc.data()!['settings'] ?? {}) as Map<String, dynamic>;
      return settings[key];
    }
    return null;
  }
}



