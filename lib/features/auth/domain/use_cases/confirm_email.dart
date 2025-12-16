import 'package:fpdart/fpdart.dart';
import 'package:ventura/core/data/models/failure.dart';
import 'package:ventura/core/domain/use_cases/use_case.dart';
import 'package:ventura/features/auth/data/models/confirm_email_model.dart';
import 'package:ventura/features/auth/domain/repositories/auth_repository.dart';

class ConfirmEmail implements UseCase<ConfirmEmailModel, ConfirmEmailParams> {
  final AuthRepository authRepository;

  ConfirmEmail({required this.authRepository});

  @override
  Future<Either<Failure, ConfirmEmailModel>> call(
    ConfirmEmailParams params,
  ) async {
    return await authRepository.confirmEmailForPasswordReset(
      email: params.email,
    );
  }
}

class ConfirmEmailParams {
  final String email;

  ConfirmEmailParams({required this.email});
}
