import 'package:fpdart/fpdart.dart';
import 'package:ventura/core/data/models/failure.dart';
import 'package:ventura/core/domain/entities/business_entity.dart';
import 'package:ventura/core/domain/use_cases/use_case.dart';
import 'package:ventura/features/auth/domain/repositories/auth_repository.dart';

class CreateBusinessProfile
    implements UseCase<Business, CreateBusinessProfileParams> {
  final AuthRepository authRepository;

  CreateBusinessProfile({required this.authRepository});

  @override
  Future<Either<Failure, Business>> call(
    CreateBusinessProfileParams params,
  ) async {
    return await authRepository.createBusinessProfile(
      business: params.business,
    );
  }
}

class CreateBusinessProfileParams {
  final Business business;

  CreateBusinessProfileParams({required this.business});
}
