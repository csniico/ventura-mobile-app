import 'package:fpdart/fpdart.dart' as fpdart;
import 'package:ventura/core/data/models/failure.dart';
import 'package:ventura/core/domain/use_cases/use_case.dart';
import 'package:ventura/features/sales/domain/entities/service_entity.dart';
import 'package:ventura/features/sales/domain/repositories/service_repository.dart';

class CreateService implements UseCase<Service, CreateServiceParams> {
  final ServiceRepository serviceRepository;

  CreateService({required this.serviceRepository});

  @override
  Future<fpdart.Either<Failure, Service>> call(
    CreateServiceParams params,
  ) async {
    return await serviceRepository.createService(
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

class CreateServiceParams {
  final String businessId;
  final String name;
  final double price;
  final String? primaryImage;
  final List<String>? supportingImages;
  final String? description;
  final String? notes;
  final Map<String, dynamic>? businessHours;

  CreateServiceParams({
    required this.businessId,
    required this.name,
    required this.price,
    this.primaryImage,
    this.supportingImages,
    this.description,
    this.notes,
    this.businessHours,
  });
}
