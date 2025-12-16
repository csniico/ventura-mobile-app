import 'package:fpdart/fpdart.dart';
import 'package:ventura/core/data/models/failure.dart';
import 'package:ventura/core/domain/entities/user_entity.dart';

abstract interface class UserRepository {
  Future<Either<Failure, User>> localSaveUser({required User user});
  Future<Either<Failure, User>> localGetUser();
  Future<void> localSignOut();

}