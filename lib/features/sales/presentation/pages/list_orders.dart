import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ventura/core/services/user_service.dart';
import 'package:ventura/features/sales/domain/entities/order_status.dart';
import 'package:ventura/features/sales/presentation/bloc/order_bloc.dart';
import 'package:ventura/features/sales/presentation/pages/view_order.dart';
import 'package:ventura/features/sales/presentation/pages/create_order.dart';
import 'package:ventura/features/sales/presentation/pages/edit_order.dart';
import 'package:ventura/init_dependencies.dart';

class ListOrders extends StatefulWidget {
  const ListOrders({super.key});

  @override
  State<ListOrders> createState() => _ListOrdersState();
}

class _ListOrdersState extends State<ListOrders> {
  late String _businessId;

  @override
  void initState() {
    super.initState();
    _businessId = '';
    _loadBusinessId();
  }

  Future<void> _loadBusinessId() async {
    final user = await UserService().getUser();
    if (user != null) {
      setState(() {
        _businessId = user.businessId;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          serviceLocator<OrderBloc>()
            ..add(OrderGetListEvent(businessId: _businessId)),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: const Text('Orders'),
          actions: [
            IconButton(
              icon: HugeIcon(
                icon: HugeIcons.strokeRoundedShoppingCartAdd01,
                color: Theme.of(context).iconTheme.color,
              ),
              onPressed: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const CreateOrder()),
                );
                if (context.mounted) {
                  context.read<OrderBloc>().add(
                    OrderGetListEvent(businessId: _businessId),
                  );
                }
              },
            ),
          ],
        ),
        body: BlocBuilder<OrderBloc, OrderState>(
          builder: (context, state) {
            if (state is OrderLoadingState) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is OrderErrorState) {
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
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<OrderBloc>().add(
                          OrderGetListEvent(businessId: _businessId),
                        );
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (state is OrderListLoadedState) {
              if (state.orders.isEmpty) {
                return Center(
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
                        'No orders yet',
                        style: Theme.of(
                          context,
                        ).textTheme.titleLarge?.copyWith(color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () async {
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const CreateOrder(),
                            ),
                          );
                          if (context.mounted) {
                            context.read<OrderBloc>().add(
                              OrderGetListEvent(businessId: _businessId),
                            );
                          }
                        },
                        child: const Text('Create your first order'),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  context.read<OrderBloc>().add(
                    OrderGetListEvent(businessId: _businessId),
                  );
                },
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.orders.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final order = state.orders[index];

                    // Status color helper
                    Color getStatusColor(OrderStatus? status) {
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

                    return Card(
                      elevation: 2,
                      child: ListTile(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  ViewOrder(orderId: order.id),
                            ),
                          );
                        },
                        leading: CircleAvatar(
                          backgroundColor: getStatusColor(order.status),
                          child: HugeIcon(
                            icon: HugeIcons.strokeRoundedShoppingCart01,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        title: Text(
                          'Order #${order.orderNumber}',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: getStatusColor(
                                      order.status,
                                    ).withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    order.status.name.toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: getStatusColor(order.status),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                HugeIcon(
                                  icon: HugeIcons.strokeRoundedDollar01,
                                  color: Colors.grey,
                                  size: 14,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '\$${order.totalAmount.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        trailing: PopupMenuButton<String>(
                          icon: HugeIcon(
                            icon: HugeIcons.strokeRoundedMoreVertical,
                            color: Theme.of(context).iconTheme.color,
                          ),
                          onSelected: (value) async {
                            if (value == 'edit') {
                              await Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EditOrder(orderId: order.id),
                                ),
                              );
                              if (context.mounted) {
                                context.read<OrderBloc>().add(
                                  OrderGetListEvent(businessId: _businessId),
                                );
                              }
                            }
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'edit',
                              child: Text('Edit'),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}
