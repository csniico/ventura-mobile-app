import 'package:fpdart/fpdart.dart';
import 'package:ventura/core/data/models/failure.dart';
import 'package:ventura/core/domain/entities/user_entity.dart';

abstract interface class UserRepository {
  Future<Either<Failure, User>> localSaveUser({required User user});

  Future<Either<Failure, User>> localGetUser();

  Future<Either<Failure, User>> remoteGetUser({required String userId});

  Future<Either<Failure, User>> updateUserProfile({
    required String userId,
    required String firstName,
    String? lastName,
    String? avatarUrl,
  });

  Future<void> localSignOut();
}
