import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:labor/models/task_model.dart';

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

  static Future<void> createUser(UserModel user, String userId) async {
    userCollection.doc(userId).set(user.toMap());
  }

  static Future<WorkspaceModel?> getWorkspace(DocumentReference ref) async {
    DocumentSnapshot snapshot = await ref.get();
    if (snapshot.exists) {
      return WorkspaceModel.fromDoc(snapshot);
    }
    return null;
  }

  static Future<DocumentReference?> createWorkspace(
    WorkspaceModel workspaceModel, {
    String? workspaceId,
  }) async {
    if (workspaceId == null) {
      DocumentReference documentReference = await workspaceCollection.add(
        workspaceModel.toMap(),
      );
      return documentReference;
    } else {
      await workspaceCollection.doc(workspaceId).set(workspaceModel.toMap());
      return workspaceModel.ref;
    }
  }

  static Query myWorkspacesQuery = workspaceCollection.where(
    'members',
    arrayContains: FirebaseAuth.instance.currentUser?.uid ?? '-',
  );
  static Query searchUser(String searchQuery) =>
      userCollection.where('searchIndex', arrayContains: searchQuery);

  static Future<DocumentReference?> createTask(
    TaskModel taskModel, {
    String? taskId,
  }) async {
    if (taskId == null) {
      DocumentReference documentReference = await tasksCollection.add(
        taskModel.toMap(),
      );
      return documentReference;
    } else {
      await tasksCollection.doc(taskId).set(taskModel.toMap());
      return taskModel.ref;
    }
  }

  Query myTasksQuery(String workspaceId) {
    return tasksCollection.where('workspaceId', isEqualTo: workspaceId);
  }

  Query myRecentTasksQuery(String workspaceId) {
    return tasksCollection.where('workspaceId', isEqualTo: workspaceId);
    // .orderBy('startTime');
  }
}
