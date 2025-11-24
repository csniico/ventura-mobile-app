import 'package:flutter/material.dart';
import 'package:ventura/core/widgets/text_component.dart';
import 'package:ventura/features/auth/presentation/sign_in_with_google.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            padding: EdgeInsets.all(20),
            height: MediaQuery.heightOf(context) / 2,
            child: Column(
              children: [
                Image.asset(
                  "assets/images/icon.png",
                  height: 100,
                  color: Theme.of(context).primaryColor,
                ),
                TextComponent(text: "Welcome to Ventura", type: "title"),
                SizedBox(height: 20),
                TextComponent(
                  text: "Sign in to manage your business",
                  type: "subtitle",
                ),
                SizedBox(height: 20),
                SignInWithGoogle(),
                SizedBox(height: 20),
                TextButton(
                  onPressed: () => Navigator.of(context).pushNamed('/sign-in'),
                  child: TextComponent(
                    text: "Continue with email",
                    type: "body",
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
