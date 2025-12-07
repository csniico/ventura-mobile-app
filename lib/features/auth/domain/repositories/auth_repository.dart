import 'package:fpdart/fpdart.dart';
import 'package:ventura/core/models/failure/failure.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, String>> signOut();

  Future<Either<Failure, String>> getCurrentUser({required String uid});

  Future<Either<Failure, String>> signInWithEmailPassword({
    required String email,
    required String password,
  });

  Future<Either<Failure, String>> signInWithGoogle({
    required String email,
    required String googleId,
    required String firstName,
    String? lastName,
    String? avatarUrl,
  });

  Future<Either<Failure, String>> signUp({
    required String email,
    required String password,
    required String firstName,
    String? lastName,
    String? avatarUrl,
  });
}
