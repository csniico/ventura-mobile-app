part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

/// User is not authenticated - no valid session
final class Unauthenticated extends AuthState {}

/// User is authenticated with a complete profile
final class Authenticated extends AuthState {
  final User user;

  Authenticated(this.user);
}

/// User is authenticated but email is not verified
/// Should redirect to email verification page
final class AuthenticatedButEmailUnverified extends AuthState {
  final User user;

  AuthenticatedButEmailUnverified(this.user);
}

/// User is authenticated but has no business profile
/// Should redirect to business creation page
final class AuthenticatedButNoBusinessProfile extends AuthState {
  final User user;

  AuthenticatedButNoBusinessProfile(this.user);
}
