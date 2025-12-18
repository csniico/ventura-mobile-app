import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ventura/core/presentation/pages/main_screen.dart';
import 'package:ventura/core/common/routes.dart';
import 'package:ventura/core/presentation/themes/app_theme.dart';
import 'package:ventura/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ventura/features/auth/presentation/pages/create_business_profile_page.dart';
import 'package:ventura/features/auth/presentation/widgets/verify_code_form.dart';
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
          if (state is AuthSuccess) {
            debugPrint('User is authenticated');
            navigatorKey.currentState?.pushNamedAndRemoveUntil(
              _appRoutes.main,
              (_) => false,
            );
          }
        },
        builder: (context, state) {
          switch (state) {
            case AuthSuccess():
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
