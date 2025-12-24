import 'package:ventura/core/data/models/user_model.dart';

abstract interface class UserRemoteDataSource {
  Future<UserModel?> getUser({required String userId});
}
