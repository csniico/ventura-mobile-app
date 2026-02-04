import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ventura/config/app_logger.dart';
import 'package:ventura/core/domain/entities/user_entity.dart';
import 'package:ventura/features/auth/domain/use_cases/confirm_email.dart';
import 'package:ventura/features/auth/domain/use_cases/confirm_verification_code.dart';
import 'package:ventura/features/auth/domain/use_cases/reset_password.dart';

part 'password_recovery_state.dart';

class PasswordRecoveryCubit extends Cubit<PasswordRecoveryState> {
  final logger = AppLogger('PasswordRecoveryCubit');
  final ConfirmEmail _confirmEmail;
  final ConfirmVerificationCode _confirmVerificationCode;
  final ResetPassword _resetPassword;

  PasswordRecoveryCubit({
    required ConfirmEmail confirmEmail,
    required ConfirmVerificationCode confirmVerificationCode,
    required ResetPassword resetPassword,
  }) : _confirmEmail = confirmEmail,
       _confirmVerificationCode = confirmVerificationCode,
       _resetPassword = resetPassword,
       super(PasswordRecoveryInitial());

  Future<void> sendResetCode({required String email}) async {
    emit(PasswordRecoverySending());

    final result = await _confirmEmail(ConfirmEmailParams(email: email));

    result.fold(
      (failure) => emit(PasswordRecoveryError(failure.message)),
      (response) => emit(
        PasswordRecoveryCodeSent(
          email: email,
          shortToken: response.shortToken,
          message: response.message,
        ),
      ),
    );
  }

  Future<void> verifyResetCode({
    required String code,
    required String email,
    required String shortToken,
  }) async {
    emit(PasswordRecoveryVerifying());

    final result = await _confirmVerificationCode(
      ConfirmVerificationCodeParams(
        code: code,
        email: email,
        shortToken: shortToken,
      ),
    );

    result.fold(
      (failure) => emit(PasswordRecoveryError(failure.message)),
      (user) =>
          emit(PasswordRecoveryCodeVerified(email: email, userId: user.id)),
    );
  }

  Future<void> resetPassword({
    required String userId,
    required String newPassword,
  }) async {
    emit(PasswordRecoveryResetting());

    final result = await _resetPassword(
      ResetPasswordParams(userId: userId, newPassword: newPassword),
    );

    result.fold(
      (failure) => emit(PasswordRecoveryError(failure.message)),
      (user) => emit(PasswordRecoverySuccess(user)),
    );
  }

  void reset() {
    emit(PasswordRecoveryInitial());
  }
}
