import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ventura/features/sales/domain/entities/order_entity.dart';
import 'package:ventura/features/sales/domain/use_cases/create_order.dart';
import 'package:ventura/features/sales/domain/use_cases/get_customer_orders.dart';
import 'package:ventura/features/sales/domain/use_cases/get_order_by_id.dart';
import 'package:ventura/features/sales/domain/use_cases/get_order_stats.dart';
import 'package:ventura/features/sales/domain/use_cases/get_orders.dart';
import 'package:ventura/features/sales/domain/use_cases/search_orders.dart';
import 'package:ventura/features/sales/domain/use_cases/update_order_status.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final CreateOrder _createOrder;
  final GetOrders _getOrders;
  final SearchOrders _searchOrders;
  final GetOrderStats _getOrderStats;
  final GetCustomerOrders _getCustomerOrders;
  final GetOrderById _getOrderById;
  final UpdateOrderStatus _updateOrderStatus;

  OrderBloc({
    required CreateOrder createOrder,
    required GetOrders getOrders,
    required SearchOrders searchOrders,
    required GetOrderStats getOrderStats,
    required GetCustomerOrders getCustomerOrders,
    required GetOrderById getOrderById,
    required UpdateOrderStatus updateOrderStatus,
  }) : _createOrder = createOrder,
       _getOrders = getOrders,
       _searchOrders = searchOrders,
       _getOrderStats = getOrderStats,
       _getCustomerOrders = getCustomerOrders,
       _getOrderById = getOrderById,
       _updateOrderStatus = updateOrderStatus,
       super(OrderInitial()) {
    on<OrderEvent>((event, emit) => emit(OrderLoadingState()));
    on<OrderCreateEvent>(_onOrderCreateEvent);
    on<OrderGetListEvent>(_onOrderGetListEvent);
    on<OrderSearchEvent>(_onOrderSearchEvent);
    on<OrderGetStatsEvent>(_onOrderGetStatsEvent);
    on<OrderGetCustomerOrdersEvent>(_onOrderGetCustomerOrdersEvent);
    on<OrderGetByIdEvent>(_onOrderGetByIdEvent);
    on<OrderUpdateStatusEvent>(_onOrderUpdateStatusEvent);
  }

  void _onOrderCreateEvent(
    OrderCreateEvent event,
    Emitter<OrderState> emit,
  ) async {
    final res = await _createOrder(
      CreateOrderParams(
        businessId: event.businessId,
        customerId: event.customerId,
        items: event.items,
      ),
    );

    res.fold(
      (failure) => emit(OrderErrorState(message: failure.message)),
      (order) => emit(OrderCreateSuccessState(order: order)),
    );
  }

  void _onOrderGetListEvent(
    OrderGetListEvent event,
    Emitter<OrderState> emit,
  ) async {
    final res = await _getOrders(
      GetOrdersParams(
        businessId: event.businessId,
        status: event.status,
        customerId: event.customerId,
        page: event.page,
        limit: event.limit,
      ),
    );

    res.fold(
      (failure) => emit(OrderErrorState(message: failure.message)),
      (orders) => emit(OrderListLoadedState(orders: orders)),
    );
  }

  void _onOrderSearchEvent(
    OrderSearchEvent event,
    Emitter<OrderState> emit,
  ) async {
    final res = await _searchOrders(
      SearchOrdersParams(
        businessId: event.businessId,
        searchQuery: event.searchQuery,
        startDate: event.startDate,
        endDate: event.endDate,
        minTotal: event.minTotal,
        maxTotal: event.maxTotal,
        page: event.page,
        limit: event.limit,
      ),
    );

    res.fold(
      (failure) => emit(OrderErrorState(message: failure.message)),
      (searchResult) =>
          emit(OrderSearchResultState(searchResult: searchResult)),
    );
  }

  void _onOrderGetStatsEvent(
    OrderGetStatsEvent event,
    Emitter<OrderState> emit,
  ) async {
    final res = await _getOrderStats(
      GetOrderStatsParams(
        businessId: event.businessId,
        startDate: event.startDate,
        endDate: event.endDate,
      ),
    );

    res.fold(
      (failure) => emit(OrderErrorState(message: failure.message)),
      (stats) => emit(OrderStatsLoadedState(stats: stats)),
    );
  }

  void _onOrderGetCustomerOrdersEvent(
    OrderGetCustomerOrdersEvent event,
    Emitter<OrderState> emit,
  ) async {
    final res = await _getCustomerOrders(
      GetCustomerOrdersParams(
        customerId: event.customerId,
        businessId: event.businessId,
        page: event.page,
        limit: event.limit,
      ),
    );

    res.fold(
      (failure) => emit(OrderErrorState(message: failure.message)),
      (orders) => emit(OrderListLoadedState(orders: orders)),
    );
  }

  void _onOrderGetByIdEvent(
    OrderGetByIdEvent event,
    Emitter<OrderState> emit,
  ) async {
    final res = await _getOrderById(
      GetOrderByIdParams(orderId: event.orderId, businessId: event.businessId),
    );

    res.fold(
      (failure) => emit(OrderErrorState(message: failure.message)),
      (order) => emit(OrderLoadedState(order: order)),
    );
  }

  void _onOrderUpdateStatusEvent(
    OrderUpdateStatusEvent event,
    Emitter<OrderState> emit,
  ) async {
    final res = await _updateOrderStatus(
      UpdateOrderStatusParams(
        orderId: event.orderId,
        businessId: event.businessId,
        status: event.status,
      ),
    );

    res.fold(
      (failure) => emit(OrderErrorState(message: failure.message)),
      (order) => emit(OrderUpdateSuccessState(order: order)),
    );
  }
}
