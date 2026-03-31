// presentation/viewmodels/user_provider.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:machine_test_totalx/data/models/user_model.dart';
import 'package:machine_test_totalx/domain/repositories/user_repository_interface.dart';

class UserProvider extends ChangeNotifier {
  final UserRepositoryInterface repository;

  UserProvider({required this.repository});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<UserModel> _users = [];
  List<UserModel> get users => _users;

  Future<bool> addUser({
    required String name,
    required int age,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = UserModel(
        name: name,
        age: age,
        createdAt: Timestamp.now(),
      );

      await repository.addUser(user);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<void> getUsers() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _users = await repository.getUsers();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }
}