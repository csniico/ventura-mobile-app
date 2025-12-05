import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ventura/app/main_screen.dart';
import 'package:ventura/app/not_found.dart';
import 'package:ventura/core/providers/user_provider.dart';
import 'package:ventura/features/auth/presentation/pages/sign_in_page.dart';
import 'package:ventura/features/profile/presentation/profile.dart';
import 'package:ventura/features/welcome/presentation/pages/welcome_page.dart';

class AppRoutes {

  static String getInitialRoute(WidgetRef ref) {
    final user = ref.read(userProvider).value;
    return user != null ? '/' : '/welcome';
  }

  static final Map<String, WidgetBuilder> routes = {
    '/': (_) => const MainScreen(),
    '/welcome': (_) => const WelcomePage(),
    '/sign-in': (_) => const SignInPage(),
    '/profile': (_) => const Profile(),
  };

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final builder = routes[settings.name];

    if (builder != null) {
      return MaterialPageRoute(builder: builder, settings: settings);
    }

    return MaterialPageRoute(builder: (_) => NotFoundPage());
  }
}
