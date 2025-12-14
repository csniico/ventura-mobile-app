import 'package:fpdart/fpdart.dart';
import 'package:ventura/core/entities/user_entity.dart';
import 'package:ventura/core/models/failure.dart';
import 'package:ventura/core/use_case/use_case.dart';
import 'package:ventura/features/auth/domain/repositories/auth_repository.dart';

class SaveCurrentUser implements UseCase<User, SaveCurrentUserParams> {
  final AuthRepository authRepository;

  SaveCurrentUser({required this.authRepository});

  @override
  Future<Either<Failure, User>> call(SaveCurrentUserParams params) async {
    return await authRepository.saveUser(user: params.user);
  }
}

class SaveCurrentUserParams {
  final User user;

  SaveCurrentUserParams({required this.user});
}
