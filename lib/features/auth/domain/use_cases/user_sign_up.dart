import 'package:fpdart/fpdart.dart';
import 'package:ventura/core/models/failure.dart';
import 'package:ventura/core/use_case/use_case.dart';
import 'package:ventura/features/auth/domain/entities/server_sign_up.dart';
import 'package:ventura/core/entities/user_entity.dart';
import 'package:ventura/features/auth/domain/repositories/auth_repository.dart';

class UserSignUp implements UseCase<ServerSignUp, UserSignUpParams> {
  final AuthRepository authRepository;

  UserSignUp({required this.authRepository});

  @override
  Future<Either<Failure, ServerSignUp>> call(UserSignUpParams params) async {
    return await authRepository.signUp(
      email: params.email,
      password: params.password,
      firstName: params.firstName,
      avatarUrl: params.avatarUrl,
      lastName: params.lastName,
    );
  }
}

class UserSignUpParams {
  final String email;
  final String password;
  final String firstName;
  final String? lastName;
  final String? avatarUrl;

  UserSignUpParams({
    required this.email,
    required this.password,
    required this.firstName,
    this.lastName,
    this.avatarUrl,
  });
}
