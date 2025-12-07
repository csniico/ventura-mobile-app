import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ventura/features/auth/domain/use_cases/get_current_user.dart';
import 'package:ventura/features/auth/domain/use_cases/user_sign_in.dart';
import 'package:ventura/features/auth/domain/use_cases/user_sign_in_with_google.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignIn _userSignIn;
  final GetCurrentUser _getCurrentUser;
  final UserSignInWithGoogle _userSignInWithGoogle;

  AuthBloc({
    required UserSignIn userSignIn,
    required GetCurrentUser getCurrentUser,
    required UserSignInWithGoogle userSignInWithGoogle,
  }) : _userSignIn = userSignIn,
       _getCurrentUser = getCurrentUser,
       _userSignInWithGoogle = userSignInWithGoogle,
       super(AuthInitial()) {
    on<AuthSignIn>((event, emit) async {
      final res = await _userSignIn(
        UserSignInParams(email: event.email, password: event.password),
      );
      res.fold(
        (l) => emit(AuthFailure(message: l.message)),
        (r) => emit(AuthSuccess(message: r)),
      );
    });

    on<AuthSignInWithGoogle>((event, emit) async {
      final res = await _userSignInWithGoogle(
        UserSignInWithGoogleParams(
          email: event.email,
          googleId: event.googleId,
          firstName: event.firstName,
          lastName: event.lastName,
          avatarUrl: event.avatarUrl,
        ),
      );
      res.fold(
        (l) => emit(AuthFailure(message: l.message)),
        (r) => emit(AuthSuccess(message: r)),
      );
    });

    on<AppStarted>((event, emit) async {
      emit(AuthLoading());
      final res = await _getCurrentUser(GetCurrentUserParams(uid: "uid"));
      res.fold((l) => emit(UnAuthenticated()), (r) => emit(Authenticated()));
    });
  }
}
