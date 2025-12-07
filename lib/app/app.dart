import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ventura/app/routes.dart';
import 'package:ventura/core/theme/app_theme.dart';
import 'package:ventura/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ventura/features/home/presentation/pages/home.dart';
import 'package:ventura/features/welcome/presentation/pages/welcome_page.dart';

final navigatorKey = GlobalKey<NavigatorState>();

class App extends StatelessWidget {
  App({super.key});

  final AppRoutes _appRoutes = AppRoutes.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Assign the navigatorKey to the MaterialApp.
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      home: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is UnAuthenticated) {
            debugPrint('User is unauthenticated');
            navigatorKey.currentState?.pushNamedAndRemoveUntil(
              _appRoutes.welcome,
              (_) => false,
            );
          }
          if (state is Authenticated) {
            debugPrint('User is authenticated');
            MaterialPageRoute(builder: (context) => const Home());
          }
        },
        builder: (context, state) {
          // Always show a loading indicator initially, and let the listener handle navigation.
          return const WelcomePage();
        },
      ),
      routes: AppRoutes.routes,
      onGenerateRoute: AppRoutes.onGenerateRoute,
    );
  }
}
