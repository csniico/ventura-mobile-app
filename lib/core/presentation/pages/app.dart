import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ventura/core/presentation/cubit/app_user_cubit/app_user_cubit.dart';
import 'package:ventura/core/presentation/pages/main_screen.dart';
import 'package:ventura/config/routes.dart';
import 'package:ventura/core/presentation/themes/app_theme.dart';
import 'package:ventura/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ventura/features/welcome/presentation/pages/welcome_page.dart';

final navigatorKey = GlobalKey<NavigatorState>();

class App extends StatelessWidget {
  App({super.key});

  final AppRoutes _appRoutes = AppRoutes.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      home: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            debugPrint('User is authenticated');
            context.read<AppUserCubit>().updateUser(state.user);
            navigatorKey.currentState?.pushNamedAndRemoveUntil(
              _appRoutes.main,
              (_) => false,
            );
          } else if (state is UnAuthenticated) {
            context.read<AppUserCubit>().clearUser();
          }
        },
        builder: (context, state) {
          switch (state) {
            case Authenticated():
              return const MainScreen();
            default:
              return const WelcomePage();
          }
        },
      ),
      routes: AppRoutes.routes,
      onGenerateRoute: AppRoutes.onGenerateRoute,
    );
  }
}
