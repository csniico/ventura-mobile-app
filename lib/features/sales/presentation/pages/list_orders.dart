import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:ventura/core/services/user_service.dart';
import 'package:ventura/features/sales/domain/entities/order_status.dart';
import 'package:ventura/features/sales/presentation/bloc/order_bloc.dart';
import 'package:ventura/features/sales/presentation/pages/view_order.dart';
import 'package:ventura/features/sales/presentation/pages/create_order.dart';

class ListOrders extends StatefulWidget {
  const ListOrders({super.key});

  @override
  State<ListOrders> createState() => _ListOrdersState();
}

class _ListOrdersState extends State<ListOrders> {
  final TextEditingController _searchController = TextEditingController();
  Set<OrderStatus> _selectedStatuses = {};
  double _minAmount = 0;
  double _maxAmount = 100000;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Color _getStatusColor(OrderStatus? status) {
    switch (status?.name) {
      case 'pending':
        return Colors.orange;
      case 'confirmed':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _statusLabel(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.completed:
        return 'Completed';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  void _showFilterDialog() {
    var tempStatuses = Set<OrderStatus>.from(_selectedStatuses);
    final minController = TextEditingController(
      text: _minAmount.toStringAsFixed(0),
    );
    final maxController = TextEditingController(
      text: _maxAmount.toStringAsFixed(0),
    );

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text(
            'Filter Orders',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Status',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: OrderStatus.values.map((status) {
                  final selected = tempStatuses.contains(status);
                  final color = _getStatusColor(status);
                  return FilterChip(
                    label: Text(_statusLabel(status)),
                    selected: selected,
                    selectedColor: color.withValues(alpha: 0.2),
                    checkmarkColor: color,
                    onSelected: (value) {
                      setDialogState(() {
                        if (value) {
                          tempStatuses.add(status);
                        } else {
                          tempStatuses.remove(status);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              const Text(
                'Min Amount',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: minController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  prefixText: 'GHS ',
                  hintText: '0',
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Max Amount',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: maxController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  prefixText: 'GHS ',
                  hintText: '100000',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _selectedStatuses = {};
                  _minAmount = 0;
                  _maxAmount = 100000;
                });
                Navigator.pop(context);
              },
              child: const Text('Reset'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                setState(() {
                  _selectedStatuses = tempStatuses;
                  _minAmount = double.tryParse(minController.text) ?? 0;
                  _maxAmount = double.tryParse(maxController.text) ?? 100000;
                });
                Navigator.pop(context);
              },
              child: const Text('Apply'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search orders...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                setState(() {
                                  _searchController.clear();
                                });
                              },
                            )
                          : null,
                    ),
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                ),
                const SizedBox(width: 8),
                AspectRatio(
                  aspectRatio: 1,
                  child: IconButton(
                    icon: const Icon(Icons.filter_list),
                    onPressed: _showFilterDialog,
                    tooltip: 'Filter',
                    style: IconButton.styleFrom(
                      backgroundColor:
                          Theme.of(context).inputDecorationTheme.fillColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: Theme.of(context)
                                .inputDecorationTheme
                                .enabledBorder
                                ?.borderSide ??
                            const BorderSide(color: Color(0xFFD4D4D4)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: BlocBuilder<OrderBloc, OrderState>(
            builder: (context, state) {
              if (state is OrderLoadingState) {
                return ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: const [
                    SizedBox(height: 200),
                    Center(child: CircularProgressIndicator()),
                  ],
                );
              }

              if (state is OrderErrorState) {
                return ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    const SizedBox(height: 100),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          HugeIcon(
                            icon: HugeIcons.strokeRoundedAlert02,
                            color: Theme.of(context).colorScheme.error,
                            size: 48,
                          ),
                          const SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            child: Text(
                              'Error: ${state.message}',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.error,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Pull to refresh',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Theme.of(context).disabledColor,
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }

              if (state is OrderListLoadedState) {
                final query = _searchController.text.toLowerCase();
                final orders = state.orders.where((order) {
                  final matchesSearch = query.isEmpty ||
                      order.orderNumber.toLowerCase().contains(query) ||
                      (order.customer?.name.toLowerCase().contains(query) ??
                          false) ||
                      order.totalAmount
                          .toStringAsFixed(2)
                          .contains(query) ||
                      DateFormat('dd/MM/yyyy')
                          .format(order.createdAt)
                          .contains(query);

                  final matchesStatus = _selectedStatuses.isEmpty ||
                      _selectedStatuses.contains(order.status);

                  final matchesAmount = order.totalAmount >= _minAmount &&
                      order.totalAmount <= _maxAmount;

                  return matchesSearch && matchesStatus && matchesAmount;
                }).toList();

                if (orders.isEmpty) {
                  final hasFilters = query.isNotEmpty ||
                      _selectedStatuses.isNotEmpty ||
                      _minAmount > 0 ||
                      _maxAmount < 100000;
                  return ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      const SizedBox(height: 100),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            HugeIcon(
                              icon: HugeIcons.strokeRoundedShoppingCart01,
                              color: Colors.grey,
                              size: 64,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No orders found',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(color: Colors.grey),
                            ),
                            const SizedBox(height: 8),
                            if (hasFilters)
                              Text(
                                'Try adjusting your search or filters',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: Theme.of(context).disabledColor,
                                    ),
                              )
                            else
                              TextButton(
                                onPressed: () async {
                                  await Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const CreateOrder(),
                                    ),
                                  );
                                  if (context.mounted) {
                                    final businessId =
                                        UserService().businessId;
                                    if (businessId != null) {
                                      context.read<OrderBloc>().add(
                                            OrderGetListEvent(
                                                businessId: businessId),
                                          );
                                    }
                                  }
                                },
                                child:
                                    const Text('Create your first order'),
                              ),
                          ],
                        ),
                      ),
                    ],
                  );
                }

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: orders.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final order = orders[index];

                      return Card(
                        color: Theme.of(context)
                            .colorScheme
                            .surfaceContainerLowest,
                        elevation: 0,
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    ViewOrder(order: order),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'GHC ${order.totalAmount.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: _getStatusColor(
                                          order.status,
                                        ).withValues(alpha: 0.15),
                                        borderRadius:
                                            BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        order.status.name.toUpperCase(),
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color:
                                              _getStatusColor(order.status),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Order Number',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurfaceVariant,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          order.orderNumber,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          'Products',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurfaceVariant,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${order.items.length}',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }

              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 200),
                  Center(child: CircularProgressIndicator()),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
