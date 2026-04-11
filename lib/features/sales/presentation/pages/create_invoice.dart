import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ventura/core/presentation/widgets/ventura_app_bar/ventura_app_bar.dart';
import 'package:ventura/core/services/toast_service.dart';
import 'package:ventura/core/services/user_service.dart';
import 'package:ventura/features/sales/domain/entities/customer_entity.dart';
import 'package:ventura/features/sales/domain/entities/invoice_type.dart';
import 'package:ventura/features/sales/domain/entities/order_entity.dart';
import 'package:ventura/features/sales/presentation/bloc/customer_bloc.dart';
import 'package:ventura/features/sales/presentation/bloc/invoice_bloc.dart';
import 'package:ventura/features/sales/presentation/bloc/order_bloc.dart';
import 'package:ventura/features/sales/presentation/widgets/date_picker_component.dart';
import 'package:ventura/features/sales/presentation/widgets/text_input_component.dart';
import 'package:ventura/init_dependencies.dart';

class CreateInvoice extends StatefulWidget {
  const CreateInvoice({
    super.key,
    this.preselectedCustomer,
    this.preselectedOrders,
  });

  final Customer? preselectedCustomer;
  final List<Order>? preselectedOrders;

  @override
  State<CreateInvoice> createState() => _CreateInvoiceState();
}

class _CreateInvoiceState extends State<CreateInvoice> {
  final _formKey = GlobalKey<FormState>();
  final _notesController = TextEditingController();
  Customer? _selectedCustomer;
  final List<String> _selectedOrderIds = [];
  DateTime? _dueDate;
  InvoiceType _invoiceType = InvoiceType.standard;
  late String _businessId;

  bool get _isPreselected =>
      widget.preselectedCustomer != null && widget.preselectedOrders != null;

