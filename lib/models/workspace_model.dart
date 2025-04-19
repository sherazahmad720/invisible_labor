import 'package:cloud_firestore/cloud_firestore.dart';

class WorkspaceModel {
  String? name;
  DateTime? createAt;
  String? createdBy;
  List<String>? members;
  DocumentReference? ref;

  WorkspaceModel({
    this.name,
    this.createAt,
    this.createdBy,
    this.members,
    this.ref,
  });

  factory WorkspaceModel.fromDoc(DocumentSnapshot doc) {
    var data = doc.data() as Map<String, dynamic>;
    return WorkspaceModel(
      name: data['name'],

      createAt:
          doc['createdAt'] != null
              ? (doc['createdAt'] as Timestamp).toDate()
              : null,
      createdBy: data['createdBy'],
      members: List<String>.from(doc['members']),

      ref: doc.reference,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'members': members,
      'createdBy': createdBy,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
