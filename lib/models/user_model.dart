// User Information
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? id;
  final String? displayName;

  final String? photoUrl;
  final String? email;
  final DocumentReference? selectedWorkspaceRef;
  final List<String>? friendsList;
  final List<String>? workspaces;
  final List<String>? groupLists;
  final DateTime? creationDate;
  final DocumentReference? ref;

  UserModel({
    this.id,
    this.displayName,
    this.photoUrl,
    this.email,
    this.friendsList,
    this.groupLists,
    this.ref,
    this.selectedWorkspaceRef,
    this.creationDate,
    this.workspaces,
  });
  factory UserModel.fromDoc(DocumentSnapshot doc) {
    var data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      displayName: data['displayName'],
      photoUrl: data['photoUrl'],
      email: data['email'],
      friendsList: List<String>.from(doc['friendsList']),
      creationDate:
          doc['creationDate'] != null
              ? (doc['creationDate'] as Timestamp).toDate()
              : null,
      groupLists: List<String>.from(doc['groupLists']),
      selectedWorkspaceRef: data['selectedWorkspaceRef'],
      workspaces: List<String>.from(doc['workspaces']),

      ref: doc.reference,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'displayName': displayName,

      'photoUrl': photoUrl,
      'email': email,
      'friendsList': friendsList,
      'creationDate': FieldValue.serverTimestamp(),
      'groupLists': groupLists,
      'selectedWorkspaceRef': selectedWorkspaceRef,
      'workspaces': workspaces,
    };
  }
}
