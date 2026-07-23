import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  
  // Generic methods can go here, but most specific logic 
  // is handled by the feature-specific services.
  
  Stream<QuerySnapshot> streamCollection(String path) {
    return _db.collection(path).snapshots();
  }
}


