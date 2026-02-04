import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ventura/core/services/toast_service.dart';
import 'package:ventura/features/auth/presentation/cubit/login_cubit.dart';

class SignInWithGoogle extends StatefulWidget {
  final String title;

  const SignInWithGoogle({super.key, required this.title});

  @override
  State<SignInWithGoogle> createState() => _SignInWithGoogleState();
}

class _SignInWithGoogleState extends State<SignInWithGoogle> {
  StreamSubscription<GoogleSignInAuthenticationEvent>? _authSubscription;

  final GoogleSignIn signIn = GoogleSignIn.instance;
  bool isLoading = false;
  bool _isInitialized = false;

  String? serverUrl = dotenv.env['SERVER_URL'];
  String? clientId = dotenv.env['GOOGLE_CLIENT_ID'];
  String? serverClientId = dotenv.env['GOOGLE_SERVER_CLIENT_ID'];

  @override
  void initState() {
    super.initState();
    _initializeGoogleSignIn();
  }

  Future<void> _initializeGoogleSignIn() async {
    try {
      await signIn.initialize(
        clientId: clientId,
        serverClientId: serverClientId,
      );

      _authSubscription = signIn.authenticationEvents.listen(_handleAuthEvent);

      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      debugPrint("Google Sign-In initialization error: $e");
    }
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }

  Future<void> _handleAuthEvent(GoogleSignInAuthenticationEvent event) async {
    if (!mounted) return;

    if (!isLoading) setState(() => isLoading = true);
    try {
      if (event is GoogleSignInAuthenticationEventSignIn) {
        final user = event.user;

        await _logUserIn(user).timeout(
          const Duration(seconds: 100),
          onTimeout: () {
            throw TimeoutException("Login timed out. Please try again later.");
          },
        );
      } else if (event is GoogleSignInAuthenticationEventSignOut) {}
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> _logUserIn(GoogleSignInAccount googleUser) async {
    final nameParts = googleUser.displayName?.split(' ') ?? ['', ''];
    final firstName = nameParts.isNotEmpty ? nameParts.first : '';
    final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

    context.read<LoginCubit>().signInWithGoogle(
      email: googleUser.email,
      googleId: googleUser.id,
      firstName: firstName,
      lastName: lastName,
      avatarUrl: googleUser.photoUrl,
    );
  }

  Future<void> continueWithGoogle() async {
    if (!_isInitialized) {
      debugPrint("Google Sign-In not yet initialized");
      return;
    }

    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    try {
      await signIn.authenticate(scopeHint: ['email', 'profile']);
    } on GoogleSignInException catch (e) {
      debugPrint(
        "GoogleSignInException: code=${e.code}, description=${e.description}",
      );

      // Handle cancellation silently
      if (e.code == GoogleSignInExceptionCode.canceled) {
        debugPrint("User cancelled Google Sign-in");
        return;
      }

      // Show error for other exceptions
      if (mounted) {
        ToastService.showError(
          'Sign-in failed: ${e.description ?? e.toString()}',
        );
      }
    } catch (e) {
      debugPrint("Google Sign-in Error: $e");
      if (mounted) {
        ToastService.showError('An unexpected error occurred');
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          elevation: 0,
          side: BorderSide(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey[700]!
                : Colors.grey[500]!,
            width: 1,
          ),
          splashFactory: NoSplash.splashFactory,
        ),
        onPressed: isLoading || !_isInitialized ? null : continueWithGoogle,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            else
              Image.asset(
                "assets/images/google.png",
                height: 20,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
              ),
            const SizedBox(width: 10),
            Text(
              widget.title,
              style: TextStyle(
                color: Theme.brightnessOf(context) == Brightness.dark
                    ? Colors.white
                    : Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
