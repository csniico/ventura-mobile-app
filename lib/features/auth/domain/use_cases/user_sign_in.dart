import 'package:fpdart/fpdart.dart';
import 'package:ventura/core/models/failure/failure.dart';
import 'package:ventura/core/use_case/use_case.dart';
import 'package:ventura/features/auth/domain/repositories/auth_repository.dart';

class UserSignIn implements UseCase<String, UserSignInParams> {
  final AuthRepository authRepository;

  UserSignIn({required this.authRepository});

  @override
  Future<Either<Failure, String>> call(UserSignInParams params) async {
    return await authRepository.signInWithEmailPassword(
      email: params.email,
      password: params.password,
    );
  }
}

class UserSignInParams {
  final String email;
  final String password;

  UserSignInParams({required this.email, required this.password});
}
