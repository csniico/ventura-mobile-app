import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ventura/core/services/toast_service.dart';
import 'package:ventura/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ventura/features/auth/presentation/cubit/email_verification_cubit.dart';
import 'package:ventura/features/auth/presentation/widgets/submit_form_button.dart';
import 'package:ventura/init_dependencies.dart';

class VerifyCodePage extends StatefulWidget {
  const VerifyCodePage({super.key});

  @override
  State<VerifyCodePage> createState() => _VerifyCodePageState();
}

class _VerifyCodePageState extends State<VerifyCodePage> {
  final _formKey = GlobalKey<FormState>();
  String? _code;
  String? _email;
  String? _shortToken;
  bool _initialized = false;
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_initialized) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      setState(() {
        _email = args['email'] as String;
        _shortToken = args['shortToken'] as String;
        _initialized = true;
      });
    }
  }

  void handleConfirmCodeButtonClicked() {
    setState(() {
      _isDisabled = true;
      _isLoading = true;
    });
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      context.read<EmailVerificationCubit>().verifyCode(
        code: _code!,
        email: _email!,
        shortToken: _shortToken!,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<EmailVerificationCubit>(),
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
          child: BlocListener<EmailVerificationCubit, EmailVerificationState>(
            listener: (context, state) {
              if (state is EmailVerificationError) {
                resetButtonState();
                ToastService.showError(state.message);
              } else if (state is EmailVerificationVerified) {
                resetButtonState();
                ToastService.showSuccess('Email verified successfully!');
                // Update AuthBloc session
                context.read<AuthBloc>().add(AuthSessionUpdated(state.user));
                // Navigation will be handled by App widget based on AuthBloc state
              }
            },
            child: BlocBuilder<EmailVerificationCubit, EmailVerificationState>(
              builder: (context, state) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(vertical: 50),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Enter Verification Code',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 30),
                          Text('Check your email for the verification code'),
                          const SizedBox(height: 10),
                          TextFormField(
                            maxLength: 6,
                            onSaved: (value) {
                              setState(() {
                                _code = value;
                              });
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'You must enter a six digit verification code';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          InkWell(
                            onTap: () {
                              if (_email != null) {
                                context
                                    .read<EmailVerificationCubit>()
                                    .resendCode(email: _email!);
                                ToastService.showInfo(
                                  'Resending verification code...',
                                );
                              }
                            },
                            child: RichText(
                              text: TextSpan(
                                text: "Resend",
                                style: Theme.of(context).textTheme.titleMedium,
                                children: [
                                  TextSpan(
                                    text: " code",
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleMedium,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          SubmitFormButton(
                            title: 'Confirm Code',
                            onPressed: handleConfirmCodeButtonClicked,
                            isDisabled: _isDisabled,
                            isLoading:
                                _isLoading ||
                                state is EmailVerificationVerifying,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
