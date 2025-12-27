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
  final String createAppointment = '/appointments';
  final String getUserAppointments = '/appointments/user';
  final String getBusinessAppointments = '/appointments/business';

  String deleteAppointment(String appointmentId) =>
      '/appointments/$appointmentId';

  String updateGoogleCalendarEvent(String appointmentId) =>
      '/appointments/google-event/$appointmentId';

  String updateAppointment(String appointmentId) =>
      '/appointments/$appointmentId';

  String getUserById(String userId) => '/users/$userId';
  String updateUserProfile(String userId) => '/users/profile/$userId';
}
