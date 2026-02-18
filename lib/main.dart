import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:ventura/core/presentation/cubit/app_user_cubit/app_user_cubit.dart';
import 'package:ventura/core/presentation/pages/app.dart';
import 'package:ventura/features/appointment/presentation/bloc/appointment_bloc.dart';
import 'package:ventura/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ventura/init_dependencies.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

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
  await initDependencies();

  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://5ecccc596439f8611fc9fd058619cb23@o4509548115001344.ingest.de.sentry.io/4510905790431312';
      options.tracesSampleRate = 1.0;
      options.profilesSampleRate = 1.0;
      options.replay.sessionSampleRate = 1.0;
      options.replay.onErrorSampleRate = 1.0;
    },
    appRunner: () => runApp(
      SentryWidget(
        child: MultiBlocProvider(
          providers: [
            BlocProvider<AppUserCubit>(
              create: (_) => serviceLocator<AppUserCubit>(),
            ),
            BlocProvider<AuthBloc>(
              create: (_) => serviceLocator<AuthBloc>()..add(AppStarted()),
            ),
            BlocProvider<AppointmentBloc>(
              create: (_) => serviceLocator<AppointmentBloc>(),
            ),
          ],
          child: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: App(),
          ),
        ),
      ),
    ),
  );
}
