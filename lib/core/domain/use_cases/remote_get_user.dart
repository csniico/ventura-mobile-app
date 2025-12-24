import 'package:fpdart/fpdart.dart';
import 'package:ventura/core/data/models/failure.dart';
import 'package:ventura/core/domain/entities/user_entity.dart';
import 'package:ventura/core/domain/repositories/user_repository.dart';
import 'package:ventura/core/domain/use_cases/use_case.dart';

class RemoteGetUser implements UseCase<User, RemoteGetUserParams> {
  final UserRepository userRepository;

  RemoteGetUser({required this.userRepository});

  @override
  Future<Either<Failure, User>> call(RemoteGetUserParams params) async {
    return await userRepository.remoteGetUser(userId: params.userId);
  }
}

class RemoteGetUserParams {
  final String userId;

  RemoteGetUserParams({required this.userId});
}
