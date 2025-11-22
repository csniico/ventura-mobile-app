import 'package:flutter/material.dart';
import 'package:ventura/app/main_screen.dart';
import 'package:ventura/app/not_found.dart';
import 'package:ventura/core/services/user/user_service.dart';
import 'package:ventura/features/accounting/presentation/accounting.dart';
import 'package:ventura/features/analytics/presentation/analytics.dart';
import 'package:ventura/features/business_profile/presentation/business_profile.dart';
import 'package:ventura/features/help_and_support/presentation/help_and_support.dart';
import 'package:ventura/features/inventory/presentation/inventory.dart';
import 'package:ventura/features/settings/presentation/settings.dart';
import 'package:ventura/features/team/presentation/team.dart';
import 'package:ventura/features/welcome/presentation/welcome.dart';

class AppRoutes {

  static String getInitialRoute() {
    return UserService().hasUser ? '/' : '/welcome';
  }

  static final Map<String, WidgetBuilder> routes = {
    '/': (_) => const MainScreen(),
    '/welcome': (_) => const Welcome(),
    '/inventory': (_) => const Inventory(),
    '/team': (_) => const Team(),
    '/accounting': (_) => const Accounting(),
    '/analytics': (_) => const Analytics(),
    '/business_profile': (_) => const BusinessProfile(),
    '/settings': (_) => const Settings(),
    '/help_and_support': (_) => const HelpAndSupport(),
  };

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final builder = routes[settings.name];

    if (builder != null) {
      return MaterialPageRoute(builder: builder, settings: settings);
    }

    return MaterialPageRoute(builder: (_) => NotFoundPage());
  }
}
