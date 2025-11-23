import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:ventura/app/app.dart';
import 'package:ventura/app/routes.dart';
import 'package:ventura/core/services/business/business_service.dart';
import 'package:ventura/core/services/user/user_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the appropriate database factory for the current platform.
  if (kIsWeb) {
    // Use the web-specific factory.
    databaseFactory = databaseFactoryFfiWeb;
  } else if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    // Use the FFI factory for desktop.
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  await dotenv.load(fileName: '.env');

  // Load essential services.
  await UserService().loadUser();
  await BusinessService().loadActiveBusiness();

  final initialRoute = AppRoutes.getInitialRoute();
  runApp(App(initialRoute: initialRoute));
}
