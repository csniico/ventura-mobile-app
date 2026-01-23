import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ventura/core/services/toast_service.dart';
import 'package:ventura/core/services/user_service.dart';
import 'package:ventura/features/sales/domain/entities/customer_entity.dart';
import 'package:ventura/features/sales/domain/entities/order_entity.dart';
import 'package:ventura/features/sales/presentation/bloc/customer_bloc.dart';
import 'package:ventura/features/sales/presentation/bloc/invoice_bloc.dart';
import 'package:ventura/features/sales/presentation/bloc/order_bloc.dart';
import 'package:ventura/features/sales/presentation/widgets/date_picker_component.dart';
import 'package:ventura/features/sales/presentation/widgets/text_input_component.dart';
import 'package:ventura/init_dependencies.dart';

class CreateInvoice extends StatefulWidget {
  const CreateInvoice({super.key});

  @override
  State<CreateInvoice> createState() => _CreateInvoiceState();
}

class _CreateInvoiceState extends State<CreateInvoice> {
  final _formKey = GlobalKey<FormState>();
  final _notesController = TextEditingController();
  Customer? _selectedCustomer;
  final List<String> _selectedOrderIds = [];
  DateTime? _dueDate;
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

  void _toggleOrderSelection(String orderId) {
    setState(() {
      if (_selectedOrderIds.contains(orderId)) {
        _selectedOrderIds.remove(orderId);
      } else {
        _selectedOrderIds.add(orderId);
      }
    });
  }

  double _calculateTotalAmount(List<Order> selectedOrders) {
    return selectedOrders.fold(0.0, (sum, order) => sum + order.totalAmount);
  }

  Future<void> _selectDueDate(BuildContext context) async {
    final DateTime? picked =
        await DatePickerComponent.showDatePickerBottomSheet(
          context: context,
          initialDate: _dueDate ?? DateTime.now().add(const Duration(days: 30)),
          firstDay: DateTime.now(),
          lastDay: DateTime.now().add(const Duration(days: 365)),
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
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(8.0),
            child: const SizedBox(height: 8.0),
          ),
          title: Text(
            'Create Invoice',
            style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
          ),
          leading: IconButton(
            icon: HugeIcon(
              icon: HugeIcons.strokeRoundedArrowLeft01,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            onPressed: () => Navigator.pop(context),
          ),
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
                    // Customer Selection
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
                                      _selectedOrderIds
                                          .clear(); // Clear selected orders when customer changes
                                    });
                                    // Load orders for selected customer
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
                          // Load customers if not loaded
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

                    // Orders Selection (only show if customer is selected)
                    if (_selectedCustomer != null) ...[
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
                                      order.invoiceId ==
                                          null && // Only orders not already invoiced
                                      order.status.name !=
                                          'cancelled', // Exclude cancelled orders
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

                      // Selected Orders Summary
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

                              return Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.primary.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Invoice Summary',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      '${selectedOrders.length} order(s) selected',
                                    ),
                                    Text(
                                      'Total Amount: ₵${_calculateTotalAmount(selectedOrders).toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
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

                    // Create Invoice Button
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
                          : const Text(
                              'Create Invoice',
                              style: TextStyle(
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
}
