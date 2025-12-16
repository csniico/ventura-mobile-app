import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ventura/core/domain/use_cases/local_get_user.dart';
import 'package:ventura/core/domain/use_cases/local_save_user.dart';
import 'package:ventura/core/domain/use_cases/local_sign_out.dart';
import 'package:ventura/core/presentation/cubit/app_user_cubit/app_user_cubit.dart';
import 'package:ventura/core/domain/use_cases/use_case.dart';
import 'package:ventura/features/auth/domain/entities/server_sign_up.dart';
import 'package:ventura/core/domain/entities/user_entity.dart';
import 'package:ventura/features/auth/domain/use_cases/confirm_verification_code.dart';
import 'package:ventura/features/auth/domain/use_cases/user_sign_in.dart';
import 'package:ventura/features/auth/domain/use_cases/user_sign_in_with_google.dart';
import 'package:ventura/features/auth/domain/use_cases/user_sign_up.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final UserSignIn _userSignIn;
  final LocalGetUser _localGetUser;
  final LocalSaveUser _localSaveUser;
  final LocalSignOut _localSignOut;

  final UserSignInWithGoogle _userSignInWithGoogle;
  final ConfirmVerificationCode _confirmVerificationCode;
  final AppUserCubit _appUserCubit;

  AuthBloc({
    required UserSignUp userSignUp,
    required UserSignIn userSignIn,
    required LocalGetUser localGetUser,
    required LocalSaveUser localSaveUser,
    required LocalSignOut localSignOut,
    required UserSignInWithGoogle userSignInWithGoogle,
    required ConfirmVerificationCode confirmVerificationCode,
    required AppUserCubit appUserCubit,
  })
      : _appUserCubit = appUserCubit,
        _userSignIn = userSignIn,
        _userSignUp = userSignUp,
        _localGetUser = localGetUser,
        _localSaveUser = localSaveUser,
        _localSignOut = localSignOut,
        _userSignInWithGoogle = userSignInWithGoogle,
        _confirmVerificationCode = confirmVerificationCode,
        super(AuthInitial()) {
    on<AuthEvent>((_, emit) => emit(AuthLoading()));
    on<AppStarted>(_onAppStarted);
    on<AuthSignUp>(_onAuthSignUp);
    on<AuthSignIn>(_onAuthSignIn);
    on<AuthSignOut>(_onAuthSignOut);
    on<AuthSignInWithGoogle>(_onAuthSignInWithGoogle);
    on<AuthConfirmVerificationCode>(_onAuthConfirmVerificationCode);
  }

  void _onAuthSignOut(AuthEvent event, Emitter<AuthState> emit) async {
    await _localSignOut(NoParams());
    _appUserCubit.clearUser();
    emit(UnAuthenticated());
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
      _localSaveUser(UserParams(user: user.user));
      _appUserCubit.updateUser(user.user);
      emit(AuthSignUpSuccess(user));
    });
  }

  void _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    debugPrint('app started. I can do what I want here.');
    final res = await _localGetUser(NoParams());
    res.fold(
          (l) => emit(UnAuthenticated()),
          (user) =>
      user == null ? emit(UnAuthenticated()) : emitAuthSuccess(user, emit),
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

  void _onAuthSignInWithGoogle(AuthSignInWithGoogle event,
      Emitter<AuthState> emit,) async {
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

  void _onAuthConfirmVerificationCode(AuthConfirmVerificationCode event,
      Emitter<AuthState> emit,) async {
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
    _localSaveUser(UserParams(user: user));
    _appUserCubit.updateUser(user);
    emit(AuthSuccess(user));
  }
}
