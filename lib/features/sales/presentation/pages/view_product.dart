import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:ventura/core/presentation/widgets/adaptive_image.dart';
import 'package:ventura/core/presentation/widgets/ventura_app_bar/ventura_app_bar.dart';
import 'package:ventura/core/services/toast_service.dart';
import 'package:ventura/core/services/user_service.dart';
import 'package:ventura/features/sales/domain/entities/product_entity.dart';
import 'package:ventura/features/sales/presentation/bloc/product_bloc.dart';
import 'package:ventura/features/sales/presentation/pages/edit_product.dart';
import 'package:ventura/features/sales/presentation/widgets/delete_product_modal.dart';
import 'package:ventura/features/sales/presentation/widgets/detail_info_card.dart';
import 'package:ventura/init_dependencies.dart';

class ViewProduct extends StatefulWidget {
  const ViewProduct({super.key, required this.product});
  final Product product;

  @override
  State<ViewProduct> createState() => _ViewProductState();
}

class _ViewProductState extends State<ViewProduct> {
  late String _selectedImage;
  late final List<String> _galleryImages;

  static const List<String> _placeholderImages = [
    'assets/images/headphones.jpeg',
    'assets/images/shampoo.webp',
    'assets/images/macbook.webp',
    'assets/images/sneakers.jpg',
  ];

  @override
  void initState() {
    super.initState();

    final hasPrimary =
        widget.product.primaryImage != null &&
        widget.product.primaryImage!.isNotEmpty;
    final hasSupporting =
        widget.product.supportingImages != null &&
        widget.product.supportingImages!.isNotEmpty;

    // Main image: primary or a deterministic placeholder
    if (hasPrimary) {
      _selectedImage = widget.product.primaryImage!;
    } else {
      final int index = widget.product.name.length % _placeholderImages.length;
      _selectedImage = _placeholderImages[index];
    }

    // Gallery: primary first, then supporting or placeholders
    _galleryImages = [
      if (hasPrimary) widget.product.primaryImage!,
      if (hasSupporting) ...widget.product.supportingImages!,
      if (!hasSupporting) ..._placeholderImages,
    ];
  }

  String _formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy  h:mm a').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final product = widget.product;
    final isOutOfStock = widget.product.availableQuantity == 0;

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
          backgroundColor: theme.colorScheme.surface,
          appBar: VenturaAppBar(
            title: product.name.length > 20
                ? '${product.name.substring(0, 20)}...'
                : product.name,
            actions: [
              IconButton(
                icon: HugeIcon(
                  icon: HugeIcons.strokeRoundedPencilEdit02,
                  color: theme.appBarTheme.foregroundColor,
                  size: 26,
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => EditProduct(product: product),
                    ),
                  );
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImageCard(context),
                _buildGalleryStrip(context),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DetailInfoCard(
                        label: 'Product Name',
                        value: product.name,
                      ),
                      DetailInfoCard(
                        label: 'Unit Price',
                        value: 'GHS ${product.price.toStringAsFixed(2)}',
                      ),
                      DetailInfoCard(
                        label: 'Available Quantity',
                        value: isOutOfStock
                            ? 'Out of Stock'
                            : '${product.availableQuantity}',
                        valueColor: isOutOfStock ? Colors.red : null,
                      ),
                      DetailInfoCard(
                        label: 'Product Description',
                        value: product.description ?? 'No description provided',
                      ),
                      DetailInfoCard(
                        label: 'Notes',
                        value: product.notes ?? 'No notes provided',
                      ),
                      DetailInfoCard(
                        label: 'Product Description',
                        value: product.description ?? 'No description provided',
                      ),
                      DetailInfoCard(
                        label: 'Last Updated',
                        value: _formatDate(product.updatedAt),
                      ),
                      SizedBox(height: 16),
                    ],
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: SpeedDial(
            icon: Icons.more_vert,
            activeIcon: Icons.close,
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
            overlayColor: Colors.black,
            overlayOpacity: 0.4,
            spacing: 12,
            children: [
              SpeedDialChild(
                shape: const CircleBorder(),
                child: HugeIcon(
                  icon: HugeIcons.strokeRoundedPencilEdit02,
                  color: theme.colorScheme.onPrimary,
                  size: 20,
                ),
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => EditProduct(product: product),
                    ),
                  );
                },
              ),
              SpeedDialChild(
                shape: const CircleBorder(),
                child: HugeIcon(
                  icon: HugeIcons.strokeRoundedDelete02,
                  color: Colors.white,
                  size: 20,
                ),
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                onTap: () {
                  DeleteProductModal.show(
                    context: context,
                    productName: product.name,
                    onDelete: () {
                      context.read<ProductBloc>().add(
                        ProductDeleteEvent(
                          productId: product.id,
                          businessId: UserService().user!.businessId,
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      height: 280,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(5),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: AdaptiveImage(
          path: _selectedImage,
          fit: BoxFit.contain,
          width: double.infinity,
        ),
      ),
    );
  }

  Widget _buildGalleryStrip(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: SizedBox(
        height: 120,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: _galleryImages.length,
          separatorBuilder: (context, index) => const SizedBox(width: 8),
          itemBuilder: (context, index) {
            final path = _galleryImages[index];
            final isSelected = path == _selectedImage;
            return GestureDetector(
              onTap: () => setState(() => _selectedImage = path),
              child: Container(
                width: 105,
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Colors.transparent,
                    width: 2,
                  ),
                  image: DecorationImage(
                    image: AdaptiveImage.provider(path),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
