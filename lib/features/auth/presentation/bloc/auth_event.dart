part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

/// Triggered when app starts - checks for existing session
final class AppStarted extends AuthEvent {}

/// Triggered when user signs out
final class AuthSignOut extends AuthEvent {}

/// Triggered by feature cubits when authentication is successful
/// Updates the session with the authenticated user
final class AuthSessionUpdated extends AuthEvent {
  final User user;

  AuthSessionUpdated(this.user);
}

/// Triggered when business profile is created
/// Updates the user's business information in the session
final class BusinessProfileCreated extends AuthEvent {
  final User user;
  final Business business;

  BusinessProfileCreated({required this.user, required this.business});
}
