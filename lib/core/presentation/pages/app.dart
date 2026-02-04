import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ventura/core/presentation/cubit/app_user_cubit/app_user_cubit.dart';
import 'package:ventura/core/presentation/pages/main_screen.dart';
import 'package:ventura/config/routes.dart';
import 'package:ventura/core/presentation/themes/app_theme.dart';
import 'package:ventura/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ventura/features/auth/presentation/pages/create_business_profile_page.dart';
import 'package:ventura/features/auth/presentation/pages/sign_in_page.dart';
import 'package:ventura/features/auth/presentation/pages/verify_code_page.dart';

final navigatorKey = GlobalKey<NavigatorState>();

class App extends StatelessWidget {
  const App({super.key});

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
            context.read<AppUserCubit>().updateUser(state.user);
          } else if (state is Unauthenticated) {
            context.read<AppUserCubit>().clearUser();
          } else if (state is AuthenticatedButEmailUnverified) {
            context.read<AppUserCubit>().updateUser(state.user);
          } else if (state is AuthenticatedButNoBusinessProfile) {
            context.read<AppUserCubit>().updateUser(state.user);
          }
        },
        builder: (context, state) {
          return switch (state) {
            Authenticated() => const MainScreen(),
            AuthenticatedButEmailUnverified() =>
              const SignInPage(), // User needs to verify via email link, keep on sign-in page
            AuthenticatedButNoBusinessProfile() => CreateBusinessProfilePage(
              user: state.user,
            ),
            Unauthenticated() => const SignInPage(),
          };
        },
      ),
      routes: AppRoutes.routes,
      onGenerateRoute: AppRoutes.onGenerateRoute,
    );
  }
}
