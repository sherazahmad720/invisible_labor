import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  String? title;
  DateTime? markAt;
  int? durationInMinutes;
  DateTime? startTime;
  DateTime? endTime;
  String? doneBy;
  String? category;
  List<String>? tags;
  bool isPublic;
  DocumentReference? ref;
  String? workspaceId;

  TaskModel({
    this.title,
    this.markAt,
    this.durationInMinutes,
    this.startTime,
    this.endTime,
    this.category,
    this.doneBy,
    this.tags,
    this.isPublic = true,
    this.workspaceId,
    this.ref,
  });

  factory TaskModel.fromDoc(DocumentSnapshot doc) {
    var data = doc.data() as Map<String, dynamic>;
    return TaskModel(
      ref: doc.reference,
      title: data['title'],
      durationInMinutes: data['durationInMinutes'],
      startTime:
          doc['startTime'] != null
              ? (doc['startTime'] as Timestamp).toDate()
              : null,
      endTime:
          doc['endTime'] != null
              ? (doc['endTime'] as Timestamp).toDate()
              : null,
      doneBy: data['doneBy'],
      isPublic: data['isPublic'],
      category: data['category'],
      workspaceId: data['workspaceId'],
      tags: List<String>.from(doc['tags'] ?? []),
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
      'workspaceId': workspaceId,
      'markAt': FieldValue.serverTimestamp(),
      'durationInMinutes': durationInMinutes,
      'startTime': startTime,
      'endTime': endTime,
    };
  }
}
