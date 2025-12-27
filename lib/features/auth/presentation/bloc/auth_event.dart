part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

final class AuthResetState extends AuthEvent {
  AuthResetState();
}

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

class AuthForgotPassword extends AuthEvent {}

class AuthResetPasswordConfirmVerificationCode extends AuthEvent {
  final String code;
  final String email;
  final String shortToken;

  AuthResetPasswordConfirmVerificationCode({
    required this.code,
    required this.email,
    required this.shortToken,
  });
}

class AuthResendVerificationCode extends AuthEvent {
  final String shortToken;

  AuthResendVerificationCode({required this.shortToken});
}

class AuthVerifyEmail extends AuthEvent {
  final String email;

  AuthVerifyEmail({required this.email});
}

class AuthResetPassword extends AuthEvent {
  final String? email;
  final String newPassword;
  final String userId;

  AuthResetPassword({
    this.email,
    required this.newPassword,
    required this.userId,
  });
}

class UserAvatarProfileChanged extends AuthEvent {
  final File? file;
  final User user;

  UserAvatarProfileChanged({required this.file, required this.user});
}

class UserFirstNameChanged extends AuthEvent {
  final String firstName;
  final User user;

  UserFirstNameChanged({required this.firstName, required this.user});
}

class UserLastNameChanged extends AuthEvent {
  final String lastName;
  final User user;

  UserLastNameChanged({required this.lastName, required this.user});
}

class UserProfileCreateSuccess extends AuthEvent {
  final User user;
  final Business business;

  UserProfileCreateSuccess({required this.user, required this.business});
}

class EditUserProfileEvent extends AuthEvent {
  final User user;
  final String userId;
  final String firstName;
  final String? lastName;
  final String? avatarUrl;

  EditUserProfileEvent({
    required this.user,
    required this.userId,
    required this.firstName,
    this.lastName,
    this.avatarUrl,
  });
}

class UserProfileUpdated extends AuthEvent {
  final User user;

  UserProfileUpdated({required this.user});
}
