import 'package:fpdart/fpdart.dart' as fpdart;
import 'package:ventura/core/data/models/failure.dart';
import 'package:ventura/core/domain/use_cases/use_case.dart';
import 'package:ventura/features/sales/domain/entities/order_entity.dart';
import 'package:ventura/features/sales/domain/repositories/order_repository.dart';

class GetOrderById implements UseCase<Order, GetOrderByIdParams> {
  final OrderRepository orderRepository;

  GetOrderById({required this.orderRepository});

  @override
  Future<fpdart.Either<Failure, Order>> call(GetOrderByIdParams params) async {
    return await orderRepository.getOrderById(
      orderId: params.orderId,
      businessId: params.businessId,
    );
  }
}

class GetOrderByIdParams {
  final String orderId;
  final String businessId;

  GetOrderByIdParams({required this.orderId, required this.businessId});
}
