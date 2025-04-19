import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:labor/models/user_model.dart';

class FirebaseServices {
  static CollectionReference userCollection = FirebaseFirestore.instance
      .collection('users');
  static CollectionReference workspaceCollection = FirebaseFirestore.instance
      .collection('workspaces');
  static CollectionReference tasksCollection = FirebaseFirestore.instance
      .collection('tasks');
  static CollectionReference groupCollection = FirebaseFirestore.instance
      .collection('groups');

  static Future<UserModel?> getUser(String userId) async {
    DocumentSnapshot doc = await userCollection.doc(userId).get();
    if (doc.exists) {
      return UserModel.fromDoc(doc);
    }
    return null;
  }

  static Future<void> saveUser(UserModel user, String userId) async {
    userCollection.doc(userId).set(user.toMap());
  }
}
