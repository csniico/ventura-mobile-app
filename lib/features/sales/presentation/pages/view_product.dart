import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ventura/core/services/user_service.dart';
import 'package:ventura/features/sales/presentation/bloc/product_bloc.dart';
import 'package:ventura/features/sales/presentation/pages/edit_product.dart';
import 'package:ventura/init_dependencies.dart';

class ViewProduct extends StatefulWidget {
  const ViewProduct({super.key, required this.productId});
  final String productId;

  @override
  State<ViewProduct> createState() => _ViewProductState();
}

class _ViewProductState extends State<ViewProduct> {
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

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  Widget _buildInfoRow(
    BuildContext context,
    dynamic icon,
    String label,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          HugeIcon(
            icon: icon,
            color: Theme.of(context).iconTheme.color,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).disabledColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(value, style: Theme.of(context).textTheme.bodyLarge),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<ProductBloc>(),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: const Text('Product Details'),
          actions: [
            BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                if (state is ProductLoadedState) {
                  return IconButton(
                    icon: HugeIcon(
                      icon: HugeIcons.strokeRoundedPencilEdit02,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              EditProduct(productId: widget.productId),
                        ),
                      );
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
        body: BlocBuilder<ProductBloc, ProductState>(
          builder: (context, state) {
            if (state is ProductLoadedState) {
              final product = state.product;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Card
                    Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.primary,
                              radius: 32,
                              child: HugeIcon(
                                icon: HugeIcons.strokeRoundedShoppingBag01,
                                color: Colors.white,
                                size: 32,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.name,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Product ID: ${product.id}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: Theme.of(
                                            context,
                                          ).disabledColor,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Product Information Card
                    Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Product Information',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 16),
                            _buildInfoRow(
                              context,
                              HugeIcons.strokeRoundedDollar01,
                              'Price',
                              '\$${product.price.toStringAsFixed(2)}',
                            ),
                            const Divider(height: 24),
                            _buildInfoRow(
                              context,
                              HugeIcons.strokeRoundedPackage,
                              'Available Quantity',
                              '${product.availableQuantity}',
                            ),
                            const Divider(height: 24),
                            _buildInfoRow(
                              context,
                              HugeIcons.strokeRoundedCalendar01,
                              'Created',
                              _formatDate(product.createdAt),
                            ),
                            const Divider(height: 24),
                            _buildInfoRow(
                              context,
                              HugeIcons.strokeRoundedPencilEdit02,
                              'Last Updated',
                              _formatDate(product.updatedAt),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Description Card (if description exists)
                    if (product.description != null &&
                        product.description!.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Card(
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Description',
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                product.description!,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],

                    // Notes Card (if notes exist)
                    if (product.notes != null && product.notes!.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Card(
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Notes',
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                product.notes!,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
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
