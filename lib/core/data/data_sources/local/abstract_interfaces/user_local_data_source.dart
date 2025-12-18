import 'package:ventura/core/data/models/user_model.dart';

abstract interface class UserLocalDataSource {
  Future<UserModel?> getUser();

  Future<UserModel> saveUser(UserModel user);

  Future<void> signOut();
}
