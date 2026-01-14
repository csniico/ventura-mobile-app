import 'package:fpdart/fpdart.dart' as fpdart;
import 'package:ventura/core/data/models/failure.dart';
import 'package:ventura/core/domain/use_cases/use_case.dart';
import 'package:ventura/features/sales/domain/entities/order_entity.dart';
import 'package:ventura/features/sales/domain/repositories/order_repository.dart';

class CreateOrder implements UseCase<Order, CreateOrderParams> {
  final OrderRepository orderRepository;

  CreateOrder({required this.orderRepository});

  @override
  Future<fpdart.Either<Failure, Order>> call(CreateOrderParams params) async {
    return await orderRepository.createOrder(
      businessId: params.businessId,
      customerId: params.customerId,
      items: params.items,
    );
  }
}

class CreateOrderParams {
  final String businessId;
  final String customerId;
  final List<Map<String, dynamic>> items;

  CreateOrderParams({
    required this.businessId,
    required this.customerId,
    required this.items,
  });
}
