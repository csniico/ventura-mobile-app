import 'package:fpdart/fpdart.dart' as fpdart;
import 'package:ventura/core/data/models/failure.dart';
import 'package:ventura/core/domain/use_cases/use_case.dart';
import 'package:ventura/features/sales/domain/entities/service_entity.dart';
import 'package:ventura/features/sales/domain/repositories/service_repository.dart';

class GetServiceById implements UseCase<Service, GetServiceByIdParams> {
  final ServiceRepository serviceRepository;

  GetServiceById({required this.serviceRepository});

  @override
  Future<fpdart.Either<Failure, Service>> call(
    GetServiceByIdParams params,
  ) async {
    return await serviceRepository.getServiceById(
      serviceId: params.serviceId,
      businessId: params.businessId,
    );
  }
}

class GetServiceByIdParams {
  final String serviceId;
  final String businessId;

  GetServiceByIdParams({required this.serviceId, required this.businessId});
}
