part of 'registration_cubit.dart';

sealed class RegistrationState {}

final class RegistrationInitial extends RegistrationState {}

final class RegistrationLoading extends RegistrationState {}

final class RegistrationAwaitingVerification extends RegistrationState {
  final ServerSignUp serverSignUp;

  RegistrationAwaitingVerification(this.serverSignUp);
}

final class RegistrationError extends RegistrationState {
  final String message;

  RegistrationError(this.message);
}
