import 'package:fpdart/fpdart.dart' as fpdart;
import 'package:ventura/core/data/models/failure.dart';
import 'package:ventura/features/sales/domain/entities/order_entity.dart';

abstract interface class OrderRepository {
  Future<fpdart.Either<Failure, Order>> createOrder({
    required String businessId,
    required String customerId,
    required List<Map<String, dynamic>> items,
  });

  Future<fpdart.Either<Failure, List<Order>>> getOrders({
    required String businessId,
    String? status,
    String? customerId,
    int? page,
    int? limit,
  });

  Future<fpdart.Either<Failure, Map<String, dynamic>>> searchOrders({
    required String businessId,
    required String searchQuery,
    DateTime? startDate,
    DateTime? endDate,
    double? minTotal,
    double? maxTotal,
    int? page,
    int? limit,
  });

  Future<fpdart.Either<Failure, Map<String, dynamic>>> getOrderStats({
    required String businessId,
    DateTime? startDate,
    DateTime? endDate,
  });

  Future<fpdart.Either<Failure, List<Order>>> getCustomerOrders({
    required String customerId,
    required String businessId,
    int? page,
    int? limit,
  });

  Future<fpdart.Either<Failure, Order>> getOrderById({
    required String orderId,
    required String businessId,
  });

  Future<fpdart.Either<Failure, Order>> updateOrderStatus({
    required String orderId,
    required String businessId,
    required String status,
  });
}
