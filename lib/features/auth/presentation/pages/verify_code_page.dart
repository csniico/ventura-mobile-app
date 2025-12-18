import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ventura/core/services/toast_service.dart';
import 'package:ventura/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ventura/features/auth/presentation/pages/create_business_profile_page.dart';
import 'package:ventura/features/auth/presentation/widgets/submit_form_button.dart';

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
      debugPrint("We're making good progress!");
      debugPrint(
        'Code: $_code ----- Email: $_email ------ shortToken: $_shortToken',
      );
      _formKey.currentState!.save();
      context.read<AuthBloc>().add(
        AuthConfirmVerificationCode(
          code: _code!,
          email: _email!,
          shortToken: _shortToken!,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          switch (state) {
            case AuthFailure():
              resetButtonState();
              ToastService.showError(state.message);
              break;
            case AuthSuccess():
              resetButtonState();
              ToastService.showSuccess('Email verified successfully!');
              break;
            case AuthBusinessNotRegistered():
              ToastService.showSuccess('Email verified successfully');
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => CreateBusinessProfilePage(
                    userId: state.userId,
                    firstName: state.firstName,
                  ),
                ),
              );
              break;
            default:
              break;
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Padding(
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
                          debugPrint('I chose to resend the code!');
                        },
                        child: RichText(
                          text: TextSpan(
                            text: "Resend",
                            style: Theme.of(context).textTheme.titleMedium,
                            children: [
                              TextSpan(
                                text: " 60s",
                                style: Theme.of(context).textTheme.titleMedium,
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
                        isLoading: _isLoading,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
