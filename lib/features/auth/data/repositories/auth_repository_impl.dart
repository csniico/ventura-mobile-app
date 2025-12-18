import 'package:fpdart/fpdart.dart';
import 'package:ventura/core/common/app_logger.dart';
import 'package:ventura/core/data/models/failure.dart';
import 'package:ventura/core/data/models/server_exception.dart';
import 'package:ventura/features/auth/data/data_sources/remote/auth_remote_data_source.dart';
import 'package:ventura/features/auth/data/models/confirm_email_model.dart';
import 'package:ventura/features/auth/domain/entities/server_sign_up.dart';
import 'package:ventura/core/domain/entities/user_entity.dart';
import 'package:ventura/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;
  final logger = AppLogger('AuthRepositoryImpl');

  AuthRepositoryImpl({required this.authRemoteDataSource});

  @override
  Future<Either<Failure, User>> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final user = await authRemoteDataSource.signInWithEmailPassword(
        email: email,
        password: password,
      );
      return right(user.toEntity());
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, User>> signInWithGoogle({
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
      return right(user.toEntity());
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, ServerSignUp>> signUp({
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
  Future<Either<Failure, User>> confirmVerificationCode({
    required String code,
    required String email,
    required String shortToken,
  }) async {
    try {
      final user = await authRemoteDataSource.confirmVerificationCode(
        code: code,
        email: email,
        shortToken: shortToken,
      );
      return right(user.toEntity());
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, ConfirmEmailModel>> confirmEmailForPasswordReset({
    required String email,
  }) async {
    try {
      final response = await authRemoteDataSource.confirmEmailForPasswordReset(
        email: email,
      );
      return right(response);
    } on ServerException catch (e) {
      logger.error(e.message);
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, User>> resetPassword({
    required String newPassword,
    required String userId,
  }) async {
    try {
      final response = await authRemoteDataSource.resetPassword(
        newPassword: newPassword,
        userId: userId,
      );
      return right(response);
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
  Future<Either<Failure, User>> getCurrentUser({required String uid}) {
    // TODO: implement getCurrentUser
    throw UnimplementedError();
  }
}
