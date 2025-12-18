import 'package:fpdart/fpdart.dart';
import 'package:ventura/core/data/models/failure.dart';
import 'package:ventura/core/domain/use_cases/use_case.dart';
import 'package:ventura/core/domain/entities/user_entity.dart';
import 'package:ventura/features/auth/domain/repositories/auth_repository.dart';

class UserSignInWithGoogle
    implements UseCase<User, UserSignInWithGoogleParams> {
  final AuthRepository authRepository;

  UserSignInWithGoogle({required this.authRepository});

  @override
  Future<Either<Failure, User>> call(
    UserSignInWithGoogleParams params,
  ) async {
    return await authRepository.signInWithGoogle(
      email: params.email,
      googleId: params.googleId,
      firstName: params.firstName,
      lastName: params.lastName,
      avatarUrl: params.avatarUrl,
    );
  }
}

class UserSignInWithGoogleParams {
  final String email;
  final String firstName;
  final String googleId;
  String? lastName;
  String? avatarUrl;

  UserSignInWithGoogleParams({
    required this.email,
    required this.firstName,
    required this.googleId,
    this.lastName,
    this.avatarUrl,
  });
}
