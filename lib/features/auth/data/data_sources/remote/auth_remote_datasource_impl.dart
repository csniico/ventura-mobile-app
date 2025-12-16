import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ventura/core/data/models/server_exception.dart';
import 'package:ventura/core/data/datasources/remote/server_routes.dart';
import 'package:ventura/features/auth/data/data_sources/remote/auth_remote_data_source.dart';
import 'package:ventura/features/auth/data/models/server_sign_up_model.dart';
import 'package:ventura/core/data/models/user_model.dart';

class AuthRemoteDatasourceImpl implements AuthRemoteDataSource {
  Dio dio = Dio();
  final routes = ServerRoutes.instance;

  @override
  Future<UserModel> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      var response = await dio.post(
        '${routes.serverUrl}${routes.signInWithEmailPassword}',
        data: {'email': email, 'password': password},
      );
      debugPrint(response.toString());
      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      debugPrint(e.message);
      throw ServerException.fromDioError(e);
    }
  }

  @override
  Future<UserModel> signInWithGoogle({
    required String googleId,
    required String email,
    required String firstName,
    String? lastName,
    String? avatarUrl,
  }) async {
    try {
      var response = await dio.post(
        '${routes.serverUrl}${routes.signInWithGoogle}',
        data: {
          'googleId': googleId,
          'email': email,
          'firstName': firstName,
          'lastName': lastName,
          'avatarUrl': avatarUrl,
        },
      );
      debugPrint(response.toString());
      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ServerException.fromDioError(e);
    }
  }

  @override
  Future<ServerSignUpModel> signUp({
    required String email,
    required String firstName,
    required String password,
    String? lastName,
    String? avatarUrl,
  }) async {
    try {
      var response = await dio.post(
        '${routes.serverUrl}${routes.signUp}',
        data: {
          'email': email,
          'firstName': firstName,
          'lastName': lastName,
          'password': password,
          'avatarUrl': avatarUrl,
        },
      );
      debugPrint(response.toString());
      return ServerSignUpModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ServerException.fromDioError(e);
    }
  }

  @override
  Future<UserModel> confirmVerificationCode({
    required String code,
    required String email,
    required String shortToken,
  }) async {
    try {
      var response = await dio.post(
        '${routes.serverUrl}${routes.confirmVerificationCode}',
        data: {'code': code, 'email': email, 'shortToken': shortToken},
      );
      debugPrint(response.toString());
      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ServerException.fromDioError(e);
    }
  }

  @override
  Future<void> signOut() {
    // TODO: implement signOut
    throw UnimplementedError();
  }
}
