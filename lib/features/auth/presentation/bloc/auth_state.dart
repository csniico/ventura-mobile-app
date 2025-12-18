part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthSuccess extends AuthState {
  final User user;

  AuthSuccess(this.user);
}

final class AuthSignUpSuccess extends AuthState {
  final ServerSignUp user;

  AuthSignUpSuccess(this.user);
}

final class AuthFailure extends AuthState {
  final String message;

  AuthFailure(this.message);
}

final class Authenticated extends AuthState {
  final User user;

  Authenticated(this.user);
}

final class UnAuthenticated extends AuthState {}

final class AuthUserForgotPassword extends AuthState {}

final class VerificationCodeConfirmed extends AuthState {
  final User user;

  VerificationCodeConfirmed(this.user);
}

final class EmailVerificationCodeSendSuccessful extends AuthState {
  final String message;

  EmailVerificationCodeSendSuccessful(this.message);
}

final class VerificationCodeResendSuccessful extends AuthState {
  final String message;

  VerificationCodeResendSuccessful(this.message);
}

class AuthEmailIsVerified extends AuthState {
  final String message;
  final String email;
  final String shortToken;

  AuthEmailIsVerified({
    required this.message,
    required this.shortToken,
    required this.email,
  });
}

class PasswordResetSuccessful extends AuthState {
  final User user;

  PasswordResetSuccessful({required this.user});
}

class AuthBusinessNotRegistered extends AuthState {
  final String userId;
  final String firstName;

  AuthBusinessNotRegistered({required this.userId, required this.firstName});
}
