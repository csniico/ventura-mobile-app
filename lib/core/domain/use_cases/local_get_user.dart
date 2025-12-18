import 'package:fpdart/fpdart.dart';
import 'package:ventura/core/data/models/failure.dart';
import 'package:ventura/core/domain/entities/user_entity.dart';
import 'package:ventura/core/domain/repositories/user_repository.dart';
import 'package:ventura/core/domain/use_cases/use_case.dart';

class LocalGetUser implements UseCase<User?, NoParams> {
  final UserRepository userRepository;

  LocalGetUser({required this.userRepository});

  @override
  Future<Either<Failure, User?>> call(NoParams params) async {
    return await userRepository.localGetUser();
  }
}