import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ventura/core/presentation/widgets/adaptive_image.dart';
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
    final minController = TextEditingController(
      text: _minPrice.toStringAsFixed(0),
    );
    final maxController = TextEditingController(
      text: _maxPrice.toStringAsFixed(0),
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Price Range',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Min Price',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: minController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                prefixText: 'GHS ',
                hintText: '100',
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Max Price',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: maxController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                prefixText: 'GHS ',
                hintText: '1000',
              ),
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
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final min = double.tryParse(minController.text) ?? 0;
              final max = double.tryParse(maxController.text) ?? 10000;
              setState(() {
                _minPrice = min;
                _maxPrice = max;
              });
              Navigator.pop(context);
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search and Filter Bar
        Padding(
          padding: const EdgeInsets.all(6),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
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
                AspectRatio(
                  aspectRatio: 1,
                  child: IconButton(
                    icon: const Icon(Icons.filter_list),
                    onPressed: _showPriceFilterDialog,
                    tooltip: 'Price Filter',
                    style: IconButton.styleFrom(
                      backgroundColor: Theme.of(
                        context,
                      ).inputDecorationTheme.fillColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side:
                            Theme.of(
                              context,
                            ).inputDecorationTheme.enabledBorder?.borderSide ??
                            const BorderSide(color: Color(0xFFD4D4D4)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
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

                const placeholderImages = [
                  'assets/images/headphones.jpeg',
                  'assets/images/shampoo.webp',
                  'assets/images/sneakers.jpg',
                  'assets/images/macbook.webp',
                ];

                return GridView.builder(
                  padding: const EdgeInsets.all(6),
                  physics: const AlwaysScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    final inStock = product.availableQuantity > 0;
                    final imagePath =
                        (product.primaryImage != null &&
                            product.primaryImage!.isNotEmpty)
                        ? product.primaryImage!
                        : placeholderImages[index % placeholderImages.length];

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
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(12),
                                ),
                                child: AdaptiveImage(
                                  path: imagePath,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: inStock
                                          ? Colors.green.withValues(alpha: 0.1)
                                          : Colors.red.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                        color: inStock
                                            ? Colors.green
                                            : Colors.red,
                                      ),
                                    ),
                                    child: Text(
                                      inStock ? 'In Stock' : 'Out of Stock',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: inStock
                                            ? Colors.green
                                            : Colors.red,
                                      ),
                                    ),
                                  ),
                                ],
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
