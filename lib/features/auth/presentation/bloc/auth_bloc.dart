import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ventura/config/app_logger.dart';
import 'package:ventura/core/domain/entities/business_entity.dart';
import 'package:ventura/core/domain/use_cases/local_get_user.dart';
import 'package:ventura/core/domain/use_cases/local_save_user.dart';
import 'package:ventura/core/domain/use_cases/local_sign_out.dart';
import 'package:ventura/core/domain/use_cases/remote_get_user.dart';
import 'package:ventura/core/presentation/cubit/app_user_cubit/app_user_cubit.dart';
import 'package:ventura/core/domain/use_cases/use_case.dart';
import 'package:ventura/core/services/internet_service.dart';
import 'package:ventura/features/auth/domain/entities/server_sign_up.dart';
import 'package:ventura/core/domain/entities/user_entity.dart';
import 'package:ventura/features/auth/domain/use_cases/confirm_email.dart';
import 'package:ventura/features/auth/domain/use_cases/confirm_verification_code.dart';
import 'package:ventura/features/auth/domain/use_cases/reset_password.dart';
import 'package:ventura/features/auth/domain/use_cases/user_sign_in.dart';
import 'package:ventura/features/auth/domain/use_cases/user_sign_in_with_google.dart';
import 'package:ventura/features/auth/domain/use_cases/user_sign_up.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final logger = AppLogger('AuthBloc');
  final UserSignUp _userSignUp;
  final UserSignIn _userSignIn;
  final LocalGetUser _localGetUser;
  final LocalSaveUser _localSaveUser;
  final LocalSignOut _localSignOut;
  final RemoteGetUser _remoteGetUser;
  final ConfirmEmail _confirmEmail;
  final UserSignInWithGoogle _userSignInWithGoogle;
  final ConfirmVerificationCode _confirmVerificationCode;
  final ResetPassword _resetPassword;
  final AppUserCubit _appUserCubit;

  AuthBloc({
    required UserSignUp userSignUp,
    required UserSignIn userSignIn,
    required LocalGetUser localGetUser,
    required LocalSaveUser localSaveUser,
    required LocalSignOut localSignOut,
    required ConfirmEmail confirmEmail,
    required UserSignInWithGoogle userSignInWithGoogle,
    required ConfirmVerificationCode confirmVerificationCode,
    required ResetPassword resetPassword,
    required AppUserCubit appUserCubit,
    required RemoteGetUser remoteGetUser,
  }) : _appUserCubit = appUserCubit,
       _userSignIn = userSignIn,
       _userSignUp = userSignUp,
       _localGetUser = localGetUser,
       _localSaveUser = localSaveUser,
       _localSignOut = localSignOut,
       _confirmEmail = confirmEmail,
       _userSignInWithGoogle = userSignInWithGoogle,
       _confirmVerificationCode = confirmVerificationCode,
       _resetPassword = resetPassword,
       _remoteGetUser = remoteGetUser,
       super(AuthInitial()) {
    on<AuthResetState>((event, emit) => emit(AuthInitial()));
    on<AuthEvent>((_, emit) => emit(AuthLoading()));
    on<AppStarted>(_onAppStarted);
    on<AuthSignUp>(_onAuthSignUp);
    on<AuthSignIn>(_onAuthSignIn);
    on<AuthSignOut>(_onAuthSignOut);
    on<AuthSignInWithGoogle>(_onAuthSignInWithGoogle);
    on<AuthConfirmVerificationCode>(_onAuthConfirmVerificationCode);
    on<AuthVerifyEmail>(_onAuthVerifyEmail);
    on<AuthResetPasswordConfirmVerificationCode>(
      _onAuthResetPasswordConfirmVerificationCode,
    );
    on<AuthResetPassword>(_onAuthResetPassword);
    on<AuthForgotPassword>(_onForgotPassword);
    on<UserProfileCreateSuccess>(_onUserProfileCreateSuccess);
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
    logger.info('app started.');
    final res = await _localGetUser(NoParams());

    final user = res.fold((l) => null, (user) => user);

    if (user == null) {
      logger.info('user not found in local storage.');
      emit(UnAuthenticated());
      return;
    }

    final bool connected = await InternetService().isUserConnected();
    if (!connected) {
      logger.info('user not connected to the internet, return local user');
      emitAuthSuccess(user, emit);
      return;
    }

    logger.info('user found in local storage, fetching from remote.');
    final remoteRes = await _remoteGetUser(
      RemoteGetUserParams(userId: user.id),
    );

    remoteRes.fold(
      (l) => emit(AuthFailure(l.message)),
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

  void _onForgotPassword(
    AuthForgotPassword event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthUserForgotPassword());
  }

  void _onAuthVerifyEmail(
    AuthVerifyEmail event,
    Emitter<AuthState> emit,
  ) async {
    final res = await _confirmEmail(ConfirmEmailParams(email: event.email));
    res.fold(
      (failure) {
        logger.error(failure.message);
        emit(AuthFailure(failure.message));
      },
      (success) => emit(
        AuthEmailIsVerified(
          email: event.email,
          message: success.message,
          shortToken: success.shortToken,
        ),
      ),
    );
  }

  void _onAuthResetPasswordConfirmVerificationCode(
    AuthResetPasswordConfirmVerificationCode event,
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
      (failure) => emit(AuthFailure(failure.message)),
      (user) => emit(VerificationCodeConfirmed(user)),
    );
  }

  void _onAuthResetPassword(
    AuthResetPassword event,
    Emitter<AuthState> emit,
  ) async {
    final res = await _resetPassword(
      ResetPasswordParams(userId: event.userId, newPassword: event.newPassword),
    );
    res.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => emitAuthSuccess(user, emit),
    );
  }

  void _onUserProfileCreateSuccess(
    UserProfileCreateSuccess event,
    Emitter<AuthState> emit,
  ) {
    emitAuthSuccess(event.user, emit);
  }

  void emitAuthSuccess(User user, Emitter<AuthState> emit) {
    _localSaveUser(UserParams(user: user));
    _appUserCubit.updateUser(user);
    if (!user.isEmailVerified) {
      logger.error('Email is not verified for user ${user.email}');
      return emit(
        AuthSignUpSuccess(ServerSignUp(user: user, shortToken: 'login')),
      );
    }
    if (user.businessId.isEmpty) {
      logger.error('Business is not registered for user ${user.email}');
      return emit(AuthBusinessNotRegistered(user: user));
    }

    emit(AuthSuccess(user));
  }
}
