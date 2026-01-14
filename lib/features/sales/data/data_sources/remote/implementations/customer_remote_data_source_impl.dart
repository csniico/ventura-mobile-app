import 'package:dio/dio.dart';
import 'package:ventura/config/app_logger.dart';
import 'package:ventura/config/server_routes.dart';
import 'package:ventura/features/sales/data/data_sources/remote/abstract_interfaces/customer_remote_data_source.dart';
import 'package:ventura/features/sales/data/models/customer_model.dart';

class CustomerRemoteDataSourceImpl implements CustomerRemoteDataSource {
  final Dio dio;
  final routes = ServerRoutes.instance;
  final logger = AppLogger('CustomerRemoteDataSourceImpl');

  CustomerRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<CustomerModel>?> getCustomers({
    required String businessId,
    int? page,
    int? limit,
  }) async {
    try {
      final response = await dio.get(
        '${routes.serverUrl}${routes.getCustomers}',
        queryParameters: {
          'businessId': businessId,
          'filter': 'many',
          'page': page ?? 1,
          'limit': limit ?? 10,
        },
      );
      logger.info(response.data.toString());
      final customersData = response.data['customers'] as List;
      return List<CustomerModel>.from(
        customersData.map((e) => CustomerModel.fromJson(e)),
      );
    } on DioException catch (e) {
      logger.error(e.response.toString());
      return null;
    }
  }

  @override
  Future<CustomerModel?> getCustomerById({
    required String customerId,
    required String businessId,
  }) async {
    try {
      final response = await dio.get(
        '${routes.serverUrl}${routes.getCustomers}',
        queryParameters: {
          'businessId': businessId,
          'filter': 'one',
          'customerId': customerId,
        },
      );
      logger.info(response.data.toString());
      return CustomerModel.fromJson(response.data);
    } on DioException catch (e) {
      logger.error(e.response.toString());
      return null;
    }
  }

  @override
  Future<CustomerModel?> createCustomer({
    required String businessId,
    required String name,
    String? email,
    String? phone,
    String? notes,
  }) async {
    try {
      final response = await dio.post(
        '${routes.serverUrl}${routes.createCustomer}',
        data: {
          'businessId': businessId,
          'name': name,
          if (email != null) 'email': email,
          if (phone != null) 'phone': phone,
          if (notes != null) 'notes': notes,
        },
      );
      logger.info(response.data.toString());
      return CustomerModel.fromJson(response.data);
    } on DioException catch (e) {
      logger.error(e.response.toString());
      return null;
    }
  }

  @override
  Future<CustomerModel?> updateCustomer({
    required String customerId,
    required String businessId,
    String? name,
    String? email,
    String? phone,
    String? notes,
  }) async {
    try {
      final response = await dio.put(
        '${routes.serverUrl}${routes.updateCustomer(customerId)}',
        queryParameters: {
          'businessId': businessId,
          if (name != null) 'name': name,
          if (email != null) 'email': email,
          if (phone != null) 'phone': phone,
          if (notes != null) 'notes': notes,
        },
      );
      logger.info(response.data.toString());
      return CustomerModel.fromJson(response.data);
    } on DioException catch (e) {
      logger.error(e.response.toString());
      return null;
    }
  }

  @override
  Future<String?> deleteCustomer({
    required String customerId,
    required String businessId,
  }) async {
    try {
      final response = await dio.delete(
        '${routes.serverUrl}${routes.deleteCustomer(customerId)}',
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
