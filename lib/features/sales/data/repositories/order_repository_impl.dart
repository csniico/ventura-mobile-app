import 'package:fpdart/fpdart.dart' as fpdart;
import 'package:ventura/config/app_logger.dart';
import 'package:ventura/core/data/models/failure.dart';
import 'package:ventura/features/sales/data/data_sources/remote/abstract_interfaces/order_remote_data_source.dart';
import 'package:ventura/features/sales/domain/entities/order_entity.dart';
import 'package:ventura/features/sales/domain/repositories/order_repository.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource orderRemoteDataSource;
  final logger = AppLogger('OrderRepositoryImpl');

  OrderRepositoryImpl({required this.orderRemoteDataSource});

  @override
  Future<fpdart.Either<Failure, Order>> createOrder({
    required String businessId,
    required String customerId,
    required List<Map<String, dynamic>> items,
  }) async {
    try {
      final order = await orderRemoteDataSource.createOrder(
        businessId: businessId,
        customerId: customerId,
        items: items,
      );
      if (order == null) {
        return fpdart.left(Failure('Failed to create order'));
      }
      return fpdart.right(order.toEntity());
    } catch (e) {
      logger.error('Error creating order: $e');
      return fpdart.left(Failure('Failed to create order'));
    }
  }

  @override
  Future<fpdart.Either<Failure, List<Order>>> getOrders({
    required String businessId,
    String? status,
    String? customerId,
    int? page,
    int? limit,
  }) async {
    try {
      final orders = await orderRemoteDataSource.getOrders(
        businessId: businessId,
        status: status,
        customerId: customerId,
        page: page,
        limit: limit,
      );
      if (orders == null) {
        return fpdart.left(Failure('Failed to fetch orders'));
      }
      return fpdart.right(orders.map((model) => model.toEntity()).toList());
    } catch (e) {
      logger.error('Error fetching orders: $e');
      return fpdart.left(Failure('Failed to fetch orders'));
    }
  }

  @override
  Future<fpdart.Either<Failure, Map<String, dynamic>>> searchOrders({
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
      final result = await orderRemoteDataSource.searchOrders(
        businessId: businessId,
        searchQuery: searchQuery,
        startDate: startDate,
        endDate: endDate,
        minTotal: minTotal,
        maxTotal: maxTotal,
        page: page,
        limit: limit,
      );
      if (result == null) {
        return fpdart.left(Failure('Failed to search orders'));
      }
      return fpdart.right(result);
    } catch (e) {
      logger.error('Error searching orders: $e');
      return fpdart.left(Failure('Failed to search orders'));
    }
  }

  @override
  Future<fpdart.Either<Failure, Map<String, dynamic>>> getOrderStats({
    required String businessId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final result = await orderRemoteDataSource.getOrderStats(
        businessId: businessId,
        startDate: startDate,
        endDate: endDate,
      );
      if (result == null) {
        return fpdart.left(Failure('Failed to fetch order stats'));
      }
      return fpdart.right(result);
    } catch (e) {
      logger.error('Error fetching order stats: $e');
      return fpdart.left(Failure('Failed to fetch order stats'));
    }
  }

  @override
  Future<fpdart.Either<Failure, List<Order>>> getCustomerOrders({
    required String customerId,
    required String businessId,
    int? page,
    int? limit,
  }) async {
    try {
      final orders = await orderRemoteDataSource.getCustomerOrders(
        customerId: customerId,
        businessId: businessId,
        page: page,
        limit: limit,
      );
      if (orders == null) {
        return fpdart.left(Failure('Failed to fetch customer orders'));
      }
      return fpdart.right(orders.map((model) => model.toEntity()).toList());
    } catch (e) {
      logger.error('Error fetching customer orders: $e');
      return fpdart.left(Failure('Failed to fetch customer orders'));
    }
  }

  @override
  Future<fpdart.Either<Failure, Order>> getOrderById({
    required String orderId,
    required String businessId,
  }) async {
    try {
      final order = await orderRemoteDataSource.getOrderById(
        orderId: orderId,
        businessId: businessId,
      );
      if (order == null) {
        return fpdart.left(Failure('Order not found'));
      }
      return fpdart.right(order.toEntity());
    } catch (e) {
      logger.error('Error fetching order: $e');
      return fpdart.left(Failure('Failed to fetch order'));
    }
  }

  @override
  Future<fpdart.Either<Failure, Order>> updateOrderStatus({
    required String orderId,
    required String businessId,
    required String status,
  }) async {
    try {
      final order = await orderRemoteDataSource.updateOrderStatus(
        orderId: orderId,
        businessId: businessId,
        status: status,
      );
      if (order == null) {
        return fpdart.left(Failure('Failed to update order status'));
      }
      return fpdart.right(order.toEntity());
    } catch (e) {
      logger.error('Error updating order status: $e');
      return fpdart.left(Failure('Failed to update order status'));
    }
  }
}
