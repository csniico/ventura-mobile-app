import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ventura/features/auth/presentation/bloc/auth_bloc.dart';

class SignInWithGoogle extends StatefulWidget {
  final String title;
  final AuthState state;

  const SignInWithGoogle({super.key, required this.title, required this.state});

  @override
  State<SignInWithGoogle> createState() => _SignInWithGoogleState();
}

class _SignInWithGoogleState extends State<SignInWithGoogle> {
  StreamSubscription<GoogleSignInAuthenticationEvent>? _authSubscription;

  final GoogleSignIn signIn = GoogleSignIn.instance;
  bool isLoading = false;

  String? serverUrl = dotenv.env['SERVER_URL'];
  String? clientId = dotenv.env['GOOGLE_CLIENT_ID'];
  String? serverClientId = dotenv.env['GOOGLE_SERVER_CLIENT_ID'];

  @override
  void initState() {
    super.initState();

    unawaited(
      signIn
          .initialize(clientId: clientId, serverClientId: serverClientId)
          .then((_) {
            _authSubscription = signIn.authenticationEvents.listen(
              _handleAuthEvent,
            );
          }),
    );
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

    context.read<AuthBloc>().add(
      AuthSignInWithGoogle(
        email: googleUser.email,
        googleId: googleUser.id,
        firstName: firstName,
        lastName: lastName,
        avatarUrl: googleUser.photoUrl,
      ),
    );
  }

  Future<void> continueWithGoogle() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    try {
      await signIn.authenticate(scopeHint: ['email', 'profile']);
    } on GoogleSignInException catch (e) {
      debugPrint("Google Sign-in Exception: $e");
    } catch (e) {
      debugPrint("Google Sign-in Error: $e");
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
        onPressed: isLoading || widget.state == AuthLoading()
            ? null
            : continueWithGoogle,
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
