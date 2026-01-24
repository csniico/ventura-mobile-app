import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ventura/core/services/toast_service.dart';
import 'package:ventura/core/services/user_service.dart';
import 'package:ventura/features/sales/domain/entities/order_entity.dart';
import 'package:ventura/features/sales/domain/entities/order_status.dart';
import 'package:ventura/features/sales/presentation/bloc/order_bloc.dart';
import 'package:ventura/features/sales/presentation/bloc/invoice_bloc.dart';
import 'package:ventura/features/sales/presentation/pages/view_invoice.dart';
import 'package:ventura/features/sales/presentation/widgets/date_picker_component.dart';
import 'package:ventura/init_dependencies.dart';

class EditOrder extends StatefulWidget {
  const EditOrder({super.key, required this.order});
  final Order order;

  @override
  State<EditOrder> createState() => _EditOrderState();
}

class _EditOrderState extends State<EditOrder> {
  OrderStatus? _selectedStatus;
  late String _businessId;
  late final OrderBloc _orderBloc;
  late final InvoiceBloc _invoiceBloc;
  bool _isCreatingInvoice = false;
  bool _isRepeatingOrder = false;
  DateTime? _invoiceDueDate;

  @override
  void initState() {
    super.initState();
    _orderBloc = serviceLocator<OrderBloc>();
    _invoiceBloc = serviceLocator<InvoiceBloc>();
    _selectedStatus = widget.order.status;
    _loadBusinessId();
  }

  Future<void> _loadBusinessId() async {
    final user = await UserService().getUser();
    if (user != null && mounted) {
      setState(() {
        _businessId = user.businessId;
      });
    }
  }

  @override
  void dispose() {
    _orderBloc.close();
    _invoiceBloc.close();
    super.dispose();
  }

  void _updateOrderStatus() {
    if (_selectedStatus == null) {
      ToastService.showError('Please select a status');
      return;
    }

    _orderBloc.add(
      OrderUpdateStatusEvent(
        orderId: widget.order.id,
        businessId: _businessId,
        status: _selectedStatus!.name,
      ),
    );
  }

  Future<void> _createInvoice() async {
    final customerId = widget.order.customerId;
    if (customerId == null || customerId.isEmpty) {
      ToastService.showError('Order has no customer to bill');
      return;
    }

    if (_businessId.isEmpty) {
      ToastService.showError('Business not loaded yet. Please try again.');
      return;
    }

    await _openInvoiceDueDateSheet(customerId);
  }

  Future<void> _openInvoiceDueDateSheet(String customerId) async {
    final pickedDate = await DatePickerComponent.showDatePickerBottomSheet(
      context: context,
      initialDate:
          _invoiceDueDate ?? DateTime.now().add(const Duration(days: 30)),
      firstDay: DateTime.now(),
      lastDay: DateTime.now().add(const Duration(days: 365)),
      title: 'Select invoice due date',
      description: 'Choose when this invoice should be paid.',
    );

    if (pickedDate == null) return;

    setState(() => _invoiceDueDate = pickedDate);

    _invoiceBloc.add(
      InvoiceCreateEvent(
        businessId: _businessId,
        customerId: customerId,
        orderIds: [widget.order.id],
        dueDate: pickedDate,
      ),
    );
  }

