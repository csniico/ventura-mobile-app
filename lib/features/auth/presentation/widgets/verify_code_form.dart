import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ventura/core/services/toast_service.dart';
import 'package:ventura/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ventura/features/auth/presentation/widgets/auth_field.dart';
import 'package:ventura/features/auth/presentation/widgets/new_password_form.dart';
import 'package:ventura/features/auth/presentation/widgets/submit_form_button.dart';

class VerifyCodeForm extends StatefulWidget {
  final String email;
  final String shortToken;

  const VerifyCodeForm({
    super.key,
    required this.email,
    required this.shortToken,
  });

  @override
  State<VerifyCodeForm> createState() => _VerifyCodeFormState();
}

class _VerifyCodeFormState extends State<VerifyCodeForm> {
  final _formKey = GlobalKey<FormState>();
  String? _code = "";
  bool _isLoading = false;
  bool _isDisabled = false;

  @override
  void reassemble() {
    super.reassemble();
    // Reset state on hot reload
    resetButtonState();
  }

  void resetButtonState() {
    setState(() {
      _isDisabled = false;
      _isLoading = false;
    });
  }

  void _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
        _isDisabled = true;
      });
      debugPrint("code: $_code");
      context.read<AuthBloc>().add(
        AuthResetPasswordConfirmVerificationCode(
          code: _code!,
          email: widget.email,
          shortToken: widget.shortToken,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            ToastService.showError(state.message);
          } else if (state is VerificationCodeConfirmed) {
            ToastService.showSuccess(state.user.email);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => NewPasswordForm(
                  userId: state.user.id,
                  email: state.user.email,
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          return Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Enter verification code',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        AuthField(
                          hintText: "Code",
                          title: "Code",
                          inputType: TextInputType.text,
                          onSaved: (value) {
                            setState(() {
                              _code = value;
                            });
                          },
                        ),

                        const SizedBox(height: 30),
                        SubmitFormButton(
                          title: "Confirm Code",
                          isLoading: _isLoading,
                          onPressed: _handleSubmit,
                          isDisabled: _isDisabled,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
