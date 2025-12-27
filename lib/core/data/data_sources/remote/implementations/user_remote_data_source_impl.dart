import 'package:dio/dio.dart';
import 'package:ventura/config/app_logger.dart';
import 'package:ventura/config/server_routes.dart';
import 'package:ventura/core/data/data_sources/remote/abstract_interfaces/user_remote_data_source.dart';
import 'package:ventura/core/data/models/user_model.dart';

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final Dio dio;
  final routes = ServerRoutes.instance;
  final logger = AppLogger('UserRemoteDataSourceImpl');

  UserRemoteDataSourceImpl({required this.dio});

  @override
  Future<UserModel?> getUser({required String userId}) async {
    try {
      final response = await dio.get(
        '${routes.serverUrl}${routes.getUserById(userId)}',
      );
      if (response.statusCode != 200) {
        logger.error(response.data.toString());
        return null;
      }
      return UserModel.fromJson(response.data);
    } on DioException catch (error) {
      logger.error(error.response!.data.toString());
      return null;
    }
  }

  @override
  Future<UserModel?> updateUserProfile({
    required String userId,
    required String firstName,
    String? lastName,
    String? avatarUrl,
  }) async {
    try {
      final response = await dio.patch(
        '${routes.serverUrl}${routes.updateUserProfile(userId)}',
        data: {
          'firstName': firstName,
          'lastName': lastName,
          'avatarUrl': avatarUrl,
        },
      );
      if (response.statusCode != 200) {
        logger.error(response.data.toString());
        return null;
      }
      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      logger.error(e.response!.data.toString());
      return null;
    } catch (e) {
      logger.error(e.toString());
      return null;
    }
  }
}
