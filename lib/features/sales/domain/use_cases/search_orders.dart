import 'package:fpdart/fpdart.dart' as fpdart;
import 'package:ventura/core/data/models/failure.dart';
import 'package:ventura/core/domain/use_cases/use_case.dart';
import 'package:ventura/features/sales/domain/repositories/order_repository.dart';

class SearchOrders
    implements UseCase<Map<String, dynamic>, SearchOrdersParams> {
  final OrderRepository orderRepository;

  SearchOrders({required this.orderRepository});

  @override
  Future<fpdart.Either<Failure, Map<String, dynamic>>> call(
    SearchOrdersParams params,
  ) async {
    return await orderRepository.searchOrders(
      businessId: params.businessId,
      searchQuery: params.searchQuery,
      startDate: params.startDate,
      endDate: params.endDate,
      minTotal: params.minTotal,
      maxTotal: params.maxTotal,
      page: params.page,
      limit: params.limit,
    );
  }
}

class SearchOrdersParams {
  final String businessId;
  final String searchQuery;
  final DateTime? startDate;
  final DateTime? endDate;
  final double? minTotal;
  final double? maxTotal;
  final int? page;
  final int? limit;

  SearchOrdersParams({
    required this.businessId,
    required this.searchQuery,
    this.startDate,
    this.endDate,
    this.minTotal,
    this.maxTotal,
    this.page,
    this.limit,
  });
}
