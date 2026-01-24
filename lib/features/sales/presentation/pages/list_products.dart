import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ventura/features/sales/presentation/bloc/product_bloc.dart';
import 'package:ventura/features/sales/presentation/pages/view_product.dart';

class ListProducts extends StatefulWidget {
  const ListProducts({super.key});

  @override
  State<ListProducts> createState() => _ListProductsState();
}

class _ListProductsState extends State<ListProducts> {
  final TextEditingController _searchController = TextEditingController();
  double _minPrice = 0;
  double _maxPrice = 10000;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showPriceFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Price Range'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        labelText: 'Min Price',
                        prefixText: 'GHS ',
                      ),
                      keyboardType: TextInputType.number,
                      controller: TextEditingController(
                        text: _minPrice.toStringAsFixed(0),
                      ),
                      onChanged: (value) {
                        final price = double.tryParse(value);
                        if (price != null) {
                          setState(() {
                            _minPrice = price;
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        labelText: 'Max Price',
                        prefixText: 'GHS ',
                      ),
                      keyboardType: TextInputType.number,
                      controller: TextEditingController(
                        text: _maxPrice.toStringAsFixed(0),
                      ),
                      onChanged: (value) {
                        final price = double.tryParse(value);
                        if (price != null) {
                          setState(() {
                            _maxPrice = price;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'GHS ${_minPrice.toStringAsFixed(0)} - GHS ${_maxPrice.toStringAsFixed(0)}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _minPrice = 0;
                  _maxPrice = 10000;
                });
                Navigator.pop(context);
              },
              child: const Text('Reset'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                setState(() {});
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
        // Search and Filter Bar
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search products...',
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
              IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: _showPriceFilterDialog,
                tooltip: 'Price Filter',
                style: IconButton.styleFrom(
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.surfaceContainerLowest,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Products Grid
        Expanded(
          child: BlocBuilder<ProductBloc, ProductState>(
            builder: (context, state) {
              if (state is ProductLoadingState) {
                return ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: const [
                    SizedBox(height: 200),
                    Center(child: CircularProgressIndicator()),
                  ],
                );
              } else if (state is ProductSearchResultState) {
                final allProducts = state.products;

                // Apply filters
                final products = allProducts.where((product) {
                  // Search filter
                  final searchQuery = _searchController.text.toLowerCase();
                  final matchesSearch =
                      searchQuery.isEmpty ||
                      product.name.toLowerCase().contains(searchQuery);

                  // Price filter
                  final matchesPrice =
                      product.price >= _minPrice && product.price <= _maxPrice;

                  return matchesSearch && matchesPrice;
                }).toList();

                if (products.isEmpty) {
                  final hasFilters =
                      _searchController.text.isNotEmpty ||
                      _minPrice > 0 ||
                      _maxPrice < 10000;
                  return ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      const SizedBox(height: 100),
                      Center(
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
                                  ?.copyWith(
                                    color: Theme.of(context).disabledColor,
                                  ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              hasFilters
                                  ? 'Try adjusting your search or filters'
                                  : 'Create your first product to get started',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: Theme.of(context).disabledColor,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }

                // Define placeholder images order
                final List<String> placeholderImages = [
                  'assets/images/headphones.jpeg',
                  'assets/images/shampoo.webp',
                  'assets/images/sneakers.jpg',
                  'assets/images/macbook.webp',
                ];

                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  physics: const AlwaysScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.65,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];

                    final ImageProvider imageProvider =
                        (product.primaryImage != null &&
                            product.primaryImage!.isNotEmpty)
                        ? NetworkImage(product.primaryImage!) as ImageProvider
                        : AssetImage(
                            placeholderImages[index % placeholderImages.length],
                          );

                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ViewProduct(product: product),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.surfaceContainerLowest,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withValues(alpha: 0.1),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Product Image
                            Expanded(
                              flex: 3,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(16),
                                  ),
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),

                            // Product Details
                            Expanded(
                              flex: 2,
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product.name,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'GHS ${product.price.toStringAsFixed(2)}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.primary,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '${product.availableQuantity} in stock',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface
                                                .withValues(alpha: 0.6),
                                          ),
                                        ),
                                        Text(
                                          '24 sold', // Hardcoded as requested
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface
                                                .withValues(alpha: 0.8),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              } else if (state is ProductErrorState) {
                return ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    const SizedBox(height: 100),
                    Center(
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
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.error,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            child: Text(
                              state.message,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: Theme.of(context).disabledColor,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Pull to refresh',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: Theme.of(context).disabledColor,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
              // Initial state - show loading
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
