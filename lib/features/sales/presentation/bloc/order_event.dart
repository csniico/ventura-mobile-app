part of 'order_bloc.dart';

@immutable
sealed class OrderEvent {}

final class OrderCreateEvent extends OrderEvent {
  final String businessId;
  final String customerId;
  final List<Map<String, dynamic>> items;

  OrderCreateEvent({
    required this.businessId,
    required this.customerId,
    required this.items,
  });
}

final class OrderGetListEvent extends OrderEvent {
  final String businessId;
  final String? status;
  final String? customerId;
  final int? page;
  final int? limit;

  OrderGetListEvent({
    required this.businessId,
    this.status,
    this.customerId,
    this.page,
    this.limit,
  });
}

final class OrderSearchEvent extends OrderEvent {
  final String businessId;
  final String searchQuery;
  final DateTime? startDate;
  final DateTime? endDate;
  final double? minTotal;
  final double? maxTotal;
  final int? page;
  final int? limit;

  OrderSearchEvent({
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

final class OrderGetStatsEvent extends OrderEvent {
  final String businessId;
  final DateTime? startDate;
  final DateTime? endDate;

  OrderGetStatsEvent({required this.businessId, this.startDate, this.endDate});
}

final class OrderGetCustomerOrdersEvent extends OrderEvent {
  final String customerId;
  final String businessId;
  final int? page;
  final int? limit;

  OrderGetCustomerOrdersEvent({
    required this.customerId,
    required this.businessId,
    this.page,
    this.limit,
  });
}

final class OrderGetByIdEvent extends OrderEvent {
  final String orderId;
  final String businessId;

  OrderGetByIdEvent({required this.orderId, required this.businessId});
}

final class OrderUpdateStatusEvent extends OrderEvent {
  final String orderId;
  final String businessId;
  final String status;

  OrderUpdateStatusEvent({
    required this.orderId,
    required this.businessId,
    required this.status,
  });
}
