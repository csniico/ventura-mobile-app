part of 'order_bloc.dart';

@immutable
sealed class OrderState {}

final class OrderInitial extends OrderState {}

final class OrderLoadingState extends OrderState {}

final class OrderListLoadedState extends OrderState {
  final List<Order> orders;

  OrderListLoadedState({required this.orders});
}

final class OrderLoadedState extends OrderState {
  final Order order;

  OrderLoadedState({required this.order});
}

final class OrderSearchResultState extends OrderState {
  final Map<String, dynamic> searchResult;

  OrderSearchResultState({required this.searchResult});
}

final class OrderStatsLoadedState extends OrderState {
  final Map<String, dynamic> stats;

  OrderStatsLoadedState({required this.stats});
}

final class OrderCreateSuccessState extends OrderState {
  final Order order;

  OrderCreateSuccessState({required this.order});
}

final class OrderUpdateSuccessState extends OrderState {
  final Order order;

  OrderUpdateSuccessState({required this.order});
}

final class OrderErrorState extends OrderState {
  final String message;

  OrderErrorState({required this.message});
}
