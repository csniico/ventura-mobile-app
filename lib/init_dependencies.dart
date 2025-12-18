import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:ventura/core/common/network_module.dart';
import 'package:ventura/core/data/datasources/local/user_local_data_source.dart';
import 'package:ventura/core/data/datasources/local/user_local_data_source_impl.dart';
import 'package:ventura/core/data/repositories/user_repository_impl.dart';
import 'package:ventura/core/domain/repositories/user_repository.dart';
import 'package:ventura/core/domain/use_cases/local_get_user.dart';
import 'package:ventura/core/domain/use_cases/local_save_user.dart';
import 'package:ventura/core/domain/use_cases/local_sign_out.dart';
import 'package:ventura/core/presentation/cubit/app_user_cubit/app_user_cubit.dart';
import 'package:ventura/features/auth/data/data_sources/local/auth_local_data_source.dart';
import 'package:ventura/features/auth/data/data_sources/local/auth_local_data_source_impl.dart';
import 'package:ventura/core/services/user_service.dart';
import 'package:ventura/features/auth/data/data_sources/remote/auth_remote_data_source.dart';
import 'package:ventura/features/auth/data/data_sources/remote/auth_remote_datasource_impl.dart';
import 'package:ventura/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:ventura/features/auth/domain/repositories/auth_repository.dart';
import 'package:ventura/features/auth/domain/use_cases/confirm_email.dart';
import 'package:ventura/features/auth/domain/use_cases/confirm_verification_code.dart';
import 'package:ventura/features/auth/domain/use_cases/reset_password.dart';
import 'package:ventura/features/auth/domain/use_cases/user_sign_in.dart';
import 'package:ventura/features/auth/domain/use_cases/user_sign_in_with_google.dart';
import 'package:ventura/features/auth/domain/use_cases/user_sign_up.dart';
import 'package:ventura/features/auth/presentation/bloc/auth_bloc.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  // register global Dio instance from NetworkModule
  serviceLocator.registerLazySingleton<Dio>(() => NetworkModule.instance.dio);
  _initAuthDependencies();
  serviceLocator.registerLazySingleton(() => UserService());
}

void _initAuthDependencies() {
  // DATA SOURCES
  serviceLocator
    ..registerFactory<AuthRemoteDataSource>(
      () => AuthRemoteDatasourceImpl(dio: serviceLocator()),
    )
    ..registerFactory<AuthLocalDataSource>(
      () => AuthLocalDataSourceImpl(userService: serviceLocator()),
    )
    ..registerFactory<UserLocalDataSource>(
      () => UserLocalDataSourceImpl(userService: serviceLocator()),
    )
    // REPOSITORIES
    ..registerFactory<UserRepository>(
      () => UserRepositoryImpl(userLocalDataSource: serviceLocator()),
    )
    ..registerFactory<AuthRepository>(
      () => AuthRepositoryImpl(authRemoteDataSource: serviceLocator()),
    )
    // USE CASES
    ..registerFactory(() => UserSignIn(authRepository: serviceLocator()))
    ..registerFactory(() => LocalGetUser(userRepository: serviceLocator()))
    ..registerFactory(() => LocalSaveUser(userRepository: serviceLocator()))
    ..registerFactory(() => LocalSignOut(userRepository: serviceLocator()))
    ..registerFactory(
      () => UserSignInWithGoogle(authRepository: serviceLocator()),
    )
    ..registerFactory(() => ConfirmEmail(authRepository: serviceLocator()))
    ..registerFactory(
      () => ConfirmVerificationCode(authRepository: serviceLocator()),
    )
    ..registerFactory(() => UserSignUp(authRepository: serviceLocator()))
    ..registerFactory(() => ResetPassword(authRepository: serviceLocator()))
    ..registerFactory(() => AppUserCubit())
    // BLOC
    ..registerLazySingleton(
      () => AuthBloc(
        userSignIn: serviceLocator(),
        userSignUp: serviceLocator(),
        localGetUser: serviceLocator(),
        localSaveUser: serviceLocator(),
        localSignOut: serviceLocator(),
        confirmEmail: serviceLocator(),
        userSignInWithGoogle: serviceLocator(),
        confirmVerificationCode: serviceLocator(),
        resetPassword: serviceLocator(),
        appUserCubit: serviceLocator(),
      ),
    );
}
