import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:ventura/core/common/network_module.dart';
import 'package:ventura/core/data/data_sources/local/abstract_interfaces/business_local_data_source.dart';
import 'package:ventura/core/data/data_sources/local/abstract_interfaces/user_local_data_source.dart';
import 'package:ventura/core/data/data_sources/local/implementations/business_local_data_source_impl.dart';
import 'package:ventura/core/data/data_sources/local/implementations/user_local_data_source_impl.dart';
import 'package:ventura/core/data/data_sources/remote/abstract_interfaces/assets_remote_data_source.dart';
import 'package:ventura/core/data/data_sources/remote/abstract_interfaces/user_remote_data_source.dart';
import 'package:ventura/core/data/data_sources/remote/implementations/assets_remote_data_source_impl.dart';
import 'package:ventura/core/data/data_sources/remote/implementations/user_remote_data_source_impl.dart';
import 'package:ventura/core/data/repositories/assets_repository_impl.dart';
import 'package:ventura/core/data/repositories/business_repository_impl.dart';
import 'package:ventura/core/data/repositories/user_repository_impl.dart';
import 'package:ventura/core/domain/repositories/assets_repository.dart';
import 'package:ventura/core/domain/repositories/business_repository.dart';
import 'package:ventura/core/domain/repositories/user_repository.dart';
import 'package:ventura/core/domain/use_cases/asset_upload_image.dart';
import 'package:ventura/core/domain/use_cases/local_get_business.dart';
import 'package:ventura/core/domain/use_cases/local_get_user.dart';
import 'package:ventura/core/domain/use_cases/local_save_business.dart';
import 'package:ventura/core/domain/use_cases/local_save_user.dart';
import 'package:ventura/core/domain/use_cases/local_sign_out.dart';
import 'package:ventura/core/domain/use_cases/remote_get_user.dart';
import 'package:ventura/core/presentation/cubit/app_user_cubit/app_user_cubit.dart';
import 'package:ventura/core/services/business_service.dart';
import 'package:ventura/features/appointment/data/data_sources/remote/abstract_interfaces/appointment_remote_data_source.dart';
import 'package:ventura/features/appointment/data/data_sources/remote/implementations/appointment_remote_data_source_impl.dart';
import 'package:ventura/features/appointment/data/repositories/appointment_repository_impl.dart';
import 'package:ventura/features/appointment/domain/repositories/appointment_repository.dart';
import 'package:ventura/features/appointment/domain/use_cases/create_appointment.dart';
import 'package:ventura/features/appointment/domain/use_cases/delete_appointment.dart';
import 'package:ventura/features/appointment/domain/use_cases/get_user_appointment.dart';
import 'package:ventura/features/appointment/domain/use_cases/update_appointment.dart';
import 'package:ventura/features/appointment/domain/use_cases/update_google_event_id.dart';
import 'package:ventura/features/appointment/presentation/bloc/appointment_bloc.dart';
import 'package:ventura/features/auth/data/data_sources/local/abstract_interfaces/auth_local_data_source.dart';
import 'package:ventura/features/auth/data/data_sources/local/implementations/auth_local_data_source_impl.dart';
import 'package:ventura/core/services/user_service.dart';
import 'package:ventura/features/auth/data/data_sources/remote/abstract_interfaces/auth_remote_data_source.dart';
import 'package:ventura/features/auth/data/data_sources/remote/implementations/auth_remote_datasource_impl.dart';
import 'package:ventura/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:ventura/features/auth/domain/repositories/auth_repository.dart';
import 'package:ventura/features/auth/domain/use_cases/confirm_email.dart';
import 'package:ventura/features/auth/domain/use_cases/confirm_verification_code.dart';
import 'package:ventura/features/auth/domain/use_cases/create_business_profile.dart';
import 'package:ventura/features/auth/domain/use_cases/reset_password.dart';
import 'package:ventura/features/auth/domain/use_cases/user_sign_in.dart';
import 'package:ventura/features/auth/domain/use_cases/user_sign_in_with_google.dart';
import 'package:ventura/features/auth/domain/use_cases/user_sign_up.dart';
import 'package:ventura/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ventura/features/auth/presentation/cubit/business_creation_cubit.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  // register global Dio instance from NetworkModule
  serviceLocator.registerLazySingleton<Dio>(() => NetworkModule.instance.dio);
  _initAuthDependencies();
  _initAppointmentDependencies();
  serviceLocator.registerLazySingleton(() => UserService());
  serviceLocator.registerLazySingleton(() => BusinessService());
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
    ..registerFactory<UserRemoteDataSource>(
      () => UserRemoteDataSourceImpl(dio: serviceLocator()),
    )
    ..registerFactory<BusinessLocalDataSource>(
      () => BusinessLocalDataSourceImpl(businessService: serviceLocator()),
    )
    ..registerFactory<AssetsRemoteDataSource>(
      () => AssetsRemoteDataSourceImpl(dio: serviceLocator()),
    )
    // REPOSITORIES
    ..registerFactory<UserRepository>(
      () => UserRepositoryImpl(
        userLocalDataSource: serviceLocator(),
        userRemoteDataSource: serviceLocator(),
      ),
    )
    ..registerFactory<AuthRepository>(
      () => AuthRepositoryImpl(
        authRemoteDataSource: serviceLocator(),
        userRemoteDataSource: serviceLocator(),
      ),
    )
    ..registerFactory<BusinessRepository>(
      () => BusinessRepositoryImpl(businessLocalDataSource: serviceLocator()),
    )
    ..registerFactory<AssetsRepository>(
      () => AssetsRepositoryImpl(assetsRemoteDataSource: serviceLocator()),
    )
    // USE CASES
    ..registerFactory(() => RemoteGetUser(userRepository: serviceLocator()))
    ..registerFactory(() => UserSignIn(authRepository: serviceLocator()))
    ..registerFactory(() => LocalGetUser(userRepository: serviceLocator()))
    ..registerFactory(() => LocalSaveUser(userRepository: serviceLocator()))
    ..registerFactory(() => LocalSignOut(userRepository: serviceLocator()))
    ..registerFactory(
      () => LocalGetBusiness(businessRepository: serviceLocator()),
    )
    ..registerFactory(
      () => LocalSaveBusiness(businessRepository: serviceLocator()),
    )
    ..registerFactory(
      () => UserSignInWithGoogle(authRepository: serviceLocator()),
    )
    ..registerFactory(() => ConfirmEmail(authRepository: serviceLocator()))
    ..registerFactory(
      () => ConfirmVerificationCode(authRepository: serviceLocator()),
    )
    ..registerFactory(() => UserSignUp(authRepository: serviceLocator()))
    ..registerFactory(() => ResetPassword(authRepository: serviceLocator()))
    ..registerFactory(
      () => AssetUploadImage(assetsRepository: serviceLocator()),
    )
    ..registerFactory(
      () => CreateBusinessProfile(authRepository: serviceLocator()),
    )
    // BLOC
    ..registerFactory(() => AppUserCubit())
    ..registerFactory(
      () => BusinessCreationCubit(
        localSaveBusiness: serviceLocator(),
        localSaveUser: serviceLocator(),
        assetUploadImage: serviceLocator(),
        createBusinessProfile: serviceLocator(),
      ),
    )
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
        remoteGetUser: serviceLocator(),
      ),
    );
}

