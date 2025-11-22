import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ventura/app/app.dart';
import 'package:ventura/app/routes.dart';
import 'package:ventura/core/services/user/user_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await UserService().loadUser();

  final initialRoute = AppRoutes.getInitialRoute();
  runApp(App(initialRoute: await initialRoute));
}
