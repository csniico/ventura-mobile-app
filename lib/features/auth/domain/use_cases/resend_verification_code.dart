import 'package:fpdart/fpdart.dart';
import 'package:ventura/core/data/models/failure.dart';
import 'package:ventura/core/domain/use_cases/use_case.dart';
import 'package:ventura/features/auth/domain/repositories/auth_repository.dart';

class ResendVerificationCode
    implements UseCase<void, ResendVerificationCodeParams> {
  final AuthRepository authRepository;

  ResendVerificationCode({required this.authRepository});

  @override
  Future<Either<Failure, void>> call(
    ResendVerificationCodeParams params,
  ) async {
    return await authRepository.resendVerificationCode(userId: params.userId);
  }
}

class ResendVerificationCodeParams {
  final String userId;

  ResendVerificationCodeParams({required this.userId});
}
