import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ventura/core/models/user/user.dart';
import 'package:ventura/core/providers/user_provider.dart';
import 'package:ventura/core/services/toast/toast_service.dart';
import 'package:ventura/features/auth/presentation/widgets/auth_field.dart';
import 'package:ventura/features/auth/presentation/widgets/sign_in_with_google.dart';
import 'package:ventura/features/auth/presentation/widgets/submit_form_button.dart';

class SignInForm extends ConsumerStatefulWidget {
  const SignInForm({super.key});

  @override
  ConsumerState<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends ConsumerState<SignInForm> {
  final _formKey = GlobalKey<FormState>();
  Dio dio = Dio();
  String? serverUrl = dotenv.env['SERVER_URL'];
  String? _email = "";
  String? _password = "";
  bool _obscurePassword = true;
  bool _isLoading = false;
  bool _isDisabled = false;

  void _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
        _isDisabled = true;
      });

      final userNotifier = ref.read(userProvider.notifier);

      debugPrint("Email: $_email, Password: $_password");
      debugPrint("Server URL: $serverUrl");

      try {
        var response = await dio.post(
          '$serverUrl/auth/signin',
          data: {'email': _email, 'password': _password},
        );
        debugPrint("Response: $response");
        final user = User.fromJson(response.data);
        await userNotifier.saveUser(user);
        if (response.statusCode == 200) {
          ToastService.showSuccess("Sign In Successful");
        }
      } on DioException catch (e) {
        debugPrint("Error: $e");
        if (e.response != null) {
          ToastService.showError("${e.response!.data['message']}");
          debugPrint("Error Response: ${e.response!.data}");
        } else {
          debugPrint("Error: ${e.message}");
        }
      } finally {
        setState(() {
          _isLoading = false;
          _isDisabled = false;
        });
      }

      // if (mounted) {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(content: Text('Processing Sign In for $_email')),
      //   );
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
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
                    title: "Sign In",
                    isLoading: _isLoading,
                    onPressed: _handleSubmit,
                    isDisabled: _isDisabled,
                  ),
                  const SizedBox(height: 30),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: "Don't have an account? ",
                      style: Theme.of(context).textTheme.titleMedium,
                      children: [
                        TextSpan(
                          text: "Sign Up",
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),

              SignInWithGoogle(),
            ],
          ),
        ),
      ),
    );
  }
}
