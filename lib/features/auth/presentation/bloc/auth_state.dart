part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class Authenticating extends AuthState {}

final class Authenticated extends AuthState {
  final User user;

  Authenticated(this.user);
}

final class SignupAwaitingEmailVerification extends AuthState {
  final ServerSignUp user;

  SignupAwaitingEmailVerification(this.user);
}

final class AuthFailure extends AuthState {
  final String message;

  AuthFailure(this.message);
}

final class UnAuthenticated extends AuthState {}

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
  final User user;

  AuthBusinessNotRegistered({required this.user});
}

class UserProfileUpdateSuccess extends AuthState {
  final User user;

  UserProfileUpdateSuccess({required this.user});
}

class UserProfileUpdateFail extends AuthState {
  final String message;

  UserProfileUpdateFail({required this.message});
}

class UserProfileImageUploadSuccess extends AuthState {
  final String? imageUrl;
  final String? errorMessage;

  UserProfileImageUploadSuccess({required this.imageUrl, this.errorMessage});
}
