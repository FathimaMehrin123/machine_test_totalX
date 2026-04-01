// data/repositories/user_repository.dart

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:machine_test_totalx/data/models/user_model.dart';
import 'package:machine_test_totalx/domain/repositories/user_repository_interface.dart';

class UserRepository implements UserRepositoryInterface {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<void> addUser(UserModel user, {File? image}) async {
    try {
      final id = _firestore.collection('users').doc().id;
      user.id = id;
      await _firestore.collection('users').doc(id).set(user.toMap());
    } catch (e) {
      throw Exception('Failed to add user: $e');
    }
  }

  final FirebaseStorage _storage = FirebaseStorage.instance;

Future<String?> _uploadImage(File image,) async {
  try {
    final ref = _storage
        .ref()
        .child('profile_images/${DateTime.now().millisecondsSinceEpoch}.jpg');
    await ref.putFile(image);
    return await ref.getDownloadURL();
  } catch (e) {
    return null;
  }
}


  @override
DocumentSnapshot? _lastDocument;
bool _hasMore = true;
bool get hasMore => _hasMore;

Future<List<UserModel>> getUsers() async {
  try {
    Query query = _firestore
        .collection('users')
        .orderBy('createdAt', descending: true)
        .limit(5);

    if (_lastDocument != null) {
      query = query.startAfterDocument(_lastDocument!);
    }

    final snapshot = await query.get();

    if (snapshot.docs.isEmpty || snapshot.docs.length < 5) {
      _hasMore = false;
    }

    if (snapshot.docs.isNotEmpty) {
      _lastDocument = snapshot.docs.last;
    }

    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      return UserModel.fromMap(data);
    }).toList();
  } catch (e) {
    throw Exception('Failed to fetch users: $e');
  }
}

void resetPagination() {
  _lastDocument = null;
  _hasMore = true;
}
}
