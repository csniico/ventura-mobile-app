import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ventura/app/routes.dart';
import 'package:ventura/core/providers/user_provider.dart';
import 'package:ventura/core/theme/app_theme.dart';

// Create a navigator key.
final navigatorKey = GlobalKey<NavigatorState>();

class App extends ConsumerWidget {
  final String initialRoute;

  const App({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(userProvider, (_, userState) {
      final user = userState.value;

      // Use the navigatorKey to navigate without a BuildContext.
      if (user == null) {
        navigatorKey.currentState?.pushNamedAndRemoveUntil('/welcome', (_) => false);
      } else {
        navigatorKey.currentState?.pushNamedAndRemoveUntil('/', (_) => false);
      }
    });

    return MaterialApp(
      // Assign the navigatorKey to the MaterialApp.
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      onGenerateRoute: AppRoutes.onGenerateRoute,
      initialRoute: initialRoute,
    );
  }
}
