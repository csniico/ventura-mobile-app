import 'package:fpdart/fpdart.dart';
import 'package:ventura/core/data/models/failure.dart';
import 'package:ventura/core/domain/use_cases/use_case.dart';
import 'package:ventura/core/domain/entities/user_entity.dart';
import 'package:ventura/features/auth/domain/repositories/auth_repository.dart';

class ConfirmVerificationCode
    implements UseCase<User, ConfirmVerificationCodeParams> {
  final AuthRepository authRepository;

  ConfirmVerificationCode({required this.authRepository});

  @override
  Future<Either<Failure, User>> call(
    ConfirmVerificationCodeParams params,
  ) async {
    return await authRepository.confirmVerificationCode(
      code: params.code,
      email: params.email,
      shortToken: params.shortToken,
    );
  }
}

class ConfirmVerificationCodeParams {
  final String code;
  final String email;
  final String shortToken;

  ConfirmVerificationCodeParams({
    required this.code,
    required this.email,
    required this.shortToken,
  });
}
