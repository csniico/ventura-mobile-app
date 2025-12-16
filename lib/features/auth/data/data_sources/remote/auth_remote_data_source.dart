import 'package:ventura/features/auth/data/models/confirm_email_model.dart';
import 'package:ventura/features/auth/data/models/server_sign_up_model.dart';
import 'package:ventura/core/data/models/user_model.dart';

abstract interface class AuthRemoteDataSource {
  Future<UserModel> signInWithEmailPassword({
    required String email,
    required String password,
  });

  Future<UserModel> signInWithGoogle({
    required String googleId,
    required String email,
    required String firstName,
    String? lastName,
    String? avatarUrl,
  });

  Future<ServerSignUpModel> signUp({
    required String email,
    required String firstName,
    required String password,
    String? lastName,
    String? avatarUrl,
  });

  Future<ConfirmEmailModel> confirmEmailForPasswordReset({
    required String email,
  });

  Future<UserModel> confirmVerificationCode({
    required String code,
    required String email,
    required String shortToken,
  });

  Future<void> signOut();
}