  void _repeatOrder() {
    final customerId = widget.order.customerId;
    if (customerId == null || customerId.isEmpty) {
      ToastService.showError('Order has no customer to bill');
      return;
    }

    if (_businessId.isEmpty) {
      ToastService.showError('Business not loaded yet. Please try again.');
      return;
    }

    final itemsPayload = widget.order.items.map((item) {
      return {
        'itemType': item.itemType.toJson(),
        'name': item.name,
        'price': item.price,
        'quantity': item.quantity,
        if (item.product?.id != null) 'productId': item.product!.id,
        if (item.service?.id != null) 'serviceId': item.service!.id,
      };
    }).toList();

    setState(() => _isRepeatingOrder = true);

    _orderBloc.add(
      OrderCreateEvent(
        businessId: _businessId,
        customerId: customerId,
        items: itemsPayload,
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

  String _getStatusDetailedInfo(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 'This order is currently waiting to be processed. The customer has placed the order but it hasn\'t been fulfilled yet. Use this status for new orders or orders that are being prepared.';
      case OrderStatus.completed:
        return 'Mark this order as completed when it has been successfully fulfilled and delivered to the customer. This indicates the order lifecycle is complete.';
      case OrderStatus.cancelled:
        return 'Use this status when an order needs to be cancelled. This could be due to customer request, inventory issues, or any other reason that prevents fulfillment. This action is typically final.';
    }
  }

  bool get _canEditOrder {
    return widget.order.status != OrderStatus.completed &&
        widget.order.status != OrderStatus.cancelled;
  }

  void _showConfirmationSheet(BuildContext context) {
    if (_selectedStatus == null) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Confirm Status Update',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Are you sure you want to change the order status to ${_selectedStatus!.name.toUpperCase()}?',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _updateOrderStatus();
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: _getStatusColor(_selectedStatus!),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Confirm',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<OrderBloc>.value(value: _orderBloc),
        BlocProvider<InvoiceBloc>.value(value: _invoiceBloc),
      ],
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(8.0),
            child: const SizedBox(height: 8.0),
          ),
          title: Text(
            'Update Order Status',
            style: TextStyle(
              fontSize: 20,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          leading: IconButton(
            icon: HugeIcon(
              icon: HugeIcons.strokeRoundedArrowLeft01,
              color: Theme.of(context).colorScheme.onPrimary,
              size: 30,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: MultiBlocListener(
          listeners: [
            BlocListener<OrderBloc, OrderState>(
              listener: (context, state) {
                if (state is OrderCreateSuccessState) {
                  setState(() => _isRepeatingOrder = false);
                  ToastService.showSuccess('Order repeated successfully');
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => EditOrder(order: state.order),
                    ),
                  );
                } else if (state is OrderUpdateSuccessState) {
                  ToastService.showSuccess('Order status updated successfully');
                  Navigator.pop(context, state.order);
                } else if (state is OrderErrorState) {
                  setState(() => _isRepeatingOrder = false);
                  ToastService.showError(state.message);
                }
              },
            ),
            BlocListener<InvoiceBloc, InvoiceState>(
              listener: (context, state) {
                if (state is InvoiceCreateSuccessState) {
                  setState(() => _isCreatingInvoice = false);
                  ToastService.showSuccess('Invoice created successfully');
                  // Navigate to invoice details page with fresh data
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ViewInvoice(invoice: state.invoice),
                    ),
                  );
                } else if (state is InvoiceErrorState) {
                  setState(() => _isCreatingInvoice = false);
                  ToastService.showError(state.message);
                } else if (state is InvoiceLoadingState) {
                  setState(() => _isCreatingInvoice = true);
                }
              },
            ),
          ],
          child: BlocBuilder<OrderBloc, OrderState>(
            builder: (context, state) {
              final isUpdating = state is OrderLoadingState;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: _canEditOrder
                    ? _buildEditableContent(context, isUpdating)
                    : _buildNonEditableContent(context),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildNonEditableContent(BuildContext context) {
    final isCompleted = widget.order.status == OrderStatus.completed;
    final hasInvoice = widget.order.invoiceId != null;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          Text(
            isCompleted ? 'Order Completed' : 'Order Cancelled',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Text(
              isCompleted
                  ? 'This order has been fulfilled and cannot be modified.'
                  : 'This order has been cancelled and cannot be modified.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 15,
                height: 1.5,
              ),
            ),
          ),
          if (isCompleted && !hasInvoice) ...[
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isCreatingInvoice ? null : _createInvoice,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  ),
                  icon: _isCreatingInvoice
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.receipt_long_outlined),
                  label: Text(
                    _isCreatingInvoice
                        ? 'Creating invoice...'
                        : 'Create Invoice',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ),
          ],
          if (isCompleted && hasInvoice) ...[
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isRepeatingOrder ? null : _repeatOrder,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    foregroundColor: Theme.of(context).colorScheme.onSecondary,
                  ),
                  icon: _isRepeatingOrder
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.refresh_outlined),
                  label: Text(
                    _isRepeatingOrder ? 'Repeating order...' : 'Repeat Order',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ),
          ],
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildEditableContent(BuildContext context, bool isUpdating) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 8),
        Text(
          'Select Order Status',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Text(
          'Choose the current status for order #${widget.order.orderNumber}',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 24),

        // Status Options
        ...OrderStatus.values.map((status) {
          final isSelected = _selectedStatus == status;
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: InkWell(
              onTap: isUpdating
                  ? null
                  : () {
                      setState(() {
                        _selectedStatus = status;
                      });
                    },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected
                      ? _getStatusColor(status).withOpacity(0.08)
                      : Theme.of(context).cardColor,
                  border: Border.all(
                    color: isSelected
                        ? _getStatusColor(status)
                        : Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.3),
                    width: isSelected ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              status.name.toUpperCase(),
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
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
                                fontSize: 13,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected
                                ? _getStatusColor(status)
                                : Theme.of(context).dividerColor,
                            width: 2,
                          ),
                          color: isSelected
                              ? _getStatusColor(status)
                              : Colors.transparent,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),

        // Selected Status Details
        if (_selectedStatus != null) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _getStatusColor(_selectedStatus!).withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _getStatusColor(_selectedStatus!).withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'About this status',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: _getStatusColor(_selectedStatus!),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  _getStatusDetailedInfo(_selectedStatus!),
                  style: TextStyle(
                    fontSize: 13,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],

        const SizedBox(height: 32),

        // Update Button
        ElevatedButton(
          onPressed: isUpdating || _selectedStatus == null
              ? null
              : () => _showConfirmationSheet(context),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: isUpdating
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const Text(
                  'Update Status',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
