import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ventura/config/app_logger.dart';
import 'package:ventura/core/services/toast_service.dart';
import 'package:ventura/features/auth/presentation/cubit/password_recovery_cubit.dart';
import 'package:ventura/init_dependencies.dart';
import 'package:ventura/features/auth/presentation/widgets/auth_field.dart';
import 'package:ventura/features/auth/presentation/widgets/submit_form_button.dart';
import 'package:ventura/features/auth/presentation/widgets/verify_code_form.dart';

class VerifyEmailForm extends StatefulWidget {
  const VerifyEmailForm({super.key});

  @override
  State<VerifyEmailForm> createState() => _VerifyEmailFormState();
}

class _VerifyEmailFormState extends State<VerifyEmailForm> {
  final logger = AppLogger('_VerifyEmailFormState');
  final _formKey = GlobalKey<FormState>();
  String? _email = "";
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
      context.read<PasswordRecoveryCubit>().sendResetCode(email: _email!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<PasswordRecoveryCubit>(),
      child: Scaffold(
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
              if (state is PasswordRecoveryCodeSent) {
                ToastService.showSuccess('Password reset code sent');
                resetButtonState();

                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => VerifyCodeForm(
                      email: state.email,
                      shortToken: state.shortToken,
                    ),
                  ),
                );
              } else if (state is PasswordRecoveryError) {
                logger.error(state.message);
                ToastService.showError(state.message);
                resetButtonState();
              }
            },
            builder: (context, state) {
              return SafeArea(
                child: Form(
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
                                'Enter your email to verify your account',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              AuthField(
                                hintText: "Email",
                                title: "Email",
                                inputType: TextInputType.emailAddress,
                                onSaved: (value) {
                                  setState(() {
                                    _email = value;
                                  });
                                },
                              ),

                              const SizedBox(height: 30),
                              SubmitFormButton(
                                title: "Verify Email",
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
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
