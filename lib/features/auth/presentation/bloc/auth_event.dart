part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

final class AppStarted extends AuthEvent {
  AppStarted();
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
