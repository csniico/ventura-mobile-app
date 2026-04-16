import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ventura/core/presentation/cubit/app_user_cubit/app_user_cubit.dart';
import 'package:ventura/core/presentation/pages/app.dart';
import 'package:ventura/features/appointment/presentation/bloc/appointment_bloc.dart';
import 'package:ventura/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ventura/init_dependencies.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();

  runApp(
    MultiBlocProvider(
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
  );
}
