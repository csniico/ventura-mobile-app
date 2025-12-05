import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ventura/core/widgets/text_component.dart';
import 'package:ventura/features/auth/presentation/widgets/sign_in_with_google.dart';

class WelcomePage extends ConsumerStatefulWidget {
  const WelcomePage({super.key});

  @override
  ConsumerState<WelcomePage> createState() => _WelcomeState();
}

class _WelcomeState extends ConsumerState<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/icon.png",
                    height: 100,
                    color: Theme.of(context).primaryColor,
                  ),
                  TextComponent(text: "Welcome to Ventura", type: "title"),
                  SizedBox(height: 20),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 70, right: 70, bottom: 40),
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pushNamed('/sign-in'),
                child: Text("Get Started"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
