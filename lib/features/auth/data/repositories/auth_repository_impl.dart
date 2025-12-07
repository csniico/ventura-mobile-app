import 'package:fpdart/fpdart.dart';
import 'package:ventura/core/models/failure/failure.dart';
import 'package:ventura/core/server_exception.dart';
import 'package:ventura/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:ventura/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;

  const AuthRepositoryImpl({required this.authRemoteDataSource});

  @override
  Future<Either<Failure, String>> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final user = await authRemoteDataSource.signInWithEmailPassword(
        email: email,
        password: password,
      );
      return right(user);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, String>> signInWithGoogle({
    required String email,
    required String googleId,
    required String firstName,
    String? lastName,
    String? avatarUrl,
  }) async {
    try {
      final user = await authRemoteDataSource.signInWithGoogle(
        googleId: googleId,
        email: email,
        firstName: firstName,
        lastName: lastName,
        avatarUrl: avatarUrl,
      );
      return right(user);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, String>> signUp({
    required String email,
    required String password,
    required String firstName,
    String? lastName,
    String? avatarUrl,
  }) async {
    try {
      final user = await authRemoteDataSource.signUp(
        email: email,
        firstName: firstName,
        password: password,
        lastName: lastName,
        avatarUrl: avatarUrl,
      );
      return right(user);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, String>> signOut() {
    // TODO: implement signOut
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, String>> getCurrentUser({required String uid}) {
    // TODO: implement getCurrentUser
    throw UnimplementedError();
  }
}
