import 'package:machine_test_totalx/data/models/user_model.dart';

abstract class UserRepositoryInterface {
  Future<void> addUser(UserModel user);
  Future<List<UserModel>> getUsers();
  void resetPagination();
  bool get hasMore;
}