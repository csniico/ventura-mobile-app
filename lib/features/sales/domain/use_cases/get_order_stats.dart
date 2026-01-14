import 'package:fpdart/fpdart.dart' as fpdart;
import 'package:ventura/core/data/models/failure.dart';
import 'package:ventura/core/domain/use_cases/use_case.dart';
import 'package:ventura/features/sales/domain/repositories/order_repository.dart';

class GetOrderStats
    implements UseCase<Map<String, dynamic>, GetOrderStatsParams> {
  final OrderRepository orderRepository;

  GetOrderStats({required this.orderRepository});

  @override
  Future<fpdart.Either<Failure, Map<String, dynamic>>> call(
    GetOrderStatsParams params,
  ) async {
    return await orderRepository.getOrderStats(
      businessId: params.businessId,
      startDate: params.startDate,
      endDate: params.endDate,
    );
  }
}

class GetOrderStatsParams {
  final String businessId;
  final DateTime? startDate;
  final DateTime? endDate;

  GetOrderStatsParams({required this.businessId, this.startDate, this.endDate});
}
