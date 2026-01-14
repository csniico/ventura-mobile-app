import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ventura/core/services/toast_service.dart';
import 'package:ventura/core/services/user_service.dart';
import 'package:ventura/features/sales/domain/entities/order_status.dart';
import 'package:ventura/features/sales/presentation/bloc/order_bloc.dart';
import 'package:ventura/init_dependencies.dart';

class EditOrder extends StatefulWidget {
  const EditOrder({super.key, required this.orderId});
  final String orderId;

  @override
  State<EditOrder> createState() => _EditOrderState();
}

class _EditOrderState extends State<EditOrder> {
  OrderStatus? _selectedStatus;
  late String _businessId;
  bool _isLoading = true;
  late final OrderBloc _orderBloc;

  @override
  void initState() {
    super.initState();
    _orderBloc = serviceLocator<OrderBloc>();
    _loadOrderData();
  }

  Future<void> _loadOrderData() async {
    final user = await UserService().getUser();
    if (user != null && mounted) {
      setState(() {
        _businessId = user.businessId;
      });
      // Load order details
      _orderBloc.add(
        OrderGetByIdEvent(orderId: widget.orderId, businessId: _businessId),
      );
    }
  }

  @override
  void dispose() {
    _orderBloc.close();
    super.dispose();
  }

  void _updateOrderStatus() {
    if (_selectedStatus == null) {
      ToastService.showError('Please select a status');
      return;
    }

    _orderBloc.add(
      OrderUpdateStatusEvent(
        orderId: widget.orderId,
        businessId: _businessId,
        status: _selectedStatus!.name,
      ),
    );
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return Colors.orange;
      case OrderStatus.completed:
        return Colors.green;
      case OrderStatus.cancelled:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _orderBloc,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: const Text('Edit Order Status'),
          leading: IconButton(
            icon: HugeIcon(
              icon: HugeIcons.strokeRoundedArrowLeft01,
              color: Theme.of(context).iconTheme.color,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: BlocConsumer<OrderBloc, OrderState>(
          listener: (context, state) {
            if (state is OrderUpdateSuccessState) {
              ToastService.showSuccess('Order status updated successfully');
              Navigator.pop(context);
            } else if (state is OrderErrorState) {
              ToastService.showError(state.message);
            } else if (state is OrderLoadedState) {
              setState(() {
                _selectedStatus = state.order.status;
                _isLoading = false;
              });
            }
          },
          builder: (context, state) {
            final isUpdating = state is OrderLoadingState && !_isLoading;

            if (_isLoading && state is OrderLoadingState) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is OrderErrorState && _isLoading) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    HugeIcon(
                      icon: HugeIcons.strokeRoundedAlert02,
                      color: Theme.of(context).colorScheme.error,
                      size: 48,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error: ${state.message}',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Update Order Status',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Select a new status for this order',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                  ),
                  const SizedBox(height: 32),

                  // Status Options
                  ...OrderStatus.values.map((status) {
                    final isSelected = _selectedStatus == status;
                    return GestureDetector(
                      onTap: isUpdating
                          ? null
                          : () {
                              setState(() {
                                _selectedStatus = status;
                              });
                            },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? _getStatusColor(status).withOpacity(0.1)
                              : Theme.of(context).colorScheme.surface,
                          border: Border.all(
                            color: isSelected
                                ? _getStatusColor(status)
                                : Theme.of(
                                    context,
                                  ).colorScheme.outline.withOpacity(0.5),
                            width: isSelected ? 2 : 1,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSelected
                                      ? _getStatusColor(status)
                                      : Colors.grey,
                                  width: 2,
                                ),
                                color: isSelected
                                    ? _getStatusColor(status)
                                    : Colors.transparent,
                              ),
                              child: isSelected
                                  ? const Icon(
                                      Icons.check,
                                      size: 16,
                                      color: Colors.white,
                                    )
                                  : null,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    status.name.toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: isSelected
                                          ? _getStatusColor(status)
                                          : Theme.of(
                                              context,
                                            ).textTheme.bodyLarge?.color,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _getStatusDescription(status),
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: _getStatusColor(status).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                status.name,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: _getStatusColor(status),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),

                  const SizedBox(height: 32),

                  // Update Button
                  ElevatedButton(
                    onPressed: isUpdating ? null : _updateOrderStatus,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: isUpdating
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : const Text(
                            'Update Status',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  String _getStatusDescription(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 'Order is awaiting processing';
      case OrderStatus.completed:
        return 'Order has been fulfilled';
      case OrderStatus.cancelled:
        return 'Order has been cancelled';
    }
  }
}
