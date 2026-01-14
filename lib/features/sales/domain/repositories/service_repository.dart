import 'package:fpdart/fpdart.dart' as fpdart;
import 'package:ventura/core/data/models/failure.dart';
import 'package:ventura/features/sales/domain/entities/service_entity.dart';

abstract interface class ServiceRepository {
  Future<fpdart.Either<Failure, Service>> getServiceById({
    required String serviceId,
    required String businessId,
  });

  Future<fpdart.Either<Failure, Service>> createService({
    required String businessId,
    required String name,
    required double price,
    String? primaryImage,
    List<String>? supportingImages,
    String? description,
    String? notes,
    Map<String, dynamic>? businessHours,
  });

  Future<fpdart.Either<Failure, Service>> updateService({
    required String serviceId,
    required String businessId,
    String? name,
    double? price,
    String? primaryImage,
    List<String>? supportingImages,
    String? description,
    String? notes,
    Map<String, dynamic>? businessHours,
  });

  Future<fpdart.Either<Failure, String>> deleteService({
    required String serviceId,
    required String businessId,
  });
}
