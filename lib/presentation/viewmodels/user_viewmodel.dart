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

  bool _isFetchingMore = false;
  bool get isFetchingMore => _isFetchingMore;

  List<UserModel> _filteredUsers = [];
  List<UserModel> get filteredUsers => _filteredUsers;

  Future<bool> addUser({required String name, required int age}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = UserModel(name: name, age: age, createdAt: Timestamp.now());

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
    _users = [];
    repository.resetPagination();
    notifyListeners();

    try {
      _users = await repository.getUsers();
      _filteredUsers = _users; // add this
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> loadMoreUsers() async {
    if (_isFetchingMore || !repository.hasMore) return;

    _isFetchingMore = true;
    notifyListeners();

    try {
      final newUsers = await repository.getUsers();
      _users.addAll(newUsers);
      _filteredUsers = _users; // add this
      _isFetchingMore = false;
      notifyListeners();
    } catch (e) {
      _isFetchingMore = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  void searchUsers(String query) {
    if (query.isEmpty) {
      _filteredUsers = _users;
    } else {
      _filteredUsers = _users
          .where(
            (user) => user.name.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    }
    notifyListeners();
  }

 void sortUsers(int category) {
  if (category == 0) {
    // All - original order
    _filteredUsers = List.from(_users);
  } else if (category == 1) {
    // Elder - age above 60
    _filteredUsers = _users
        .where((user) => user.age > 60)
        .toList();
  } else if (category == 2) {
    // Younger - age below 60
    _filteredUsers = _users
        .where((user) => user.age < 60)
        .toList();
  }
  notifyListeners();
}
}
