import 'package:fpdart/fpdart.dart';
import 'package:ventura/core/data/models/failure.dart';
import 'package:ventura/core/domain/repositories/user_repository.dart';
import 'package:ventura/core/domain/use_cases/use_case.dart';

class LocalSignOut implements UseCase<void, NoParams> {
  final UserRepository userRepository;

  LocalSignOut({required this.userRepository});
  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    try {
      await userRepository.localSignOut();
      return right(null);
    } catch (error) {
      return left(Failure('Failed to sign out locally'));
    }
  }

}
