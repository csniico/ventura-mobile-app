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
import 'package:ventura/core/domain/entities/user_entity.dart';

part 'auth_event.dart';
part 'auth_state.dart';

/// AuthBloc - Manages authentication session state only
/// Responsibilities:
/// - Check if user has valid session on app start
/// - Update session when other features authenticate
/// - Handle sign out
/// - Persist user data locally
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final logger = AppLogger('AuthBloc');
  final LocalGetUser _localGetUser;
  final LocalSaveUser _localSaveUser;
  final LocalSignOut _localSignOut;
  final RemoteGetUser _remoteGetUser;
  final AppUserCubit _appUserCubit;

  AuthBloc({
    required LocalGetUser localGetUser,
    required LocalSaveUser localSaveUser,
    required LocalSignOut localSignOut,
    required AppUserCubit appUserCubit,
    required RemoteGetUser remoteGetUser,
  }) : _appUserCubit = appUserCubit,
       _localGetUser = localGetUser,
       _localSaveUser = localSaveUser,
       _localSignOut = localSignOut,
       _remoteGetUser = remoteGetUser,
       super(Unauthenticated()) {
    on<AppStarted>(_onAppStarted);
    on<AuthSessionUpdated>(_onAuthSessionUpdated);
    on<AuthSignOut>(_onAuthSignOut);
    on<BusinessProfileCreated>(_onBusinessProfileCreated);
  }

  void _onAuthSignOut(AuthSignOut event, Emitter<AuthState> emit) async {
    await _localSignOut(NoParams());
    _appUserCubit.clearUser();
    emit(Unauthenticated());
  }

  void _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    logger.info('App started - checking for existing session.');
    final res = await _localGetUser(NoParams());

    final user = res.fold((l) => null, (user) => user);

    if (user == null) {
      logger.info('No user found in local storage.');
      emit(Unauthenticated());
      return;
    }

    final bool connected = await InternetService().isUserConnected();
    if (!connected) {
      logger.info('User not connected to internet, using local user data.');
      _updateSession(user, emit);
      return;
    }

    logger.info('User found in local storage, fetching from remote.');
    final remoteRes = await _remoteGetUser(
      RemoteGetUserParams(userId: user.id),
    );

    remoteRes.fold((failure) {
      logger.error('Failed to fetch remote user: ${failure.message}');
      // Use local user if remote fetch fails
      _updateSession(user, emit);
    }, (remoteUser) => _updateSession(remoteUser, emit));
  }

  void _onAuthSessionUpdated(
    AuthSessionUpdated event,
    Emitter<AuthState> emit,
  ) {
    logger.info('Session updated for user: ${event.user.email}');
    _updateSession(event.user, emit);
  }

  void _onBusinessProfileCreated(
    BusinessProfileCreated event,
    Emitter<AuthState> emit,
  ) {
    logger.info('Business profile created: ${event.business.id}');
    final User updatedUser = event.user.copyWith(
      businessId: event.business.id,
      business: event.business,
    );
    _updateSession(updatedUser, emit);
  }

  void _updateSession(User user, Emitter<AuthState> emit) {
    _localSaveUser(UserParams(user: user));
    _appUserCubit.updateUser(user);

    if (!user.isEmailVerified) {
      logger.warn('User email not verified: ${user.email}');
      emit(AuthenticatedButEmailUnverified(user));
      return;
    }

    if (user.businessId.isEmpty) {
      logger.warn('User has no business profile: ${user.email}');
      emit(AuthenticatedButNoBusinessProfile(user));
      return;
    }

    emit(Authenticated(user));
  }
}
