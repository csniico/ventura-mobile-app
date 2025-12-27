import 'package:fpdart/fpdart.dart';
import 'package:ventura/core/data/models/failure.dart';
import 'package:ventura/core/domain/entities/user_entity.dart';
import 'package:ventura/core/domain/repositories/user_repository.dart';
import 'package:ventura/core/domain/use_cases/use_case.dart';

class RemoteUpdateUserProfile
    implements UseCase<User, RemoteUpdateUserProfileParams> {
  final UserRepository userRepository;

  RemoteUpdateUserProfile({required this.userRepository});

  @override
  Future<Either<Failure, User>> call(
    RemoteUpdateUserProfileParams params,
  ) async {
    return await userRepository.updateUserProfile(
      userId: params.userId,
      firstName: params.firstName,
      lastName: params.lastName,
      avatarUrl: params.avatarUrl,
    );
  }
}

class RemoteUpdateUserProfileParams {
  final String firstName;
  final String userId;
  final String? lastName;
  final String? avatarUrl;

  RemoteUpdateUserProfileParams({
    required this.firstName,
    required this.userId,
    this.lastName,
    this.avatarUrl,
  });
}
