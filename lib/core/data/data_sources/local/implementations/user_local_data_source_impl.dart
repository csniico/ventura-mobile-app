import 'package:ventura/core/data/data_sources/local/abstract_interfaces/user_local_data_source.dart';
import 'package:ventura/core/data/models/user_model.dart';
import 'package:ventura/core/services/user_service.dart';

class UserLocalDataSourceImpl implements UserLocalDataSource {
  final UserService userService;

  UserLocalDataSourceImpl({required this.userService});

  @override
  Future<UserModel?> getUser() async {
    return await userService.getUser();
  }

  @override
  Future<UserModel> saveUser(UserModel user) async {
    return await userService.saveUser(user);
  }

  @override
  Future<void> signOut() async {
    return await userService.signOut();
  }
}
