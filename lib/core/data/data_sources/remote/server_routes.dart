import 'package:flutter_dotenv/flutter_dotenv.dart';

class ServerRoutes {
  ServerRoutes._internal();

  static final ServerRoutes instance = ServerRoutes._internal();

  late final String? serverUrl = dotenv.env['SERVER_URL'];
  final String signInWithEmailPassword = '/auth/signin';
  final String signInWithGoogle = '/auth/google/login/mobile';
  final String signUp = '/auth/signup';
  final String confirmEmail = '/auth/confirm-email';
  final String confirmVerificationCode = '/auth/verify-code';
  final String resetPassword = '/auth/reset-password';
  final String uploadImageAsset = '/assets/images';
  final String createBusiness = '/businesses';
}