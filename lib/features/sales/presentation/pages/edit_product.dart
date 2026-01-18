import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ventura/core/services/toast_service.dart';
import 'package:ventura/core/services/user_service.dart';
import 'package:ventura/features/sales/presentation/bloc/product_bloc.dart';
import 'package:ventura/features/sales/presentation/widgets/text_input_component.dart';
import 'package:ventura/init_dependencies.dart';

class EditProduct extends StatefulWidget {
  const EditProduct({super.key, required this.productId});
  final String productId;

  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _quantityController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _notesController = TextEditingController();

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
      // Load product data after getting business ID
      if (mounted) {
        context.read<ProductBloc>().add(
          ProductGetByIdEvent(
            productId: widget.productId,
            businessId: _businessId,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    _descriptionController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      final name = _nameController.text.trim();
      final price = double.tryParse(_priceController.text.trim());
      final quantity = int.tryParse(_quantityController.text.trim());
      final description = _descriptionController.text.trim();
      final notes = _notesController.text.trim();

      context.read<ProductBloc>().add(
        ProductUpdateEvent(
          productId: widget.productId,
          businessId: _businessId,
          name: name.isNotEmpty ? name : null,
          price: price,
          availableQuantity: quantity,
          description: description.isNotEmpty ? description : null,
          notes: notes.isNotEmpty ? notes : null,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<ProductBloc>(),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: const Text('Edit Product'),
          actions: [
            BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                if (state is ProductLoadingState) {
                  return const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  );
                }
                return IconButton(
                  icon: HugeIcon(
                    icon: HugeIcons.strokeRoundedTick02,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  onPressed: _submitForm,
                );
              },
            ),
          ],
        ),
        body: BlocConsumer<ProductBloc, ProductState>(
          listener: (context, state) {
            if (state is ProductUpdateSuccessState) {
              ToastService.showSuccess('Product updated successfully');
              Navigator.of(context).pop();
            } else if (state is ProductErrorState) {
              ToastService.showError('Error: ${state.message}');
            }
          },
          builder: (context, state) {
            if (state is ProductLoadedState) {
              final product = state.product;

              // Populate controllers with existing data
              _nameController.text = product.name;
              _priceController.text = product.price.toString();
              _quantityController.text = product.availableQuantity.toString();
              _descriptionController.text = product.description ?? '';
              _notesController.text = product.notes ?? '';

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Name
                      TextInputComponent(
                        title: 'Product Name *',
                        hintText: 'eg. Blue T-Shirt',
                        controller: _nameController,
                        onSaved: (_) {},
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Product name is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Price
                      TextInputComponent(
                        title: 'Price',
                        hintText: '0.00',
                        controller: _priceController,
                        onSaved: (_) {},
                        keyboardType: TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        validator: (value) {
                          if (value != null && value.trim().isNotEmpty) {
                            final price = double.tryParse(value.trim());
                            if (price == null || price < 0) {
                              return 'Please enter a valid price';
                            }
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Quantity
                      TextInputComponent(
                        title: 'Available Quantity',
                        hintText: '0',
                        controller: _quantityController,
                        onSaved: (_) {},
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value != null && value.trim().isNotEmpty) {
                            final quantity = int.tryParse(value.trim());
                            if (quantity == null || quantity < 0) {
                              return 'Please enter a valid quantity';
                            }
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Description
                      TextInputComponent(
                        title: 'Description',
                        hintText: 'Product description...',
                        controller: _descriptionController,
                        onSaved: (_) {},
                        maxLines: 3,
                      ),
                      const SizedBox(height: 16),

                      // Notes
                      TextInputComponent(
                        title: 'Notes',
                        hintText: 'Additional notes...',
                        controller: _notesController,
                        onSaved: (_) {},
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
              );
            } else if (state is ProductLoadingState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProductErrorState) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    HugeIcon(
                      icon: HugeIcons.strokeRoundedAlert01,
                      color: Theme.of(context).colorScheme.error,
                      size: 64,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error loading product',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.message,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).disabledColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<ProductBloc>().add(
                          ProductGetByIdEvent(
                            productId: widget.productId,
                            businessId: _businessId,
                          ),
                        );
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
