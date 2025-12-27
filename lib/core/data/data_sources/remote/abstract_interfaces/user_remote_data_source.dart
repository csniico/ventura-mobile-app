import 'package:ventura/core/data/models/user_model.dart';

abstract interface class UserRemoteDataSource {
  Future<UserModel?> getUser({required String userId});

  Future<UserModel?> updateUserProfile({
    required String userId,
    required String firstName,
    String? lastName,
    String? avatarUrl,
  });
}
