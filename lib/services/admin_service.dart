import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AdminService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<UserModel>> getAllUsers() {
    return _db.collection('users').snapshots().map((snapshot) => 
        snapshot.docs.map((doc) => UserModel.fromMap(doc.data())).toList());
  }

  Future<void> deleteUser(String uid) async {
    await _db.collection('users').doc(uid).delete();
  }

  Stream<int> getTotalUsersCount() {
    return _db.collection('users').snapshots().map((snapshot) => snapshot.docs.length);
  }

  Stream<int> getActiveScansCount() {
    return _db.collection('url_scans').snapshots().map((snapshot) => snapshot.docs.length);
  }

  Stream<int> getOpenReportsCount() {
    return _db.collection('reports').where('status', isEqualTo: 'Pending').snapshots().map((snapshot) => snapshot.docs.length);
  }
}
