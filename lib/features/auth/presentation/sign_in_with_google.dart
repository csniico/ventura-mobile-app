import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ventura/core/models/business/business.dart';
import 'package:ventura/core/models/user/user.dart';
import 'package:ventura/core/services/business/business_service.dart';
import 'package:ventura/core/services/user/user_service.dart';
import 'package:ventura/core/widgets/switch_business_component.dart';

class SignInWithGoogle extends StatefulWidget {
  const SignInWithGoogle({super.key});

  @override
  State<SignInWithGoogle> createState() => _SignInWithGoogleState();
}

class _SignInWithGoogleState extends State<SignInWithGoogle> {
  StreamSubscription<GoogleSignInAuthenticationEvent>? _authSubscription;
  GoogleSignInAccount? _currentUser;
  bool _isSyncing = false;

  late final Dio dio;
  final GoogleSignIn signIn = GoogleSignIn.instance;
  final UserService _userService = UserService();
  final BusinessService _businessService = BusinessService();
  bool isLoading = false;

  String? serverUrl = dotenv.env['SERVER_URL'];
  String? clientId = dotenv.env['GOOGLE_CLIENT_ID'];
  String? serverClientId = dotenv.env['GOOGLE_SERVER_CLIENT_ID'];

  @override
  void initState() {
    super.initState();
    dio = Dio();

    unawaited(
      signIn
          .initialize(clientId: clientId, serverClientId: serverClientId)
          .then((_) {
            _authSubscription = signIn.authenticationEvents.listen(
              _handleAuthEvent,
            );
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
    if (!mounted) return;

    if (!isLoading) setState(() => isLoading = true);
    try {
      if (event is GoogleSignInAuthenticationEventSignIn) {
        final user = event.user;
        if (mounted) {
          setState(() => _currentUser = user);
        }
        await _logUserIn(user).timeout(
          const Duration(seconds: 100),
          onTimeout: () {
            throw TimeoutException("Login timed out. Please try again later.");
          },
        );
      } else if (event is GoogleSignInAuthenticationEventSignOut) {
        if (mounted) {
          setState(() => _currentUser = null);
        }
      }
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      if (mounted) setState(() => isLoading = false);
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
        setState(() => _isSyncing = true);
        final syncedBusinesses = await _businessService.syncUserBusinesses(
          user,
        );
        debugPrint(
          "[WelcomeScreen] Synced businesses: ${syncedBusinesses.map((b) => b.name).toList()}",
        );
        setState(() {
          _isSyncing = false;
        });

        showModalBottomSheet(
          context: context,
          isDismissible: true,
          enableDrag: true,
          isScrollControlled: true,
          builder: (context) => Container(
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.white
                  : Colors.grey[900],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: FractionallySizedBox(
              widthFactor: 1,
              heightFactor: 0.9,
              child: SwitchBusinessComponent(
                businesses: syncedBusinesses,
                displayTitle: "Select Business",
                onBusinessSwitch: (Business business) {
                  Navigator.of(
                    context,
                  ).pushNamedAndRemoveUntil('/', (route) => false);
                },
              ),
            ),
          ),
        );

        // Pre-cache the user's avatar image
        if (user.avatarUrl != null && user.avatarUrl!.isNotEmpty) {
          precacheImage(NetworkImage(user.avatarUrl!), context);
        }
        // Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
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
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    try {
      await signIn.authenticate(scopeHint: ['email', 'profile']);
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
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
        onPressed: isLoading ? null : () => continueWithGoogle(),
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
                color: Colors.white,
              ),
            const SizedBox(width: 10),
            const Text(
              "Sign in with Google",
              style: TextStyle(
                color: Colors.white,
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
