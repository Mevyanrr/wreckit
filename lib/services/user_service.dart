import 'package:cloud_firestore/cloud_firestore.dart';

import 'firebase_service.dart';

class UserService{
  Future<void> createUser(String username, String firstname, String lastname, int age) async {
    try {
      final user = <String, Object>{
        "first" : firstname,
        "last" : lastname,
        "age" : age,
      };
      DocumentReference doc = FirebaseService.firestore.collection("users").doc(username);
      await doc.set(user);
      print('DocumentSnapshot added with ID: ${doc.id}');
    }
    catch(e){
      print("error : $e");
    }
  }

  Future<void> deleteUserData(String username) async{
    try {
      final docRef = FirebaseService.firestore.collection("users").doc(username);
      
      final update = <String, Object>{
        "first" : FieldValue.delete(),
      };
      docRef.update(update);
      print("document field is deleted : ${docRef.id}");
    }catch(e){
      print("error on deleting : $e");
    }
  }

  Future<void> deleteUserInfo(String username) async{
    try {
      final doc = FirebaseService.firestore.collection("users");
      await doc.doc(username).delete();
      print("document : $username is deleted!");
    }catch(e){
      print("document $username unable to deleted");
    }
  }
}
