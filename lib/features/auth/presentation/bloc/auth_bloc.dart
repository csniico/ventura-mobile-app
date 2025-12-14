import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ventura/core/cubit/app_user_cubit/app_user_cubit.dart';
import 'package:ventura/core/use_case/use_case.dart';
import 'package:ventura/features/auth/domain/entities/server_sign_up.dart';
import 'package:ventura/core/entities/user_entity.dart';
import 'package:ventura/features/auth/domain/use_cases/confirm_verification_code.dart';
import 'package:ventura/features/auth/domain/use_cases/get_current_user.dart';
import 'package:ventura/features/auth/domain/use_cases/save_current_user.dart';
import 'package:ventura/features/auth/domain/use_cases/user_sign_in.dart';
import 'package:ventura/features/auth/domain/use_cases/user_sign_in_with_google.dart';
import 'package:ventura/features/auth/domain/use_cases/user_sign_up.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final UserSignIn _userSignIn;
  final GetCurrentUser _getCurrentUser;
  final SaveCurrentUser _saveCurrentUser;
  final UserSignInWithGoogle _userSignInWithGoogle;
  final ConfirmVerificationCode _confirmVerificationCode;
  final AppUserCubit _appUserCubit;

  AuthBloc({
    required UserSignUp userSignUp,
    required UserSignIn userSignIn,
    required GetCurrentUser getCurrentUser,
    required UserSignInWithGoogle userSignInWithGoogle,
    required ConfirmVerificationCode confirmVerificationCode,
    required AppUserCubit appUserCubit,
    required SaveCurrentUser saveCurrentUser,
  }) : _appUserCubit = appUserCubit,
       _userSignIn = userSignIn,
       _userSignUp = userSignUp,
       _getCurrentUser = getCurrentUser,
       _saveCurrentUser = saveCurrentUser,
       _userSignInWithGoogle = userSignInWithGoogle,
       _confirmVerificationCode = confirmVerificationCode,
       super(AuthInitial()) {
    on<AuthEvent>((_, emit) => emit(AuthLoading()));
    on<AuthSignUp>(_onAuthSignUp);
    on<AuthSignIn>(_onAuthSignIn);
    on<AuthSignInWithGoogle>(_onAuthSignInWithGoogle);
    on<AuthConfirmVerificationCode>(_onAuthConfirmVerificationCode);
    on<AppStarted>(_onAppStarted);
  }

  void _onAuthSignUp(AuthSignUp event, Emitter<AuthState> emit) async {
    debugPrint('signup process triggered');
    final res = await _userSignUp(
      UserSignUpParams(
        email: event.email,
        password: event.password,
        firstName: event.firstName,
        lastName: event.lastName,
        avatarUrl: event.avatarUrl,
      ),
    );
    res.fold((failure) => emit(AuthFailure(failure.message)), (user) {
      _saveCurrentUser(SaveCurrentUserParams(user: user.user));
      _appUserCubit.updateUser(user.user);
      emit(AuthSignUpSuccess(user));
    });
  }

  void _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    debugPrint('app started. I can do what I want here.');
    final res = await _getCurrentUser(NoParams());
    res.fold(
      (l) => emit(UnAuthenticated()),
      (user) => emitAuthSuccess(user, emit),
    );
  }

  void _onAuthSignIn(AuthSignIn event, Emitter<AuthState> emit) async {
    final res = await _userSignIn(
      UserSignInParams(email: event.email, password: event.password),
    );
    res.fold(
      (l) => emit(AuthFailure(l.message)),
      (user) => emitAuthSuccess(user, emit),
    );
  }

  void _onAuthSignInWithGoogle(
    AuthSignInWithGoogle event,
    Emitter<AuthState> emit,
  ) async {
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
      (l) => emit(AuthFailure(l.message)),
      (user) => emitAuthSuccess(user, emit),
    );
  }

  void _onAuthConfirmVerificationCode(
    AuthConfirmVerificationCode event,
    Emitter<AuthState> emit,
  ) async {
    final res = await _confirmVerificationCode(
      ConfirmVerificationCodeParams(
        code: event.code,
        email: event.email,
        shortToken: event.shortToken,
      ),
    );
    res.fold(
      (l) => emit(AuthFailure(l.message)),
      (user) => emitAuthSuccess(user, emit),
    );
  }

  void emitAuthSuccess(User user, Emitter<AuthState> emit) {
    _saveCurrentUser(SaveCurrentUserParams(user: user));
    _appUserCubit.updateUser(user);
    emit(AuthSuccess(user));
  }
}
