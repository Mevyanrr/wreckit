import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService{
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static FirebaseFirestore get firestore => _firestore;

  static CollectionReference collection(String path) => _firestore.collection(path);
}