  @override
  void initState() {
    super.initState();
    _businessId = '';
    _selectedCustomer = widget.preselectedCustomer;
    if (widget.preselectedOrders != null) {
      _selectedOrderIds.addAll(widget.preselectedOrders!.map((o) => o.id));
    }
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

  void _toggleOrderSelection(String orderId) {
    setState(() {
      if (_selectedOrderIds.contains(orderId)) {
        _selectedOrderIds.remove(orderId);
      } else {
        _selectedOrderIds.add(orderId);
      }
    });
  }

  double _calculateTotalAmount(List<Order> orders) {
    return orders.fold(0.0, (sum, order) => sum + order.totalAmount);
  }

  Future<void> _selectDueDate(BuildContext context) async {
    final DateTime? picked =
        await DatePickerComponent.showDatePickerBottomSheet(
          context: context,
          initialDate: _dueDate ?? DateTime.now().add(const Duration(days: 30)),
          firstDay: DateTime.now(),
          lastDay: DateTime.now().add(const Duration(days: 365)),
          title: 'Select due date',
          description: 'Set when this invoice should be paid.',
        );
    if (picked != null && picked != _dueDate) {
      setState(() {
        _dueDate = picked;
      });
    }
  }

  void _submitForm(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      if (_selectedCustomer == null) {
        ToastService.showError('Please select a customer');
        return;
      }

      if (_selectedOrderIds.isEmpty) {
        ToastService.showError('Please select at least one order');
        return;
      }

      context.read<InvoiceBloc>().add(
        InvoiceCreateEvent(
          businessId: _businessId,
          customerId: _selectedCustomer!.id,
          orderIds: _selectedOrderIds,
          dueDate: _dueDate,
          invoiceType: _invoiceType.toJson(),
          notes: _notesController.text.trim().isEmpty
              ? null
              : _notesController.text.trim(),
        ),
      );
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<InvoiceBloc>(
          create: (context) => serviceLocator<InvoiceBloc>(),
        ),
        BlocProvider<CustomerBloc>(
          create: (context) => serviceLocator<CustomerBloc>(),
        ),
        BlocProvider<OrderBloc>(
          create: (context) => serviceLocator<OrderBloc>(),
        ),
      ],
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: VenturaAppBar(
          title: 'Create Invoice',
        ),
        body: BlocConsumer<InvoiceBloc, InvoiceState>(
          listener: (context, state) {
            if (state is InvoiceCreateSuccessState) {
              ToastService.showSuccess('Invoice created successfully');
              Navigator.pop(context);
            } else if (state is InvoiceErrorState) {
              ToastService.showError(state.message);
            }
          },
          builder: (context, invoiceState) {
            final isLoading = invoiceState is InvoiceLoadingState;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Invoice Type Selector
                    Text(
                      'Invoice Type',
                      style: Theme.of(context).textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 12),
                    SegmentedButton<InvoiceType>(
                      segments: const [
                        ButtonSegment(
                          value: InvoiceType.standard,
                          label: Text('Standard'),
                        ),
                        ButtonSegment(
                          value: InvoiceType.receipt,
                          label: Text('Receipt'),
                        ),
                        ButtonSegment(
                          value: InvoiceType.proforma,
                          label: Text('Proforma'),
                        ),
                      ],
                      selected: {_invoiceType},
                      onSelectionChanged: isLoading
                          ? null
                          : (Set<InvoiceType> value) {
                              setState(() => _invoiceType = value.first);
                            },
                    ),

                    const SizedBox(height: 24),

                    // Customer Section
                    if (_isPreselected)
                      _buildPreselectedCustomerCard(context)
                    else
                      BlocBuilder<CustomerBloc, CustomerState>(
                        builder: (context, customerState) {
                          if (customerState is CustomerListLoadedState) {
                            return DropdownButtonFormField<Customer>(
                              initialValue: _selectedCustomer,
                              decoration: InputDecoration(
                                labelText: 'Customer',
                                hintText: 'Select customer',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              items: customerState.customers.map((customer) {
                                return DropdownMenuItem<Customer>(
                                  value: customer,
                                  child: Text(customer.name),
                                );
                              }).toList(),
                              onChanged: isLoading
                                  ? null
                                  : (Customer? value) {
                                      setState(() {
                                        _selectedCustomer = value;
                                        _selectedOrderIds.clear();
                                      });
                                      if (value != null) {
                                        context.read<OrderBloc>().add(
                                          OrderGetCustomerOrdersEvent(
                                            customerId: value.id,
                                            businessId: _businessId,
                                          ),
                                        );
                                      }
                                    },
                              validator: (value) {
                                if (value == null) {
                                  return 'Please select a customer';
                                }
                                return null;
                              },
                            );
                          } else if (customerState is CustomerLoadingState) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else {
                            context.read<CustomerBloc>().add(
                              CustomerGetEvent(businessId: _businessId),
                            );
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      ),

                    const SizedBox(height: 24),

                    // Orders Section
                    if (_isPreselected)
                      _buildPreselectedOrdersSummary(context)
                    else if (_selectedCustomer != null) ...[
                      Text(
                        'Select Orders to Include',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 16),

                      BlocBuilder<OrderBloc, OrderState>(
                        builder: (context, orderState) {
                          if (orderState is OrderListLoadedState) {
                            final availableOrders = orderState.orders
                                .where(
                                  (order) =>
                                      order.invoiceId == null &&
                                      order.status.name != 'cancelled',
                                )
                                .toList();

                            if (availableOrders.isEmpty) {
                              return Container(
                                padding: const EdgeInsets.all(32),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade50,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    HugeIcon(
                                      icon:
                                          HugeIcons.strokeRoundedShoppingCart01,
                                      color: Colors.grey,
                                      size: 48,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'No available orders for this customer',
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              );
                            }

                            return Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: availableOrders.length,
                                itemBuilder: (context, index) {
                                  final order = availableOrders[index];
                                  final isSelected = _selectedOrderIds.contains(
                                    order.id,
                                  );

                                  return CheckboxListTile(
                                    title: Text('Order #${order.orderNumber}'),
                                    subtitle: Text(
                                      'Total: ₵${order.totalAmount.toStringAsFixed(2)} • Status: ${order.status.name}',
                                    ),
                                    value: isSelected,
                                    onChanged: isLoading
                                        ? null
                                        : (bool? value) {
                                            _toggleOrderSelection(order.id);
                                          },
                                    activeColor: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  );
                                },
                              ),
                            );
                          } else if (orderState is OrderLoadingState) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else {
                            return Container(
                              padding: const EdgeInsets.all(32),
                              child: Column(
                                children: [
                                  HugeIcon(
                                    icon: HugeIcons.strokeRoundedShoppingCart01,
                                    color: Colors.grey,
                                    size: 48,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Select a customer to view available orders',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                      ),

                      if (_selectedOrderIds.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        BlocBuilder<OrderBloc, OrderState>(
                          builder: (context, orderState) {
                            if (orderState is OrderListLoadedState) {
                              final selectedOrders = orderState.orders
                                  .where(
                                    (order) =>
                                        _selectedOrderIds.contains(order.id),
                                  )
                                  .toList();

                              return _buildOrdersSummaryCard(
                                context,
                                selectedOrders,
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ],
                    ],

                    const SizedBox(height: 24),

                    // Due Date
                    DatePickerComponent(
                      title: 'Due Date',
                      hintText: 'Select due date',
                      selectedDate: _dueDate,
                      onTap: isLoading ? null : () => _selectDueDate(context),
                    ),

                    const SizedBox(height: 16),

                    // Notes
                    TextInputComponent(
                      title: 'Notes (Optional)',
                      hintText: 'Additional notes...',
                      controller: _notesController,
                      onSaved: (_) {},
                      maxLines: 3,
                      enabled: !isLoading,
                      textInputAction: TextInputAction.done,
                    ),

                    const SizedBox(height: 32),

                    ElevatedButton(
                      onPressed: isLoading ? null : () => _submitForm(context),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: isLoading
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
                          : Text(
                              'Create ${_invoiceType.displayName}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPreselectedCustomerCard(BuildContext context) {
    final customer = widget.preselectedCustomer!;
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.12),
            child: Text(
              customer.name.isNotEmpty ? customer.name[0].toUpperCase() : '?',
              style: TextStyle(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  customer.name,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (customer.email != null)
                  Text(
                    customer.email!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreselectedOrdersSummary(BuildContext context) {
    final orders = widget.preselectedOrders!;
    final total = _calculateTotalAmount(orders);
    return _buildOrdersSummaryCard(context, orders, total: total);
  }

  Widget _buildOrdersSummaryCard(
    BuildContext context,
    List<Order> orders, {
    double? total,
  }) {
    final theme = Theme.of(context);
    final displayTotal = total ?? _calculateTotalAmount(orders);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Invoice Summary',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          ...orders.map(
            (o) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text('• Order #${o.orderNumber}'),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Total: ₵${displayTotal.toStringAsFixed(2)}',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
