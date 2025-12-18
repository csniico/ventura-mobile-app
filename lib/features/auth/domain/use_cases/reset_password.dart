import 'package:fpdart/fpdart.dart';
import 'package:ventura/core/data/models/failure.dart';
import 'package:ventura/core/domain/entities/user_entity.dart';
import 'package:ventura/core/domain/use_cases/use_case.dart';
import 'package:ventura/features/auth/domain/repositories/auth_repository.dart';

class ResetPassword implements UseCase<User, ResetPasswordParams> {
  final AuthRepository authRepository;

  ResetPassword({required this.authRepository});

  @override
  Future<Either<Failure, User>> call(ResetPasswordParams params) async {
    return await authRepository.resetPassword(
      newPassword: params.newPassword,
      userId: params.userId,
    );
  }
}

class ResetPasswordParams {
  final String newPassword;
  final String userId;

  ResetPasswordParams({required this.userId, required this.newPassword});
}
