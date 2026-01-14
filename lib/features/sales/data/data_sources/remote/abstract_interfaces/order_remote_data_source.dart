import 'package:ventura/features/sales/data/models/order_model.dart';

abstract interface class OrderRemoteDataSource {
  Future<OrderModel?> createOrder({
    required String businessId,
    required String customerId,
    required List<Map<String, dynamic>> items,
  });

  Future<List<OrderModel>?> getOrders({
    required String businessId,
    String? status,
    String? customerId,
    int? page,
    int? limit,
  });

  Future<Map<String, dynamic>?> searchOrders({
    required String businessId,
    required String searchQuery,
    DateTime? startDate,
    DateTime? endDate,
    double? minTotal,
    double? maxTotal,
    int? page,
    int? limit,
  });

  Future<Map<String, dynamic>?> getOrderStats({
    required String businessId,
    DateTime? startDate,
    DateTime? endDate,
  });

  Future<List<OrderModel>?> getCustomerOrders({
    required String customerId,
    required String businessId,
    int? page,
    int? limit,
  });

  Future<OrderModel?> getOrderById({
    required String orderId,
    required String businessId,
  });

  Future<OrderModel?> updateOrderStatus({
    required String orderId,
    required String businessId,
    required String status,
  });
}
