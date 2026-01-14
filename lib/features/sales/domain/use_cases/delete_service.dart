import 'package:fpdart/fpdart.dart' as fpdart;
import 'package:ventura/core/data/models/failure.dart';
import 'package:ventura/core/domain/use_cases/use_case.dart';
import 'package:ventura/features/sales/domain/repositories/service_repository.dart';

class DeleteService implements UseCase<String, DeleteServiceParams> {
  final ServiceRepository serviceRepository;

  DeleteService({required this.serviceRepository});

  @override
  Future<fpdart.Either<Failure, String>> call(
    DeleteServiceParams params,
  ) async {
    return await serviceRepository.deleteService(
      serviceId: params.serviceId,
      businessId: params.businessId,
    );
  }
}

class DeleteServiceParams {
  final String serviceId;
  final String businessId;

  DeleteServiceParams({required this.serviceId, required this.businessId});
}
