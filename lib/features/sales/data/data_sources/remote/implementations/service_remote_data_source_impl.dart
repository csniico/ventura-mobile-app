import 'package:dio/dio.dart';
import 'package:ventura/config/app_logger.dart';
import 'package:ventura/config/server_routes.dart';
import 'package:ventura/features/sales/data/data_sources/remote/abstract_interfaces/service_remote_data_source.dart';
import 'package:ventura/features/sales/data/models/service_model.dart';

class ServiceRemoteDataSourceImpl implements ServiceRemoteDataSource {
  final Dio dio;
  final routes = ServerRoutes.instance;
  final logger = AppLogger('ServiceRemoteDataSourceImpl');

  ServiceRemoteDataSourceImpl({required this.dio});

  @override
  Future<ServiceModel?> getServiceById({
    required String serviceId,
    required String businessId,
  }) async {
    try {
      final response = await dio.get(
        '${routes.serverUrl}${routes.getResources}',
        queryParameters: {
          'businessId': businessId,
          'type': 'service',
          'filter': 'one',
          'resourceId': serviceId,
        },
      );
      logger.info(response.data.toString());
      return ServiceModel.fromJson(response.data);
    } on DioException catch (e) {
      logger.error(e.response.toString());
      return null;
    }
  }

  @override
  Future<ServiceModel?> createService({
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
      final response = await dio.post(
        '${routes.serverUrl}${routes.createService}',
        data: {
          'businessId': businessId,
          'name': name,
          'price': price,
          if (primaryImage != null) 'primaryImage': primaryImage,
          if (supportingImages != null) 'supportingImages': supportingImages,
          if (description != null) 'description': description,
          if (notes != null) 'notes': notes,
          if (businessHours != null) 'businessHours': businessHours,
        },
      );
      logger.info(response.data.toString());
      return ServiceModel.fromJson(response.data);
    } on DioException catch (e) {
      logger.error(e.response.toString());
      return null;
    }
  }

  @override
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
  }) async {
    try {
      final response = await dio.put(
        '${routes.serverUrl}${routes.updateService(serviceId)}',
        queryParameters: {'businessId': businessId},
        data: {
          if (name != null) 'name': name,
          if (price != null) 'price': price,
          if (primaryImage != null) 'primaryImage': primaryImage,
          if (supportingImages != null) 'supportingImages': supportingImages,
          if (description != null) 'description': description,
          if (notes != null) 'notes': notes,
          if (businessHours != null) 'businessHours': businessHours,
        },
      );
      logger.info(response.data.toString());
      return ServiceModel.fromJson(response.data);
    } on DioException catch (e) {
      logger.error(e.response.toString());
      return null;
    }
  }

  @override
  Future<String?> deleteService({
    required String serviceId,
    required String businessId,
  }) async {
    try {
      final response = await dio.delete(
        '${routes.serverUrl}${routes.deleteService(serviceId)}',
        queryParameters: {'businessId': businessId},
      );
      logger.info(response.data.toString());
      if (response.data is Map<String, dynamic>) {
        return response.data['message'] as String?;
      }
      return response.data as String?;
    } on DioException catch (e) {
      logger.error(e.response.toString());
      return null;
    }
  }
}
