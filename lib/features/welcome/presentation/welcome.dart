import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ventura/core/models/user/user.dart';
import 'package:ventura/core/services/user/user_service.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  StreamSubscription<GoogleSignInAuthenticationEvent>? _authSubscription;
  GoogleSignInAccount? _currentUser;

  final dio = Dio();
  final GoogleSignIn signIn = GoogleSignIn.instance;
  final UserService _userService = UserService();

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
            // Listen to auth events
            _authSubscription = signIn.authenticationEvents.listen(
              _handleAuthEvent,
            );

            // Attempt silent login
            signIn.attemptLightweightAuthentication();
          }),
    );
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }

  Future<void> _handleAuthEvent(GoogleSignInAuthenticationEvent event) async {
    if (event is GoogleSignInAuthenticationEventSignIn) {
      final user = event.user;
      if (mounted) {
        setState(() => _currentUser = user);
      }
      await _logUserIn(user);
    } else if (event is GoogleSignInAuthenticationEventSignOut) {
      if (mounted) {
        setState(() => _currentUser = null);
      }
    }
  }

  Future<void> _logUserIn(GoogleSignInAccount googleUser) async {
    try {
      final nameParts = googleUser.displayName?.split(' ') ?? ['', ''];
      final firstName = nameParts.isNotEmpty ? nameParts.first : '';
      final lastName = nameParts.length > 1
          ? nameParts.sublist(1).join(' ')
          : '';

      var response = await dio.post(
        "$serverUrl/auth/mobile/signin",
        data: {
          'email': googleUser.email,
          'firstName': firstName,
          'lastName': lastName,
          'googleId': googleUser.id,
          'avatarUrl': googleUser.photoUrl,
        },
      );

      final user = User.fromJson(response.data);
      await _userService.saveUser(user);

      if (mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
      }
    } on DioException catch (e) {
      if (e.response != null) {
        debugPrint("Error response: ${e.response?.data}");
      } else {
        debugPrint("Error sending request: ${e.message}");
      }
    }
  }

  Future<void> continueWithGoogle() async {
    try {
      await signIn.authenticate(scopeHint: ['email', 'profile']);
    } catch (e) {
      debugPrint("Google Sign-in Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = _currentUser;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (user == null) ...[
                const Text("Ventura", style: TextStyle(fontSize: 24)),
                const SizedBox(height: 40),
                TextButton(
                  onPressed: continueWithGoogle,
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  child: const Text("Continue with Google"),
                ),
                const SizedBox(height: 20),
              ],

              if (user != null) ...[
                CircleAvatar(
                  backgroundImage: NetworkImage(user.photoUrl!),
                  radius: 30,
                ),
                const SizedBox(height: 10),
                Text(user.displayName ?? ""),
                Text(user.email),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
