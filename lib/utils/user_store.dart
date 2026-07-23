import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

/// Singleton that caches the currently signed-in [UserModel] and
/// keeps it in sync with Firestore. Used by the drawer and other
/// widgets that don't own a StreamBuilder.
class UserStore {
  static final UserStore _instance = UserStore._internal();
  factory UserStore() => _instance;
  UserStore._internal() {
    _init();
  }

  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;

  void _init() {
    FirebaseAuth.instance.authStateChanges().listen((firebaseUser) {
      if (firebaseUser == null) {
        _currentUser = null;
        return;
      }
      FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser.uid)
          .snapshots()
          .listen((doc) {
        if (doc.exists && doc.data() != null) {
          _currentUser = UserModel.fromMap(doc.data()!);
        }
      });
    });
  }

  Future<void> logout() async {
    _currentUser = null;
    await AuthService().logout();
  }
}


