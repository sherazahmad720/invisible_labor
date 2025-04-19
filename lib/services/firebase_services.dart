import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:labor/models/user_model.dart';
import 'package:labor/models/workspace_model.dart';

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

  static Future<WorkspaceModel?> getWorkspace(DocumentReference ref) async {
    DocumentSnapshot snapshot = await ref.get();
    if (snapshot.exists) {
      return WorkspaceModel.fromDoc(snapshot);
    }
    return null;
  }

  static Future<void> saveWorkspace(
    WorkspaceModel workspaceModel, {
    String? workspaceId,
  }) async {
    if (workspaceId == null) {
      await workspaceCollection.add(workspaceModel.toMap());
    } else {
      await workspaceCollection.doc(workspaceId).set(workspaceModel.toMap());
    }
  }

}
