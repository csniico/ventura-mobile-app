import 'package:ventura/core/entities/user_entity.dart';
import 'package:ventura/core/models/user_model.dart';

abstract interface class AuthLocalDataSource {
  Future<User> saveUser(UserModel user);
  Future<User?> getUser();
}