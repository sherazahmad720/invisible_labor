// User Information
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String name;
  final String phone;
  final String? photoUrl;
  final String email;
  final bool? isBlocked;

  UserModel({
    required this.id,
    required this.name,
    required this.phone,
    this.photoUrl,
    required this.email,
    this.isBlocked,
  });
  factory UserModel.fromDoc(DocumentSnapshot doc) {
    var data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id, // Corrected from json.id to data['id']
      name: data['name'],
      phone: data['phone'],
      photoUrl: data['photoUrl'],
      email: data['email'],
      isBlocked: data['isBlocked'] ?? false,
    );
  }

  factory UserModel.fromMap(Map<String, dynamic> doc) {
    return UserModel(
      id: doc['id'],
      name: doc['name'],
      phone: doc['phone'],
      photoUrl: doc['photoUrl'],
      email: doc['email'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'photoUrl': photoUrl,
      'email': email,
    };
  }
}
