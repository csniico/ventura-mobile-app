import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ventura/config/app_logger.dart';
import 'package:ventura/core/domain/entities/user_entity.dart';
import 'package:ventura/features/auth/domain/use_cases/confirm_email.dart';
import 'package:ventura/features/auth/domain/use_cases/confirm_verification_code.dart';

part 'email_verification_state.dart';

class EmailVerificationCubit extends Cubit<EmailVerificationState> {
  final logger = AppLogger('EmailVerificationCubit');
  final ConfirmEmail _confirmEmail;
  final ConfirmVerificationCode _confirmVerificationCode;

  EmailVerificationCubit({
    required ConfirmEmail confirmEmail,
    required ConfirmVerificationCode confirmVerificationCode,
  }) : _confirmEmail = confirmEmail,
       _confirmVerificationCode = confirmVerificationCode,
       super(EmailVerificationInitial());

  Future<void> sendVerificationCode({required String email}) async {
    emit(EmailVerificationSending());

    final result = await _confirmEmail(ConfirmEmailParams(email: email));

    result.fold(
      (failure) => emit(EmailVerificationError(failure.message)),
      (response) => emit(
        EmailVerificationCodeSent(
          email: email,
          shortToken: response.shortToken,
          message: response.message,
        ),
      ),
    );
  }

  Future<void> verifyCode({
    required String code,
    required String email,
    required String shortToken,
  }) async {
    emit(EmailVerificationVerifying());

    final result = await _confirmVerificationCode(
      ConfirmVerificationCodeParams(
        code: code,
        email: email,
        shortToken: shortToken,
      ),
    );

    result.fold(
      (failure) => emit(EmailVerificationError(failure.message)),
      (user) => emit(EmailVerificationVerified(user)),
    );
  }

  Future<void> resendCode({required String email}) async {
    emit(EmailVerificationSending());

    final result = await _confirmEmail(ConfirmEmailParams(email: email));

    result.fold(
      (failure) => emit(EmailVerificationError(failure.message)),
      (response) => emit(
        EmailVerificationCodeResent(
          email: email,
          shortToken: response.shortToken,
          message: response.message,
        ),
      ),
    );
  }

  void reset() {
    emit(EmailVerificationInitial());
  }
}
