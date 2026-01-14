import 'package:fpdart/fpdart.dart' as fpdart;
import 'package:ventura/config/app_logger.dart';
import 'package:ventura/core/data/models/failure.dart';
import 'package:ventura/features/sales/data/data_sources/remote/abstract_interfaces/service_remote_data_source.dart';
import 'package:ventura/features/sales/domain/entities/service_entity.dart';
import 'package:ventura/features/sales/domain/repositories/service_repository.dart';

class ServiceRepositoryImpl implements ServiceRepository {
  final ServiceRemoteDataSource serviceRemoteDataSource;
  final logger = AppLogger('ServiceRepositoryImpl');

  ServiceRepositoryImpl({required this.serviceRemoteDataSource});

  @override
  Future<fpdart.Either<Failure, Service>> getServiceById({
    required String serviceId,
    required String businessId,
  }) async {
    try {
      final service = await serviceRemoteDataSource.getServiceById(
        serviceId: serviceId,
        businessId: businessId,
      );
      if (service == null) {
        return fpdart.left(Failure('Service not found'));
      }
      return fpdart.right(service.toEntity());
    } catch (e) {
      logger.error('Error fetching service: $e');
      return fpdart.left(Failure('Failed to fetch service'));
    }
  }

  @override
  Future<fpdart.Either<Failure, Service>> createService({
    required String businessId,
    required String name,
    required double price,
    String? primaryImage,
    List<String>? supportingImages,
    String? description,
    String? notes,
    Map<String, dynamic>? businessHours,
  }) async {
    try {
      final service = await serviceRemoteDataSource.createService(
        businessId: businessId,
        name: name,
        price: price,
        primaryImage: primaryImage,
        supportingImages: supportingImages,
        description: description,
        notes: notes,
        businessHours: businessHours,
      );
      if (service == null) {
        return fpdart.left(Failure('Failed to create service'));
      }
      return fpdart.right(service.toEntity());
    } catch (e) {
      logger.error('Error creating service: $e');
      return fpdart.left(Failure('Failed to create service'));
    }
  }

  @override
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
  }) async {
    try {
      final service = await serviceRemoteDataSource.updateService(
        serviceId: serviceId,
        businessId: businessId,
        name: name,
        price: price,
        primaryImage: primaryImage,
        supportingImages: supportingImages,
        description: description,
        notes: notes,
        businessHours: businessHours,
      );
      if (service == null) {
        return fpdart.left(Failure('Failed to update service'));
      }
      return fpdart.right(service.toEntity());
    } catch (e) {
      logger.error('Error updating service: $e');
      return fpdart.left(Failure('Failed to update service'));
    }
  }

  @override
  Future<fpdart.Either<Failure, String>> deleteService({
    required String serviceId,
    required String businessId,
  }) async {
    try {
      final result = await serviceRemoteDataSource.deleteService(
        serviceId: serviceId,
        businessId: businessId,
      );
      if (result == null) {
        return fpdart.left(Failure('Failed to delete service'));
      }
      return fpdart.right(result);
    } catch (e) {
      logger.error('Error deleting service: $e');
      return fpdart.left(Failure('Failed to delete service'));
    }
  }
}
