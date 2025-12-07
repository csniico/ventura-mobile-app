import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:ventura/app/app.dart';
import 'package:ventura/app/routes.dart';
import 'package:ventura/core/services/business/business_service.dart';
import 'package:ventura/core/services/user/user_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ventura/features/auth/data/data_sources/auth_remote_datasource_impl.dart';
import 'package:ventura/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:ventura/features/auth/domain/use_cases/get_current_user.dart';
import 'package:ventura/features/auth/domain/use_cases/user_sign_in.dart';
import 'package:ventura/features/auth/domain/use_cases/user_sign_in_with_google.dart';
import 'package:ventura/features/auth/presentation/bloc/auth_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the appropriate database factory for the current platform.
  if (kIsWeb) {
    // Use the web-specific factory.
    databaseFactory = databaseFactoryFfiWeb;
  } else if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    // Use the FFI factory for desktop.
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  await dotenv.load(fileName: '.env');

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => AuthBloc(
            userSignIn: UserSignIn(
              authRepository: AuthRepositoryImpl(
                authRemoteDataSource: AuthRemoteDatasourceImpl(),
              ),
            ),
            getCurrentUser: GetCurrentUser(),
            userSignInWithGoogle: UserSignInWithGoogle(
              authRepository: AuthRepositoryImpl(
                authRemoteDataSource: AuthRemoteDatasourceImpl(),
              ),
            ),
          ),
        ),
      ],
      child: App(),
    ),
  );
}
