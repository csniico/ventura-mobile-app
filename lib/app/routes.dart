import 'package:flutter/material.dart';
import 'package:ventura/app/main_screen.dart';
import 'package:ventura/app/not_found.dart';
import 'package:ventura/features/home/presentation/home.dart';

class AppRoutes {
  static const String initial = '/';

  static final Map<String, WidgetBuilder> routes = {
    '/': (_) => const MainScreen(),
  };

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final builder = routes[settings.name];

    if (builder != null) {
      return MaterialPageRoute(builder: builder);
    }

    return MaterialPageRoute(builder: (_) => NotFoundPage());
  }
}