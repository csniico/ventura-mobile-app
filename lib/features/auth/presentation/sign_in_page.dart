import 'package:flutter/material.dart';
import 'package:ventura/core/widgets/text_component.dart';
import 'package:ventura/features/auth/presentation/sign_in_form.dart';
import 'package:ventura/features/auth/presentation/sign_in_with_google.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(child: SignInForm()),
    );
  }
}
