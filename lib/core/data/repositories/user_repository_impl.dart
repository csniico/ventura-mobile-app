import 'package:flutter/cupertino.dart';
import 'package:fpdart/fpdart.dart';
import 'package:ventura/core/data/datasources/local/user_local_data_source.dart';
import 'package:ventura/core/data/models/failure.dart';
import 'package:ventura/core/data/models/user_model.dart';
import 'package:ventura/core/domain/entities/user_entity.dart';
import 'package:ventura/core/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserLocalDataSource userLocalDataSource;

  UserRepositoryImpl({required this.userLocalDataSource});

  /// the call to the data source will return a user model
  /// call the .toEntity to convert from model to entity
  @override
  Future<Either<Failure, User>> localGetUser() async {
    try {
      final res = await userLocalDataSource.getUser();
      debugPrint('Local user data retrieved: $res');
      if (res == null) {
        return left(Failure('No user found.'));
      }
      final user = res.toEntity();
      return right(user);
    } catch (error) {
      debugPrint('An error occurred in the repository layer ${error.toString()}');
      return left(Failure('An error occurred retrieving local user data'));
    }
  }

  /// Take user entity, convert to model
  /// the call will return a user model
  /// call the toEntity factory to convert model to entity
  /// return the entity
  @override
  Future<Either<Failure, User>> localSaveUser({required User user}) async {
    try {
      final res = await userLocalDataSource.saveUser(
        UserModel.fromEntity(user),
      );
      return right(res.toEntity());
    } catch (error) {
      debugPrint(error.toString());
      return left(Failure('Failed to save user locally'));
    }
  }

  @override
  Future<void> localSignOut() async {
    return await userLocalDataSource.signOut();
  }
}
