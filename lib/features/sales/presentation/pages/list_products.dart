import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ventura/core/services/user_service.dart';
import 'package:ventura/features/sales/presentation/bloc/product_bloc.dart';
import 'package:ventura/features/sales/presentation/pages/create_products.dart';
import 'package:ventura/features/sales/presentation/pages/edit_product.dart';
import 'package:ventura/features/sales/presentation/pages/view_product.dart';
import 'package:ventura/init_dependencies.dart';

class ListProducts extends StatefulWidget {
  const ListProducts({super.key});

  @override
  State<ListProducts> createState() => _ListProductsState();
}

class _ListProductsState extends State<ListProducts> {
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
          serviceLocator<ProductBloc>()
            ..add(ProductSearchEvent(businessId: _businessId, searchQuery: '')),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: const Text('Products'),
          actions: [
            IconButton(
              icon: HugeIcon(
                icon: HugeIcons.strokeRoundedAdd01,
                color: Theme.of(context).iconTheme.color,
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const CreateProducts(),
                  ),
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<ProductBloc, ProductState>(
          builder: (context, state) {
            if (state is ProductLoadingState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProductSearchResultState) {
              final products =
                  state.searchResult['products'] as List<dynamic>? ?? [];
              if (products.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      HugeIcon(
                        icon: HugeIcons.strokeRoundedShoppingBag01,
                        color: Theme.of(context).disabledColor,
                        size: 64,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No products found',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(color: Theme.of(context).disabledColor),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Create your first product to get started',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).disabledColor,
                        ),
                      ),
                    ],
                  ),
                );
              }
              return ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: ListTile(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                ViewProduct(productId: product.id),
                          ),
                        );
                      },
                      leading: CircleAvatar(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        child: HugeIcon(
                          icon: HugeIcons.strokeRoundedShoppingBag01,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      title: Text(product.name ?? 'Unknown Product'),
                      subtitle: Text(
                        '\$${product.price?.toStringAsFixed(2) ?? '0.00'}',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: HugeIcon(
                              icon: HugeIcons.strokeRoundedPencilEdit02,
                              color: Theme.of(context).iconTheme.color,
                            ),
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EditProduct(productId: product.id),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: HugeIcon(
                              icon: HugeIcons.strokeRoundedDelete02,
                              color: Theme.of(context).colorScheme.error,
                            ),
                            onPressed: () {
                              _showDeleteConfirmationDialog(
                                context,
                                product.id,
                                product.name ?? 'Unknown Product',
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
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
                      'Error loading products',
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
                          ProductSearchEvent(
                            businessId: _businessId,
                            searchQuery: '',
                          ),
                        );
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(
    BuildContext context,
    String productId,
    String productName,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Product'),
          content: Text(
            'Are you sure you want to delete "$productName"? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                context.read<ProductBloc>().add(
                  ProductDeleteEvent(
                    productId: productId,
                    businessId: _businessId,
                  ),
                );
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
