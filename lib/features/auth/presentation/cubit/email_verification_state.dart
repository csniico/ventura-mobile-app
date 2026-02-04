part of 'email_verification_cubit.dart';

sealed class EmailVerificationState {}

final class EmailVerificationInitial extends EmailVerificationState {}

final class EmailVerificationSending extends EmailVerificationState {}

final class EmailVerificationCodeSent extends EmailVerificationState {
  final String email;
  final String shortToken;
  final String message;

  EmailVerificationCodeSent({
    required this.email,
    required this.shortToken,
    required this.message,
  });
}

final class EmailVerificationCodeResent extends EmailVerificationState {
  final String email;
  final String shortToken;
  final String message;

  EmailVerificationCodeResent({
    required this.email,
    required this.shortToken,
    required this.message,
  });
}

final class EmailVerificationVerifying extends EmailVerificationState {}

final class EmailVerificationVerified extends EmailVerificationState {
  final User user;

  EmailVerificationVerified(this.user);
}

final class EmailVerificationError extends EmailVerificationState {
  final String message;

  EmailVerificationError(this.message);
}
