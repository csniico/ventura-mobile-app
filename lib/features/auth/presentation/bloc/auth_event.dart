part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

final class AppStarted extends AuthEvent {
  AppStarted();
}

class AuthSignUp extends AuthEvent {
  final String email;
  final String password;
  final String firstName;
  final String? lastName;
  final String? avatarUrl;

  AuthSignUp({
    required this.email,
    required this.password,
    required this.firstName,
    this.lastName,
    this.avatarUrl,
  });
}

class AuthSignOut extends AuthEvent {
  AuthSignOut();
}

class AuthSignIn extends AuthEvent {
  final String email;
  final String password;

  AuthSignIn({required this.email, required this.password});
}

class AuthSignInWithGoogle extends AuthEvent {
  final String email;
  final String googleId;
  final String firstName;
  final String? lastName;
  final String? avatarUrl;

  AuthSignInWithGoogle({
    required this.email,
    required this.googleId,
    required this.firstName,
    this.lastName,
    this.avatarUrl,
  });
}

class AuthConfirmVerificationCode extends AuthEvent {
  final String code;
  final String email;
  final String shortToken;

  AuthConfirmVerificationCode({
    required this.code,
    required this.email,
    required this.shortToken,
  });
}

class AuthResendVerificationCode extends AuthEvent {
  final String shortToken;

  AuthResendVerificationCode({required this.shortToken});
}