void _initAppointmentDependencies() {
  serviceLocator
    // DATA SOURCES
    ..registerFactory<AppointmentRemoteDataSource>(
      () => AppointmentRemoteDataSourceImpl(dio: serviceLocator()),
    )
    //    REPOSITORIES
    ..registerFactory<AppointmentRepository>(
      () => AppointmentRepositoryImpl(
        appointmentRemoteDataSource: serviceLocator(),
      ),
    )
    //     USE-CASES
    ..registerFactory(
      () => CreateAppointment(appointmentRepository: serviceLocator()),
    )
    ..registerFactory(
      () => UpdateAppointment(appointmentRepository: serviceLocator()),
    )
    ..registerFactory(
      () => UpdateGoogleEventId(appointmentRepository: serviceLocator()),
    )
    ..registerFactory(
      () => DeleteAppointment(appointmentRepository: serviceLocator()),
    )
    ..registerFactory(
      () => GetUserAppointment(appointmentRepository: serviceLocator()),
    )
    //     BLOC
    ..registerLazySingleton(
      () => AppointmentBloc(
        createAppointment: serviceLocator(),
        updateAppointment: serviceLocator(),
        updateGoogleEventId: serviceLocator(),
        getUserAppointment: serviceLocator(),
        deleteAppointment: serviceLocator(),
      ),
    );
}
