import 'package:fpdart/fpdart.dart';
import 'package:ventura/core/data/models/failure.dart';
import 'package:ventura/core/domain/entities/user_entity.dart';
import 'package:ventura/core/domain/repositories/user_repository.dart';
import 'package:ventura/core/domain/use_cases/use_case.dart';

class LocalSaveUser implements UseCase<User, UserParams> {
  final UserRepository userRepository;

  LocalSaveUser({required this.userRepository});
  @override
  Future<Either<Failure, User>> call(UserParams params) async {
    return await userRepository.localSaveUser(user: params.user);
  }
}