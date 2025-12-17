import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ventura/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ventura/features/auth/presentation/widgets/new_password_form.dart';
import 'package:ventura/features/auth/presentation/widgets/verify_code_form.dart';
import 'package:ventura/features/auth/presentation/widgets/verify_email_form.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          context.read<AuthBloc>().add(AuthResetState());
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(),
        body: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthInitial) {
              Navigator.of(context).pop();
            }
          },
          builder: (context, state) {
            switch (state) {
              case AuthLoading():
                return const Center(child: CircularProgressIndicator());
              case AuthFailure():
                return Center(child: Text("Error: ${state.message}"));
              case AuthUserForgotPassword():
                return VerifyEmailForm();
              case AuthEmailIsVerified():
                return VerifyCodeForm();
              case VerificationCodeConfirmed():
                return NewPasswordForm();
              case PasswordResetSuccessful():
                return Center(
                  child: Column(
                    children: [
                      Text("Password reset successful!"),
                      TextButton(
                        onPressed: () {
                          context.read<AuthBloc>().add(AuthResetState());
                        },
                        child: Text('Start Again'),
                      ),
                    ],
                  ),
                );
              default:
                return Center(child: Text("Forgot Password Page"));
            }
          },
        ),
      ),
    );
  }
}
