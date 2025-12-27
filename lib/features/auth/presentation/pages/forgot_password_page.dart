import 'package:flutter/material.dart';
import 'package:ventura/config/routes.dart';
import 'package:ventura/features/auth/presentation/widgets/verify_email_form.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final AppRoutes routes = AppRoutes.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(),
      body: SafeArea(child: VerifyEmailForm()),
    );
  }
}
