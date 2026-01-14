import 'package:dio/dio.dart';
import 'package:ventura/config/app_logger.dart';
import 'package:ventura/config/server_routes.dart';
import 'package:ventura/features/sales/data/data_sources/remote/abstract_interfaces/order_remote_data_source.dart';
import 'package:ventura/features/sales/data/models/order_model.dart';

class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  final Dio dio;
  final routes = ServerRoutes.instance;
  final logger = AppLogger('OrderRemoteDataSourceImpl');

  OrderRemoteDataSourceImpl({required this.dio});

  @override
  Future<OrderModel?> createOrder({
    required String businessId,
    required String customerId,
    required List<Map<String, dynamic>> items,
  }) async {
    try {
      final response = await dio.post(
        '${routes.serverUrl}${routes.createOrder}',
        data: {
          'businessId': businessId,
          'customerId': customerId,
          'items': items,
        },
      );
      logger.info(response.data.toString());
      return OrderModel.fromJson(response.data);
    } on DioException catch (e) {
      logger.error(e.response.toString());
      return null;
    }
  }

  @override
  Future<List<OrderModel>?> getOrders({
    required String businessId,
    String? status,
    String? customerId,
    int? page,
    int? limit,
  }) async {
    try {
      final response = await dio.get(
        '${routes.serverUrl}${routes.getOrders}',
        queryParameters: {
          'businessId': businessId,
          if (status != null) 'status': status,
          if (customerId != null) 'customerId': customerId,
          'page': page ?? 1,
          'limit': limit ?? 10,
        },
      );
      logger.info(response.data.toString());
      final ordersData = response.data['data'] as List;
      return List<OrderModel>.from(
        ordersData.map((e) => OrderModel.fromJson(e)),
      );
    } on DioException catch (e) {
      logger.error(e.response.toString());
      return null;
    }
  }

  @override
  Future<Map<String, dynamic>?> searchOrders({
    required String businessId,
    required String searchQuery,
    DateTime? startDate,
    DateTime? endDate,
    double? minTotal,
    double? maxTotal,
    int? page,
    int? limit,
  }) async {
    try {
      final response = await dio.get(
        '${routes.serverUrl}${routes.searchOrders}',
        queryParameters: {
          'businessId': businessId,
          'q': searchQuery,
          'filters':
              (startDate != null ||
                  endDate != null ||
                  minTotal != null ||
                  maxTotal != null)
              ? 'on'
              : 'off',
          if (startDate != null) 'startDate': startDate.toIso8601String(),
          if (endDate != null) 'endDate': endDate.toIso8601String(),
          if (minTotal != null) 'minTotal': minTotal,
          if (maxTotal != null) 'maxTotal': maxTotal,
          'page': page ?? 1,
          'limit': limit ?? 10,
        },
      );
      logger.info(response.data.toString());
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      logger.error(e.response.toString());
      return null;
    }
  }

  @override
  Future<Map<String, dynamic>?> getOrderStats({
    required String businessId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final response = await dio.get(
        '${routes.serverUrl}${routes.getOrderStats}',
        queryParameters: {
          'businessId': businessId,
          if (startDate != null) 'startDate': startDate.toIso8601String(),
          if (endDate != null) 'endDate': endDate.toIso8601String(),
        },
      );
      logger.info(response.data.toString());
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      logger.error(e.response.toString());
      return null;
    }
  }

  @override
  Future<List<OrderModel>?> getCustomerOrders({
    required String customerId,
    required String businessId,
    int? page,
    int? limit,
  }) async {
    try {
      final response = await dio.get(
        '${routes.serverUrl}${routes.getCustomerOrders(customerId)}',
        queryParameters: {
          'businessId': businessId,
          'page': page ?? 1,
          'limit': limit ?? 10,
        },
      );
      logger.info(response.data.toString());
      final ordersData = response.data['data'] as List;
      return List<OrderModel>.from(
        ordersData.map((e) => OrderModel.fromJson(e)),
      );
    } on DioException catch (e) {
      logger.error(e.response.toString());
      return null;
    }
  }

  @override
  Future<OrderModel?> getOrderById({
    required String orderId,
    required String businessId,
  }) async {
    try {
      final response = await dio.get(
        '${routes.serverUrl}${routes.getOrderById(orderId)}',
        queryParameters: {'businessId': businessId},
      );
      logger.info(response.data.toString());
      return OrderModel.fromJson(response.data);
    } on DioException catch (e) {
      logger.error(e.response.toString());
      return null;
    }
  }

  @override
  Future<OrderModel?> updateOrderStatus({
    required String orderId,
    required String businessId,
    required String status,
  }) async {
    try {
      final response = await dio.patch(
        '${routes.serverUrl}${routes.updateOrderStatus(orderId)}',
        queryParameters: {'businessId': businessId},
        data: {'status': status},
      );
      logger.info(response.data.toString());
      return OrderModel.fromJson(response.data);
    } on DioException catch (e) {
      logger.error(e.response.toString());
      return null;
    }
  }
}
