import 'package:ventura/features/sales/data/models/service_model.dart';

abstract interface class ServiceRemoteDataSource {
  Future<ServiceModel?> getServiceById({
    required String serviceId,
    required String businessId,
  });

  Future<ServiceModel?> createService({
    required String businessId,
    required String name,
    required double price,
    String? primaryImage,
    List<String>? supportingImages,
    String? description,
    String? notes,
    Map<String, dynamic>? businessHours,
  });

  Future<ServiceModel?> updateService({
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

  Future<String?> deleteService({
    required String serviceId,
    required String businessId,
  });
}
