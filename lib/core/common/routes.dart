import 'package:flutter/material.dart';
import 'package:ventura/core/presentation/pages/main_screen.dart';
import 'package:ventura/core/presentation/pages/not_found.dart';
import 'package:ventura/features/appointment/domain/entities/appointment_entity.dart';
import 'package:ventura/features/appointment/presentation/pages/create_appointment_page.dart';
import 'package:ventura/features/appointment/presentation/pages/edit_appointment_page.dart';
import 'package:ventura/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:ventura/features/auth/presentation/pages/sign_in_page.dart';
import 'package:ventura/features/auth/presentation/pages/sign_up_page.dart';
import 'package:ventura/features/auth/presentation/pages/verify_code_page.dart';
import 'package:ventura/features/auth/presentation/pages/profile.dart';
import 'package:ventura/features/search/presentation/pages/search_page.dart';
import 'package:ventura/features/welcome/presentation/pages/welcome_page.dart';

class AppRoutes {
  AppRoutes._internal();

  static final AppRoutes instance = AppRoutes._internal();

  final String welcome = '/welcome';
  final String signIn = '/sign-in';
  final String signUp = '/sign-up';
  final String profile = '/profile';
  final String forgotPassword = '/forgot-password';
  final String main = '/main';
  final String verifyCode = '/verify-code';
  final String search = '/search';
  final String createAppointment = '/create-appointment';
  final String editAppointment = '/edit-appointment';

  static final Map<String, WidgetBuilder> routes = {
    '/welcome': (_) => const WelcomePage(),
    '/sign-in': (_) => const SignInPage(),
    '/sign-up': (_) => const SignUpPage(),
    '/verify-code': (_) => VerifyCodePage(),
    '/profile': (_) => const Profile(),
    '/forgot-password': (_) => const ForgotPasswordPage(),
    '/main': (_) => const MainScreen(),
    '/search': (_) => const SearchPage(),
    '/create-appointment': (_) => const CreateAppointmentPage(),
  };

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    // Handle routes with arguments
    if (settings.name == '/edit-appointment') {
      final appointment = settings.arguments as Appointment?;
      if (appointment != null) {
        return MaterialPageRoute(
          builder: (_) => EditAppointmentPage(appointment: appointment),
          settings: settings,
        );
      }
      return MaterialPageRoute(builder: (_) => NotFoundPage());
    }

    final builder = routes[settings.name];

    if (builder != null) {
      return MaterialPageRoute(builder: builder, settings: settings);
    }

    return MaterialPageRoute(builder: (_) => NotFoundPage());
  }
}
