import 'package:ventura/core/domain/entities/user_entity.dart';
import 'package:ventura/core/data/models/user_model.dart';

abstract interface class AuthLocalDataSource {
  Future<User> saveUser(UserModel user);

  Future<User?> getUser();
}
