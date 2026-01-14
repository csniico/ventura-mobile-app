import 'package:fpdart/fpdart.dart' as fpdart;
import 'package:ventura/core/data/models/failure.dart';
import 'package:ventura/core/domain/use_cases/use_case.dart';
import 'package:ventura/features/sales/domain/entities/order_entity.dart';
import 'package:ventura/features/sales/domain/repositories/order_repository.dart';

class GetCustomerOrders
    implements UseCase<List<Order>, GetCustomerOrdersParams> {
  final OrderRepository orderRepository;

  GetCustomerOrders({required this.orderRepository});

  @override
  Future<fpdart.Either<Failure, List<Order>>> call(
    GetCustomerOrdersParams params,
  ) async {
    return await orderRepository.getCustomerOrders(
      customerId: params.customerId,
      businessId: params.businessId,
      page: params.page,
      limit: params.limit,
    );
  }
}

class GetCustomerOrdersParams {
  final String customerId;
  final String businessId;
  final int? page;
  final int? limit;

  GetCustomerOrdersParams({
    required this.customerId,
    required this.businessId,
    this.page,
    this.limit,
  });
}
