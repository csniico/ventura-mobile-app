part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthSuccess extends AuthState {
  final String message;

  AuthSuccess({required this.message});
}

final class AuthFailure extends AuthState {
  final String message;

  AuthFailure({required this.message});
}

final class Authenticated extends AuthState {}

final class UnAuthenticated extends AuthState {}
