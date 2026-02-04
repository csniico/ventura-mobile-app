import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ventura/core/services/toast_service.dart';
import 'package:ventura/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ventura/features/auth/presentation/cubit/password_recovery_cubit.dart';
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
  bool _obscureConfirmationPassword = true;
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
      context.read<PasswordRecoveryCubit>().resetPassword(
        userId: widget.userId,
        newPassword: _password!,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(8.0),
          child: const SizedBox(height: 8.0),
        ),
        leading: IconButton(
          icon: HugeIcon(
            icon: HugeIcons.strokeRoundedArrowLeft01,
            color: Theme.of(context).colorScheme.onPrimary,
            size: 30,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: BlocConsumer<PasswordRecoveryCubit, PasswordRecoveryState>(
          listener: (context, state) {
            if (state is PasswordRecoveryError) {
              resetButtonState();
              ToastService.showError(state.message);
            } else if (state is PasswordRecoverySuccess) {
              resetButtonState();
              ToastService.showSuccess('Password reset successfully');
              // Update AuthBloc session
              context.read<AuthBloc>().add(AuthSessionUpdated(state.user));
              // Navigation handled by App widget
              Navigator.of(context).popUntil((route) => route.isFirst);
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
                            obscureText: _obscureConfirmationPassword,
                            suffixIcon: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: IconButton(
                                icon: HugeIcon(
                                  icon: _obscureConfirmationPassword
                                      ? HugeIcons.strokeRoundedView
                                      : HugeIcons.strokeRoundedViewOffSlash,
                                  color: Colors.grey[600],
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureConfirmationPassword =
                                        !_obscureConfirmationPassword;
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
      ),
    );
  }
}
