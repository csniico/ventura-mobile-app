import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ventura/core/services/toast_service.dart';
import 'package:ventura/core/services/user_service.dart';
import 'package:ventura/features/sales/domain/entities/product_entity.dart';
import 'package:ventura/features/sales/presentation/bloc/product_bloc.dart';
import 'package:ventura/features/sales/presentation/pages/edit_product.dart';
import 'package:ventura/features/sales/presentation/widgets/delete_product_modal.dart';
import 'package:ventura/init_dependencies.dart';

class ViewProduct extends StatelessWidget {
  const ViewProduct({super.key, required this.product});
  final Product product;

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  void _showFullScreenGallery(
    BuildContext context,
    List<String> images,
    int initialIndex,
    bool areAssets,
  ) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Close',
      barrierColor: Colors.black,
      pageBuilder: (context, animation, secondaryAnimation) {
        return Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              PageView.builder(
                controller: PageController(initialPage: initialIndex),
                itemCount: images.length,
                itemBuilder: (context, index) {
                  return InteractiveViewer(
                    minScale: 0.5,
                    maxScale: 4.0,
                    child: Center(
                      child: areAssets
                          ? Image.asset(images[index], fit: BoxFit.contain)
                          : Image.network(images[index], fit: BoxFit.contain),
                    ),
                  );
                },
              ),
              Positioned(
                top: 40,
                right: 20,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 30),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildImageGallery(BuildContext context, List<String> fallbackAssets) {
    final bool hasSupportingImages =
        product.supportingImages != null &&
        product.supportingImages!.isNotEmpty;
    final List<String> displayImages = hasSupportingImages
        ? product.supportingImages!
        : fallbackAssets;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gallery',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 100,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: displayImages.length,
            separatorBuilder: (context, index) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => _showFullScreenGallery(
                  context,
                  displayImages,
                  index,
                  !hasSupportingImages,
                ),
                child: Container(
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: hasSupportingImages
                          ? NetworkImage(displayImages[index]) as ImageProvider
                          : AssetImage(displayImages[index]),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildInfoSection(
    BuildContext context,
    String title,
    String? value,
    String emptyText,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          (value == null || value.trim().isEmpty) ? emptyText : value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: (value == null || value.trim().isEmpty)
                ? Theme.of(context).disabledColor
                : Theme.of(context).colorScheme.onSurface,
            fontStyle: (value == null || value.trim().isEmpty)
                ? FontStyle.italic
                : FontStyle.normal,
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    List<List<dynamic>> icon,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.1),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HugeIcon(
              icon: icon,
              color: Theme.of(context).colorScheme.onSurface,
              size: 24,
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Fallback image logic
    final List<String> placeholderImages = [
      'assets/images/headphones.jpeg',
      'assets/images/shampoo.webp',
      'assets/images/macbook.webp',
      'assets/images/sneakers.jpg',
    ];

    // Deterministic selection based on name length to be consistent without index
    final int imageIndex = product.name.length % placeholderImages.length;

    final ImageProvider imageProvider =
        (product.primaryImage != null && product.primaryImage!.isNotEmpty)
        ? NetworkImage(product.primaryImage!) as ImageProvider
        : AssetImage(placeholderImages[imageIndex]);

    return BlocProvider(
      create: (context) => serviceLocator<ProductBloc>(),
      child: BlocListener<ProductBloc, ProductState>(
        listener: (context, state) {
          if (state is ProductDeleteSuccessState) {
            ToastService.showSuccess('Product deleted successfully');
            Navigator.of(context).pop(true);
          } else if (state is ProductErrorState) {
            ToastService.showError('Error: ${state.message}');
          }
        },
        child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: Stack(
            children: [
              // 1. Background Image Section
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: MediaQuery.of(context).size.height * 0.5,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image(image: imageProvider, fit: BoxFit.cover),
                    // Gradient overlay for header icons visibility
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.center,
                          colors: [
                            Colors.black.withValues(alpha: 0.7),
                            Colors.transparent,
                          ],
                          stops: const [0.0, 0.4],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 2. Action Icons (Back & Edit)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 8,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: HugeIcon(
                            icon: HugeIcons.strokeRoundedArrowLeft01,
                            color: Colors.white,
                            size: 30,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                        IconButton(
                          icon: HugeIcon(
                            icon: HugeIcons.strokeRoundedPencilEdit02,
                            color: Colors.white,
                            size: 30,
                          ),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    EditProduct(product: product),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // 3. Draggable Sheet with Product Details
              SafeArea(
                child: DraggableScrollableSheet(
                  initialChildSize: 0.6,
                  minChildSize: 0.6,
                  maxChildSize: 1.0,
                  builder: (context, scrollController) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(32),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, -5),
                          ),
                        ],
                      ),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Product Name and Price
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.name,
                                  style: Theme.of(context).textTheme.titleLarge
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'GHS ${product.price.toStringAsFixed(2)}',
                                  style: Theme.of(context).textTheme.titleLarge
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 32),

                            // Stats Row
                            Row(
                              children: [
                                _buildStatItem(
                                  context,
                                  'Available Stock',
                                  product.availableQuantity.toString(),
                                  HugeIcons.strokeRoundedPackage,
                                ),
                                const SizedBox(width: 16),
                                _buildStatItem(
                                  context,
                                  'Total Sold',
                                  '24', // Hardcoded as per previous requirements
                                  HugeIcons.strokeRoundedShoppingBag01,
                                ),
                              ],
                            ),
                            const SizedBox(height: 32),

                            // Image Carousel
                            _buildImageGallery(context, placeholderImages),

                            // Info Sections
                            _buildInfoSection(
                              context,
                              'Description',
                              product.description,
                              'No description provided',
                            ),

                            _buildInfoSection(
                              context,
                              'Notes',
                              product.notes,
                              'No notes provided',
                            ),

                            _buildInfoSection(
                              context,
                              'Last Updated',
                              _formatDate(product.updatedAt),
                              'No update date',
                            ),

                            const SizedBox(height: 32),

                            // Delete Button
                            SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  DeleteProductModal.show(
                                    context: context,
                                    productName: product.name,
                                    onDelete: () {
                                      context.read<ProductBloc>().add(
                                        ProductDeleteEvent(
                                          productId: product.id,
                                          businessId:
                                              UserService().user!.businessId,
                                        ),
                                      );
                                    },
                                  );
                                },
                                icon: HugeIcon(
                                  icon: HugeIcons.strokeRoundedDelete02,
                                  color: Colors.red,
                                  size: 20,
                                ),
                                label: const Text('Delete Product'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.red,
                                  side: const BorderSide(color: Colors.red),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 50),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
