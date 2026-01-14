import 'package:fpdart/fpdart.dart' as fpdart;
import 'package:ventura/core/data/models/failure.dart';
import 'package:ventura/core/domain/use_cases/use_case.dart';
import 'package:ventura/features/sales/domain/entities/order_entity.dart';
import 'package:ventura/features/sales/domain/repositories/order_repository.dart';

class GetOrders implements UseCase<List<Order>, GetOrdersParams> {
  final OrderRepository orderRepository;

  GetOrders({required this.orderRepository});

  @override
  Future<fpdart.Either<Failure, List<Order>>> call(
    GetOrdersParams params,
  ) async {
    return await orderRepository.getOrders(
      businessId: params.businessId,
      status: params.status,
      customerId: params.customerId,
      page: params.page,
      limit: params.limit,
    );
  }
}

class GetOrdersParams {
  final String businessId;
  final String? status;
  final String? customerId;
  final int? page;
  final int? limit;

  GetOrdersParams({
    required this.businessId,
    this.status,
    this.customerId,
    this.page,
    this.limit,
  });
}
