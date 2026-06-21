import 'package:cloud_firestore/cloud_firestore.dart';

import 'firebase_service.dart';

class UserService{
  Future<void> createUser(String firstname, String lastname, int age) async {
    try {
      final user = <String, Object>{
        "first" : firstname,
        "last" : lastname,
        "age" : age,
      };
      DocumentReference doc = await FirebaseService.firestore.collection("users").add(user);
      print('DocumentSnapshot added with ID: ${doc.id}');
    }
    catch(e){
      print("error : $e");
    }
  }
}
