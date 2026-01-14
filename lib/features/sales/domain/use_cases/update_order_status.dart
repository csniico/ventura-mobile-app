import 'package:fpdart/fpdart.dart' as fpdart;
import 'package:ventura/core/data/models/failure.dart';
import 'package:ventura/core/domain/use_cases/use_case.dart';
import 'package:ventura/features/sales/domain/entities/order_entity.dart';
import 'package:ventura/features/sales/domain/repositories/order_repository.dart';

class UpdateOrderStatus implements UseCase<Order, UpdateOrderStatusParams> {
  final OrderRepository orderRepository;

  UpdateOrderStatus({required this.orderRepository});

  @override
  Future<fpdart.Either<Failure, Order>> call(
    UpdateOrderStatusParams params,
  ) async {
    return await orderRepository.updateOrderStatus(
      orderId: params.orderId,
      businessId: params.businessId,
      status: params.status,
    );
  }
}

class UpdateOrderStatusParams {
  final String orderId;
  final String businessId;
  final String status;

  UpdateOrderStatusParams({
    required this.orderId,
    required this.businessId,
    required this.status,
  });
}
