import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import 'activity_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final ActivityService _activityService = ActivityService();

  // Get current user stream
  Stream<User?> get userStream => _auth.authStateChanges();
  
  // Get current user UID
  String? get currentUid => _auth.currentUser?.uid;

  // Login
  Future<String?> login(String email, String password) async {
    // Guard against empty inputs that can cause channel errors
    if (email.trim().isEmpty) return 'Please enter your email.';
    if (password.isEmpty) return 'Please enter your password.';
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      
      // Update last login and auto-upgrade admin
      if (credential.user != null) {
        final isMasterAdmin = email.trim() == 'wajahatkhan2003@gmail.com' || email.trim() == 'wajahakhan2003@gmail.com';
        
        if (isMasterAdmin) {
           await _db.collection('users').doc(credential.user!.uid).set({
             'role': 'admin',
             'lastLogin': Timestamp.now(),
           }, SetOptions(merge: true));
         } else {
           await _db.collection('users').doc(credential.user!.uid).set({
             'lastLogin': Timestamp.now(),
           }, SetOptions(merge: true));
         }
        await _activityService.logActivity('Login');
      }
      
      return null; // Success
    } on FirebaseAuthException catch (e) {
      if ((e.code == 'user-not-found' || e.code == 'invalid-credential') && 
          (email.trim() == 'wajahatkhan2003@gmail.com' || email.trim() == 'wajahakhan2003@gmail.com')) {
        // Auto-create admin account if it doesn't exist
        final signUpError = await signUp('Admin', email, password, isAdmin: true);
        if (signUpError == 'The account already exists for that email.') {
          return 'Invalid credential. Please check your password.';
        }
        return signUpError;
      }
      return _mapFirebaseError(e);
    } catch (e) {
      return 'An unexpected error occurred. Please try again.';
    }
  }

  // Sign up
  Future<String?> signUp(String name, String email, String password, {bool isAdmin = false}) async {
    // Guard against empty inputs that can cause channel errors
    if (name.trim().isEmpty) return 'Please enter your full name.';
    if (email.trim().isEmpty) return 'Please enter your email.';
    if (password.isEmpty) return 'Please enter a password.';
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      if (credential.user != null) {
        final uid = credential.user!.uid;
        
        // Create user document
        final userModel = UserModel(
          uid: uid,
          name: name.trim(),
          email: email.trim(),
          createdAt: Timestamp.now(),
          lastLogin: Timestamp.now(),
          role: isAdmin ? 'admin' : 'user',
        );

        await _db.collection('users').doc(uid).set(userModel.toMap());
        
        // Ensure user is signed in
        await _auth.signInWithEmailAndPassword(email: email.trim(), password: password);
        await _activityService.logActivity('Login'); // Initial login after signup
      }
      return null;
    } on FirebaseAuthException catch (e) {
      return _mapFirebaseError(e);
    } catch (e) {
      return 'An unexpected error occurred. Please try again.';
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      // Log before sign-out while auth is still valid.
      // Wrapped so a Firestore error never blocks the actual sign-out.
      await _activityService.logActivity('Logout');
    } catch (e) {
      debugPrint('Logout activity log failed (non-fatal): $e');
    }
    await _auth.signOut();
  }

  // Reset Password
  Future<String?> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      return null;
    } on FirebaseAuthException catch (e) {
      return _mapFirebaseError(e);
    } catch (e) {
      return 'An unexpected error occurred.';
    }
  }

  // Fetch current user data from Firestore
  Future<UserModel?> getCurrentUserData() async {
    final uid = currentUid;
    if (uid == null) return null;
    
    final doc = await _db.collection('users').doc(uid).get();
    if (doc.exists && doc.data() != null) {
      return UserModel.fromMap(doc.data()!);
    }
    return null;
  }

  Stream<UserModel?> getCurrentUserDataStream() {
    return _auth.authStateChanges().asyncExpand((firebaseUser) {
      if (firebaseUser == null) return Stream.value(null);
      return _db.collection('users').doc(firebaseUser.uid).snapshots().map((doc) {
        if (doc.exists && doc.data() != null) {
          return UserModel.fromMap(doc.data()!);
        }
        return null;
      });
    });
  }

  String _mapFirebaseError(FirebaseAuthException e) {
    debugPrint('Firebase Auth Error: ${e.code} - ${e.message}');
    switch (e.code) {
      case 'user-not-found':
        return 'No account found for that email.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'invalid-credential':
        return 'Invalid email or password. Please check and try again.';
      case 'invalid-email':
        return 'The email address is badly formatted.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'email-already-in-use':
        return 'The account already exists for that email.';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled.';
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'too-many-requests':
        return 'Too many failed attempts. Please wait and try again.';
      case 'network-request-failed':
        return 'Network error. Please check your internet connection.';
      default:
        return e.message ?? 'An error occurred. Please try again. (${e.code})';
    }
  }
}
