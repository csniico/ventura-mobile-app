import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ventura/config/routes.dart';
import 'package:ventura/core/services/toast_service.dart';
import 'package:ventura/features/auth/presentation/cubit/registration_cubit.dart';
import 'package:ventura/init_dependencies.dart';
import 'package:ventura/features/auth/presentation/widgets/auth_field.dart';
import 'package:ventura/features/auth/presentation/widgets/sign_in_with_google.dart';
import 'package:ventura/features/auth/presentation/widgets/submit_form_button.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final routes = AppRoutes.instance;
  final _formKey = GlobalKey<FormState>();
  String? serverUrl = dotenv.env['SERVER_URL'];
  String? _email = "";
  String? _password = "";
  String? _firstName = "";
  String? _lastName = "";
  String? _avatarUrl = "";
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

  void handleSignUpButtonClicked(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
        _isDisabled = true;
      });

      _avatarUrl = "https://picsum.photos/200";

      context.read<RegistrationCubit>().signUp(
        email: _email!,
        password: _password!,
        firstName: _firstName!,
        avatarUrl: _avatarUrl,
        lastName: _lastName,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<RegistrationCubit>(),
      child: BlocConsumer<RegistrationCubit, RegistrationState>(
        listener: (context, state) {
          if (state is RegistrationLoading) {
            setState(() {
              _isDisabled = true;
            });
          } else if (state is RegistrationAwaitingVerification) {
            resetButtonState();
            Navigator.of(context).pushNamed(
              routes.verifyCode,
              arguments: {
                'email': state.serverSignUp.user.email,
                'shortToken': state.serverSignUp.shortToken,
              },
            );
          } else if (state is RegistrationError) {
            resetButtonState();
            ToastService.showError(state.message);
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
                        Image.asset(
                          "assets/images/ventura-logo.png",
                          height: 100,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const Text(
                          'Create an account',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: AuthField(
                                title: 'First name',
                                hintText: 'First name',
                                onSaved: (value) {
                                  setState(() {
                                    _firstName = value;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: AuthField(
                                title: 'Last name',
                                hintText: 'Last name',
                                onSaved: (value) {
                                  setState(() {
                                    _lastName = value;
                                  });
                                },
                              ),
                            ),
                          ],
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
                        const SizedBox(height: 15),
                        AuthField(
                          hintText: "Password",
                          title: "Password",
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
                        const SizedBox(height: 30),
                        SubmitFormButton(
                          title: "Create Account",
                          isLoading: _isLoading,
                          onPressed: () => handleSignUpButtonClicked(context),
                          isDisabled: _isDisabled,
                        ),
                        const SizedBox(height: 30),
                        InkWell(
                          onTap: () {
                            Navigator.of(
                              context,
                            ).popAndPushNamed(routes.signIn);
                          },
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text: "Already have an account? ",
                              style: Theme.of(context).textTheme.titleMedium,
                              children: [
                                TextSpan(
                                  text: "Sign In",
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                    Center(child: const Text('or')),
                    const SizedBox(height: 10),
                    SignInWithGoogle(title: 'Continue with Google'),
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
