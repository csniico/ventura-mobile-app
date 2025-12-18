import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ventura/core/services/toast_service.dart';
import 'package:ventura/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ventura/features/auth/presentation/widgets/auth_field.dart';
import 'package:ventura/features/auth/presentation/widgets/submit_form_button.dart';

class NewPasswordForm extends StatefulWidget {
  final String userId;
  final String? email;

  const NewPasswordForm({super.key, required this.userId, this.email});

  @override
  State<NewPasswordForm> createState() => _NewPasswordFormState();
}

class _NewPasswordFormState extends State<NewPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  String? _password = "";
  String? _confirmPassword = "";
  bool _obscurePassword = true;
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
      debugPrint("password: $_password");
      debugPrint("password: $_confirmPassword");
      context.read<AuthBloc>().add(
        AuthResetPassword(
          email: widget.email,
          newPassword: _password!,
          userId: widget.userId,
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
          } else if (state is AuthSuccess) {
            ToastService.showSuccess(state.user.id);
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
                          hintText: "Password",
                          title: "New Password",
                          obscureText: _obscurePassword,
                          suffixIcon: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: IconButton(
                              icon: HugeIcon(
                                icon: _obscurePassword
                                    ? HugeIcons.strokeRoundedView
                                    : HugeIcons.strokeRoundedViewOffSlash,
                                color: Colors.grey[600],
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),
                          onSaved: (value) {
                            setState(() {
                              _password = value;
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        AuthField(
                          hintText: "Password",
                          title: "Confirm Password",
                          obscureText: _obscurePassword,
                          suffixIcon: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: IconButton(
                              icon: HugeIcon(
                                icon: _obscurePassword
                                    ? HugeIcons.strokeRoundedView
                                    : HugeIcons.strokeRoundedViewOffSlash,
                                color: Colors.grey[600],
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),
                          onSaved: (value) {
                            setState(() {
                              _confirmPassword = value;
                            });
                          },
                        ),

                        const SizedBox(height: 30),
                        SubmitFormButton(
                          title: "Reset Password",
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
