part of 'password_recovery_cubit.dart';

sealed class PasswordRecoveryState {}

final class PasswordRecoveryInitial extends PasswordRecoveryState {}

final class PasswordRecoverySending extends PasswordRecoveryState {}

final class PasswordRecoveryCodeSent extends PasswordRecoveryState {
  final String email;
  final String shortToken;
  final String message;

  PasswordRecoveryCodeSent({
    required this.email,
    required this.shortToken,
    required this.message,
  });
}

final class PasswordRecoveryVerifying extends PasswordRecoveryState {}

final class PasswordRecoveryCodeVerified extends PasswordRecoveryState {
  final String email;
  final String userId;

  PasswordRecoveryCodeVerified({required this.email, required this.userId});
}

final class PasswordRecoveryResetting extends PasswordRecoveryState {}

final class PasswordRecoverySuccess extends PasswordRecoveryState {
  final User user;

  PasswordRecoverySuccess(this.user);
}

final class PasswordRecoveryError extends PasswordRecoveryState {
  final String message;

  PasswordRecoveryError(this.message);
}
