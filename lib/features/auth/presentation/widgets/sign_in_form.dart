import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ventura/config/routes.dart';
import 'package:ventura/core/services/toast_service.dart';
import 'package:ventura/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ventura/features/auth/presentation/cubit/login_cubit.dart';
import 'package:ventura/init_dependencies.dart';
import 'package:ventura/features/auth/presentation/widgets/auth_field.dart';
import 'package:ventura/features/auth/presentation/widgets/sign_in_with_google.dart';
import 'package:ventura/features/auth/presentation/widgets/submit_form_button.dart';
import 'package:ventura/features/auth/presentation/widgets/verify_email_form.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final routes = AppRoutes.instance;
  final _formKey = GlobalKey<FormState>();
  String? serverUrl = dotenv.env['SERVER_URL'];
  String? _email = "";
  String? _password = "";
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
      context.read<LoginCubit>().signIn(email: _email!, password: _password!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<LoginCubit>(),
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginLoading) {
            setState(() {
              _isDisabled = true;
            });
          } else if (state is LoginError) {
            resetButtonState();
            ToastService.showError(state.message);
          } else if (state is LoginSuccess) {
            resetButtonState();
            // Update AuthBloc session
            context.read<AuthBloc>().add(AuthSessionUpdated(state.user));
            // Navigation handled by App widget
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
                          "assets/images/icon.png",
                          height: 100,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const Text(
                          'Sign In',
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
                        const SizedBox(height: 10),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => VerifyEmailForm(),
                              ),
                            );
                          },
                          child: RichText(
                            textAlign: TextAlign.right,
                            text: TextSpan(
                              text: "Forgot your password?",
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        SubmitFormButton(
                          title: "Sign In",
                          isLoading: _isLoading,
                          onPressed: _handleSubmit,
                          isDisabled: _isDisabled,
                        ),
                        const SizedBox(height: 30),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pushNamed(routes.signUp);
                          },
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text: "Don't have an account? ",
                              style: Theme.of(context).textTheme.titleMedium,
                              children: [
                                TextSpan(
                                  text: "Sign Up",
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
