// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String name;
  int age;
  String? id;
  Timestamp createdAt;
  UserModel({
    required this.name,
    required this.age,
    this.id,
    required this.createdAt,
  });
  

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'age': age,
      'id': id,
      'createdAt': createdAt,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] as String,
      age: map['age'] as int,
      id: map['id'] != null ? map['id'] as String : null,
      createdAt: map['createdAt'] as Timestamp
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
