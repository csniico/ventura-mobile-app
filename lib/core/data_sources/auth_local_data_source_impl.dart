import 'package:ventura/core/data_sources/auth_local_data_source.dart';
import 'package:ventura/core/entities/user_entity.dart';
import 'package:ventura/core/models/user_model.dart';
import 'package:ventura/core/services/user/user_service.dart';

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final UserService userService;

  AuthLocalDataSourceImpl({required this.userService});

  @override
  Future<User> saveUser(UserModel user) async {
    return await userService.saveUser(user);
  }

  @override
  Future<User?> getUser() async {
    final cachedUser = userService.user;
    if (cachedUser != null) {
      return cachedUser;
    }
    return await userService.getUser();
  }
}
