import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ventura/core/services/toast_service.dart';
import 'package:ventura/core/services/user_service.dart';
import 'package:ventura/features/sales/domain/entities/customer_entity.dart';
import 'package:ventura/features/sales/domain/entities/product_entity.dart';
import 'package:ventura/features/sales/presentation/bloc/order_bloc.dart';
import 'package:ventura/features/sales/presentation/bloc/product_bloc.dart';
import 'package:ventura/features/sales/presentation/widgets/text_input_component.dart';
import 'package:ventura/init_dependencies.dart';

class CreateCustomerOrder extends StatefulWidget {
  const CreateCustomerOrder({super.key, required this.customer});
  final Customer customer;

  @override
  State<CreateCustomerOrder> createState() => _CreateCustomerOrderState();
}

class _CreateCustomerOrderState extends State<CreateCustomerOrder> {
  final _formKey = GlobalKey<FormState>();
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

  double get _totalAmount {
    return _orderItems.fold(
      0.0,
      (sum, item) => sum + (item['price'] * item['quantity']),
    );
  }

  void _submitForm(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      if (_orderItems.isEmpty) {
        ToastService.showError('Please add at least one item');
        return;
      }

      context.read<OrderBloc>().add(
        OrderCreateEvent(
          businessId: _businessId,
          customerId: widget.customer.id,
          items: _orderItems,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider<OrderBloc>(
          create: (context) => serviceLocator<OrderBloc>(),
        ),
        BlocProvider<ProductBloc>(
          create: (context) => serviceLocator<ProductBloc>(),
        ),
      ],
      child: Scaffold(
        backgroundColor: theme.colorScheme.surface,
        appBar: AppBar(
          backgroundColor: theme.colorScheme.primary,
          title: Text(
            'Create Order',
            style: TextStyle(color: theme.colorScheme.onPrimary),
          ),
          leading: IconButton(
            icon: HugeIcon(
              icon: HugeIcons.strokeRoundedArrowLeft01,
              color: theme.colorScheme.onPrimary,
              size: 24,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: BlocConsumer<OrderBloc, OrderState>(
          listener: (context, state) {
            if (state is OrderCreateSuccessState) {
              ToastService.showSuccess('Order created successfully');
              Navigator.pop(context, true); // Return true to indicate success
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
                    // Customer Info Card
                    Card(
                      color: theme.colorScheme.surfaceContainerLowest,
                      elevation: 0,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 24,
                                  backgroundColor: theme.colorScheme.primary
                                      .withValues(alpha: 0.1),
                                  child: Text(
                                    widget.customer.name.isNotEmpty
                                        ? widget.customer.name[0].toUpperCase()
                                        : '?',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: theme.colorScheme.primary,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Customer',
                                        style: theme.textTheme.bodySmall
                                            ?.copyWith(
                                              color: theme
                                                  .colorScheme
                                                  .onSurfaceVariant,
                                            ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        widget.customer.name,
                                        style: theme.textTheme.titleMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                      if (widget.customer.phone != null)
                                        Text(
                                          widget.customer.phone!,
                                          style: theme.textTheme.bodySmall
                                              ?.copyWith(
                                                color: theme
                                                    .colorScheme
                                                    .onSurfaceVariant,
                                              ),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Order Items Section
                    Text(
                      'Order Items',
                      style: theme.textTheme.titleMedium?.copyWith(
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
                        size: 20,
                      ),
                      label: const Text('Add Product'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Items List
                    if (_orderItems.isNotEmpty) ...[
                      Card(
                        color: theme.colorScheme.surfaceContainerLowest,
                        elevation: 0,
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _orderItems.length,
                          separatorBuilder: (context, index) => Divider(
                            height: 1,
                            color: theme.colorScheme.outlineVariant.withValues(
                              alpha: 0.3,
                            ),
                          ),
                          itemBuilder: (context, index) {
                            final item = _orderItems[index];
                            final subtotal = item['price'] * item['quantity'];

                            return ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              title: Text(
                                item['name'],
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(
                                'GHS ${item['price'].toStringAsFixed(2)} × ${item['quantity']}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'GHS ${subtotal.toStringAsFixed(2)}',
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: theme.colorScheme.primary,
                                        ),
                                  ),
                                  const SizedBox(width: 8),
                                  IconButton(
                                    icon: HugeIcon(
                                      icon: HugeIcons.strokeRoundedDelete02,
                                      color: theme.colorScheme.error,
                                      size: 20,
                                    ),
                                    onPressed: () => _removeOrderItem(index),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Total Amount Card
                      Card(
                        color: theme.colorScheme.primary.withValues(alpha: 0.1),
                        elevation: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total Amount',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                'GHS ${_totalAmount.toStringAsFixed(2)}',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ] else
                      Container(
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: theme.colorScheme.outlineVariant,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            HugeIcon(
                              icon: HugeIcons.strokeRoundedShoppingCart01,
                              color: theme.colorScheme.onSurfaceVariant,
                              size: 48,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No products added yet',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),

                    const SizedBox(height: 32),

                    // Create Order Button
                    ElevatedButton(
                      onPressed: isLoading ? null : () => _submitForm(context),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: Colors.white,
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
    final theme = Theme.of(context);
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
                  'Add Product',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
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
                          '${product.name} - GHS ${product.price.toStringAsFixed(2)}',
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
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: Colors.white,
              ),
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
