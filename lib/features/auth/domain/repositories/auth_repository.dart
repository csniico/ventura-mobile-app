import 'package:fpdart/fpdart.dart';
import 'package:ventura/core/data/models/failure.dart';
import 'package:ventura/features/auth/domain/entities/server_sign_up.dart';
import 'package:ventura/core/domain/entities/user_entity.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, String>> signOut();

  Future<Either<Failure, User>> getCurrentUser({required String uid});

  Future<Either<Failure, User>> signInWithEmailPassword({
    required String email,
    required String password,
  });

  Future<Either<Failure, User>> signInWithGoogle({
    required String email,
    required String googleId,
    required String firstName,
    String? lastName,
    String? avatarUrl,
  });

  Future<Either<Failure, ServerSignUp>> signUp({
    required String email,
    required String password,
    required String firstName,
    String? lastName,
    String? avatarUrl,
  });

  Future<Either<Failure, User>> confirmVerificationCode({
    required String code,
    required String email,
    required String shortToken,
  });

}
