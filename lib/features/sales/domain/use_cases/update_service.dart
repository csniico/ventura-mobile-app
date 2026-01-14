import 'package:fpdart/fpdart.dart' as fpdart;
import 'package:ventura/core/data/models/failure.dart';
import 'package:ventura/core/domain/use_cases/use_case.dart';
import 'package:ventura/features/sales/domain/entities/service_entity.dart';
import 'package:ventura/features/sales/domain/repositories/service_repository.dart';

class UpdateService implements UseCase<Service, UpdateServiceParams> {
  final ServiceRepository serviceRepository;

  UpdateService({required this.serviceRepository});

  @override
  Future<fpdart.Either<Failure, Service>> call(
    UpdateServiceParams params,
  ) async {
    return await serviceRepository.updateService(
      serviceId: params.serviceId,
      businessId: params.businessId,
      name: params.name,
      price: params.price,
      primaryImage: params.primaryImage,
      supportingImages: params.supportingImages,
      description: params.description,
      notes: params.notes,
      businessHours: params.businessHours,
    );
  }
}

class UpdateServiceParams {
  final String serviceId;
  final String businessId;
  final String? name;
  final double? price;
  final String? primaryImage;
  final List<String>? supportingImages;
  final String? description;
  final String? notes;
  final Map<String, dynamic>? businessHours;

  UpdateServiceParams({
    required this.serviceId,
    required this.businessId,
    this.name,
    this.price,
    this.primaryImage,
    this.supportingImages,
    this.description,
    this.notes,
    this.businessHours,
  });
}
