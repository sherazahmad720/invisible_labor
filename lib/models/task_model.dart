import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  String? title;
  DateTime? markAt;
  int? durationInMinutes;
  String? doneBy;
  String? category;
  List<String>? tags;
  bool isPublic;
  DocumentReference? ref;

  TaskModel({
    this.title,
    this.markAt,
    this.durationInMinutes,
    this.category,
    this.doneBy,
    this.tags,
    this.isPublic = true,
    this.ref,
  });

  factory TaskModel.fromDoc(DocumentSnapshot doc) {
    var data = doc.data() as Map<String, dynamic>;
    return TaskModel(
      ref: doc.reference,
      title: data['title'],
      durationInMinutes: data['durationInMinutes'],
      doneBy: data['doneBy'],
      isPublic: data['isPublic'],
      category: data['category'],
      tags: List<String>.from(doc['tags']),
      markAt:
          doc['markAt'] != null ? (doc['markAt'] as Timestamp).toDate() : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'doneBy': doneBy,
      'isPublic': isPublic,
      'category': category,
      'tags': tags,
      'markAt': FieldValue.serverTimestamp(),
      'durationInMinutes': durationInMinutes,
    };
  }
}
