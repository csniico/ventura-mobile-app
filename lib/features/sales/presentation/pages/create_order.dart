import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ventura/core/services/toast_service.dart';
import 'package:ventura/core/services/user_service.dart';
import 'package:ventura/features/sales/domain/entities/customer_entity.dart';
import 'package:ventura/features/sales/domain/entities/product_entity.dart';
import 'package:ventura/features/sales/presentation/bloc/customer_bloc.dart';
import 'package:ventura/features/sales/presentation/bloc/order_bloc.dart';
import 'package:ventura/features/sales/presentation/bloc/product_bloc.dart';
import 'package:ventura/features/sales/presentation/widgets/text_input_component.dart';
import 'package:ventura/init_dependencies.dart';

class CreateOrder extends StatefulWidget {
  const CreateOrder({super.key});

  @override
  State<CreateOrder> createState() => _CreateOrderState();
}

class _CreateOrderState extends State<CreateOrder> {
  final _formKey = GlobalKey<FormState>();
  Customer? _selectedCustomer;
  final List<Map<String, dynamic>> _orderItems = [];
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

  void _addOrderItem(Product product, int quantity) {
    setState(() {
      _orderItems.add({
        'productId': product.id,
        'itemType': 'product',
        'name': product.name,
        'price': product.price,
        'quantity': quantity,
      });
    });
  }

  void _removeOrderItem(int index) {
    setState(() {
      _orderItems.removeAt(index);
    });
  }

  void _submitForm(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      if (_selectedCustomer == null) {
        ToastService.showError('Please select a customer');
        return;
      }

      if (_orderItems.isEmpty) {
        ToastService.showError('Please add at least one item');
        return;
      }

      context.read<OrderBloc>().add(
        OrderCreateEvent(
          businessId: _businessId,
          customerId: _selectedCustomer!.id,
          items: _orderItems,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<OrderBloc>(
          create: (context) => serviceLocator<OrderBloc>(),
        ),
        BlocProvider<CustomerBloc>(
          create: (context) => serviceLocator<CustomerBloc>(),
        ),
        BlocProvider<ProductBloc>(
          create: (context) => serviceLocator<ProductBloc>(),
        ),
      ],
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Text(
            'Create Order',
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
        body: BlocConsumer<OrderBloc, OrderState>(
          listener: (context, state) {
            if (state is OrderCreateSuccessState) {
              ToastService.showSuccess('Order created successfully');
              Navigator.pop(context);
            } else if (state is OrderErrorState) {
              ToastService.showError(state.message);
            }
          },
          builder: (context, orderState) {
            final isLoading = orderState is OrderLoadingState;

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
                              labelText: 'Select Customer *',
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
                                    });
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

                    // Order Items Section
                    Text(
                      'Order Items',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Add Item Button
                    ElevatedButton.icon(
                      onPressed: isLoading
                          ? null
                          : () => _showAddItemDialog(context),
                      icon: HugeIcon(
                        icon: HugeIcons.strokeRoundedAdd01,
                        color: Colors.white,
                      ),
                      label: const Text('Add Item'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Items List
                    if (_orderItems.isNotEmpty) ...[
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _orderItems.length,
                          itemBuilder: (context, index) {
                            final item = _orderItems[index];
                            final itemTotal =
                                (item['price'] as double) *
                                (item['quantity'] as int);
                            return ListTile(
                              title: Text(item['name']),
                              subtitle: Text(
                                'Qty: ${item['quantity']} × ₵${item['price'].toStringAsFixed(2)}',
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '₵${itemTotal.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  IconButton(
                                    icon: HugeIcon(
                                      icon: HugeIcons.strokeRoundedDelete01,
                                      color: Colors.red,
                                    ),
                                    onPressed: isLoading
                                        ? null
                                        : () => _removeOrderItem(index),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ] else ...[
                      Container(
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Column(
                          children: [
                            HugeIcon(
                              icon: HugeIcons.strokeRoundedShoppingCart01,
                              color: Colors.grey,
                              size: 48,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No items added yet',
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 32),

                    // Create Order Button
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
                              'Create Order',
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

  void _showAddItemDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (dialogContext) => BlocProvider.value(
        value: BlocProvider.of<ProductBloc>(context),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(dialogContext).viewInsets.bottom,
            ),
            child: AddItemBottomSheet(
              businessId: _businessId,
              onItemAdded: _addOrderItem,
            ),
          ),
        ),
      ),
    );
  }
}

class AddItemBottomSheet extends StatefulWidget {
  final String businessId;
  final Function(Product, int) onItemAdded;

  const AddItemBottomSheet({
    super.key,
    required this.businessId,
    required this.onItemAdded,
  });

  @override
  State<AddItemBottomSheet> createState() => _AddItemBottomSheetState();
}

class _AddItemBottomSheetState extends State<AddItemBottomSheet> {
  Product? _selectedProduct;
  final _quantityController = TextEditingController(text: '1');
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Add Item',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 24),
            BlocBuilder<ProductBloc, ProductState>(
              builder: (context, productState) {
                if (productState is ProductSearchResultState) {
                  final products = productState.products;
                  return DropdownButtonFormField<Product>(
                    initialValue: _selectedProduct,
                    decoration: InputDecoration(
                      labelText: 'Select Product',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    items: products.map((product) {
                      return DropdownMenuItem<Product>(
                        value: product,
                        child: Text(
                          '${product.name} - ₵${product.price.toStringAsFixed(2)}',
                        ),
                      );
                    }).toList(),
                    onChanged: (Product? value) {
                      setState(() {
                        _selectedProduct = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a product';
                      }
                      return null;
                    },
                  );
                } else if (productState is ProductLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  // Load products if not loaded
                  context.read<ProductBloc>().add(
                    ProductSearchEvent(
                      businessId: widget.businessId,
                      searchQuery: '',
                    ),
                  );
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
            const SizedBox(height: 16),
            TextInputComponent(
              title: 'Quantity',
              hintText: '1',
              controller: _quantityController,
              onSaved: (_) {},
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter quantity';
                }
                final quantity = int.tryParse(value);
                if (quantity == null || quantity <= 0) {
                  return 'Quantity must be greater than 0';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate() &&
                    _selectedProduct != null) {
                  final quantity = int.parse(_quantityController.text);
                  widget.onItemAdded(_selectedProduct!, quantity);
                  Navigator.pop(context);
                }
              },

              child: const Text(
                'Add Item',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
