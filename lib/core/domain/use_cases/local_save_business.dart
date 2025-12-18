import 'package:fpdart/fpdart.dart';
import 'package:ventura/core/data/models/failure.dart';
import 'package:ventura/core/domain/entities/business_entity.dart';
import 'package:ventura/core/domain/repositories/business_repository.dart';
import 'package:ventura/core/domain/use_cases/use_case.dart';

class LocalSaveBusiness implements UseCase<Business?, BusinessParams> {
  final BusinessRepository businessRepository;

  LocalSaveBusiness({required this.businessRepository});

  @override
  Future<Either<Failure, Business?>> call(BusinessParams params) async {
    return await businessRepository.localSaveBusiness(
      business: params.business,
    );
  }
}
