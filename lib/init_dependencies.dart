import 'package:get_it/get_it.dart';
import 'package:ventura/core/cubit/app_user_cubit/app_user_cubit.dart';
import 'package:ventura/core/data_sources/auth_local_data_source.dart';
import 'package:ventura/core/data_sources/auth_local_data_source_impl.dart';
import 'package:ventura/core/services/user/user_service.dart';
import 'package:ventura/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:ventura/features/auth/data/data_sources/auth_remote_datasource_impl.dart';
import 'package:ventura/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:ventura/features/auth/domain/repositories/auth_repository.dart';
import 'package:ventura/features/auth/domain/use_cases/confirm_verification_code.dart';
import 'package:ventura/features/auth/domain/use_cases/get_current_user.dart';
import 'package:ventura/features/auth/domain/use_cases/save_current_user.dart';
import 'package:ventura/features/auth/domain/use_cases/user_sign_in.dart';
import 'package:ventura/features/auth/domain/use_cases/user_sign_in_with_google.dart';
import 'package:ventura/features/auth/domain/use_cases/user_sign_up.dart';
import 'package:ventura/features/auth/presentation/bloc/auth_bloc.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuthDependencies();
  serviceLocator.registerLazySingleton(() => UserService());
}

void _initAuthDependencies() {
  serviceLocator
    ..registerFactory<AuthRemoteDataSource>(() => AuthRemoteDatasourceImpl())
    ..registerFactory<AuthLocalDataSource>(
      () => AuthLocalDataSourceImpl(userService: serviceLocator()),
    )
    ..registerFactory<AuthRepository>(
      () => AuthRepositoryImpl(
        authRemoteDataSource: serviceLocator(),
        authLocalDataSource: serviceLocator(),
      ),
    )
    ..registerFactory(() => UserSignIn(authRepository: serviceLocator()))
    ..registerFactory(() => GetCurrentUser(authRepository: serviceLocator()))
    ..registerFactory(() => SaveCurrentUser(authRepository: serviceLocator()))
    ..registerFactory(
      () => UserSignInWithGoogle(authRepository: serviceLocator()),
    )
    ..registerFactory(
      () => ConfirmVerificationCode(authRepository: serviceLocator()),
    )
    ..registerFactory(() => UserSignUp(authRepository: serviceLocator()))
    ..registerFactory(() => AppUserCubit())
    ..registerLazySingleton(
      () => AuthBloc(
        userSignIn: serviceLocator(),
        userSignUp: serviceLocator(),
        getCurrentUser: serviceLocator(),
        saveCurrentUser: serviceLocator(),
        userSignInWithGoogle: serviceLocator(),
        confirmVerificationCode: serviceLocator(),
        appUserCubit: serviceLocator(),
      ),
    );
}
