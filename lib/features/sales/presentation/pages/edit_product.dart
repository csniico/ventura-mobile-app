import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ventura/core/domain/use_cases/asset_upload_image.dart';
import 'package:ventura/core/services/toast_service.dart';
import 'package:ventura/core/services/user_service.dart';
import 'package:ventura/features/sales/presentation/bloc/product_bloc.dart';
import 'package:ventura/features/sales/presentation/widgets/text_input_component.dart';
import 'package:ventura/init_dependencies.dart';

import 'package:ventura/features/sales/domain/entities/product_entity.dart';

class EditProduct extends StatefulWidget {
  const EditProduct({super.key, required this.product});
  final Product product;

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

  String? _primaryImageUrl;
  List<String> _supportingImageUrls = [];
  bool _isUploadingPrimary = false;
  bool _isUploadingSupporting = false;

  @override
  void initState() {
    super.initState();
    _populateForm();
  }

  void _populateForm() {
    final product = widget.product;
    _nameController.text = product.name;
    _priceController.text = product.price.toString();
    _quantityController.text = product.availableQuantity.toString();
    _descriptionController.text = product.description ?? '';
    _notesController.text = product.notes ?? '';
    _primaryImageUrl = product.primaryImage;
    _supportingImageUrls = List.from(product.supportingImages ?? []);
  }

  Future<void> _pickAndUploadImage({bool isPrimary = true}) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      if (!mounted) return;
      setState(() {
        if (isPrimary) {
          _isUploadingPrimary = true;
        } else {
          _isUploadingSupporting = true;
        }
      });

      final File file = File(image.path);
      final result = await serviceLocator<AssetUploadImage>().call(
        AssetUploadImageParams(file: file),
      );

      if (!mounted) return;

      result.fold(
        (failure) {
          ToastService.showError('Failed to upload image: ${failure.message}');
        },
        (url) {
          setState(() {
            if (isPrimary) {
              _primaryImageUrl = url;
            } else {
              _supportingImageUrls.add(url);
            }
          });
        },
      );

      setState(() {
        if (isPrimary) {
          _isUploadingPrimary = false;
        } else {
          _isUploadingSupporting = false;
        }
      });
    }
  }

  void _removeSupportingImage(int index) {
    setState(() {
      _supportingImageUrls.removeAt(index);
    });
  }

  void _removePrimaryImage() {
    setState(() {
      _primaryImageUrl = null;
    });
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

  void _submitForm(BuildContext blocContext) {
    if (_formKey.currentState?.validate() ?? false) {
      final name = _nameController.text.trim();
      final price = double.tryParse(_priceController.text.trim());
      final quantity = int.tryParse(_quantityController.text.trim());
      final description = _descriptionController.text.trim();
      final notes = _notesController.text.trim();

      blocContext.read<ProductBloc>().add(
        ProductUpdateEvent(
          productId: widget.product.id,
          businessId: UserService().user!.businessId,
          name: name.isNotEmpty ? name : null,
          price: price,
          availableQuantity: quantity,
          description: description.isNotEmpty ? description : null,
          notes: notes.isNotEmpty ? notes : null,
          primaryImage: _primaryImageUrl,
          supportingImages: _supportingImageUrls.isNotEmpty
              ? _supportingImageUrls
              : null,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<ProductBloc>(),
      child: BlocListener<ProductBloc, ProductState>(
        listener: (context, state) {
          if (state is ProductUpdateSuccessState) {
            ToastService.showSuccess('Product updated successfully');
            Navigator.of(context).pop(true);
          } else if (state is ProductErrorState) {
            ToastService.showError('Error: ${state.message}');
          }
        },
        child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(8.0),
              child: const SizedBox(height: 8.0),
            ),
            title: Text(
              'Edit Product',
              style: TextStyle(
                fontSize: 20,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            leading: IconButton(
              icon: HugeIcon(
                icon: HugeIcons.strokeRoundedArrowLeft01,
                color: Theme.of(context).colorScheme.onPrimary,
                size: 30,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: SafeArea(
            child: Builder(
              builder: (blocContext) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
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
                          keyboardType: const TextInputType.numberWithOptions(
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
                        const SizedBox(height: 24),

                        // Image Section
                        SizedBox(
                          width: double.infinity,
                          child: Text(
                            'Product Images',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Primary Image
                        SizedBox(
                          width: double.infinity,
                          child: Text(
                            'Primary Image',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Center(
                          child: GestureDetector(
                            onTap: () => _pickAndUploadImage(isPrimary: true),
                            child: Container(
                              height: 200,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).colorScheme.surfaceContainerLow,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.outlineVariant,
                                ),
                                image: _primaryImageUrl != null
                                    ? DecorationImage(
                                        image: NetworkImage(_primaryImageUrl!),
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                              ),
                              child: _isUploadingPrimary
                                  ? const Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : _primaryImageUrl == null
                                  ? Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          HugeIcon(
                                            icon: HugeIcons
                                                .strokeRoundedImageUpload,
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.primary,
                                            size: 32,
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'Upload Primary Image',
                                            style: TextStyle(
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.primary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Stack(
                                      children: [
                                        Positioned(
                                          top: 8,
                                          right: 8,
                                          child: GestureDetector(
                                            onTap: _removePrimaryImage,
                                            child: Container(
                                              padding: const EdgeInsets.all(4),
                                              decoration: BoxDecoration(
                                                color: Colors.black54,
                                                shape: BoxShape.circle,
                                              ),
                                              child: const HugeIcon(
                                                icon: HugeIcons
                                                    .strokeRoundedDelete02,
                                                color: Colors.white,
                                                size: 20,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Supporting Images
                        SizedBox(
                          width: double.infinity,
                          child: Text(
                            'Supporting Images',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                ),
                          ),
                        ),
                        const SizedBox(height: 8),

                        if (_supportingImageUrls.isEmpty)
                          GestureDetector(
                            onTap: () => _pickAndUploadImage(isPrimary: false),
                            child: Container(
                              height: 100,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).colorScheme.surfaceContainerLow,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.outlineVariant,
                                ),
                              ),
                              child: _isUploadingSupporting
                                  ? const Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        HugeIcon(
                                          icon:
                                              HugeIcons.strokeRoundedImageAdd02,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onSurfaceVariant,
                                          size: 24,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Add supporting images',
                                          style: TextStyle(
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.onSurfaceVariant,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          )
                        else
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 8,
                                  mainAxisSpacing: 8,
                                ),
                            itemCount: _supportingImageUrls.length + 1,
                            itemBuilder: (context, index) {
                              if (index == _supportingImageUrls.length) {
                                return GestureDetector(
                                  onTap: () =>
                                      _pickAndUploadImage(isPrimary: false),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.surfaceContainerLow,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.outlineVariant,
                                      ),
                                    ),
                                    child: _isUploadingSupporting
                                        ? const Center(
                                            child: CircularProgressIndicator(),
                                          )
                                        : const Center(
                                            child: HugeIcon(
                                              icon: HugeIcons
                                                  .strokeRoundedImageAdd02,
                                              color: Colors.grey,
                                              size: 24,
                                            ),
                                          ),
                                  ),
                                );
                              }

                              return Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      _supportingImageUrls[index],
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: double.infinity,
                                    ),
                                  ),
                                  Positioned(
                                    top: 4,
                                    right: 4,
                                    child: GestureDetector(
                                      onTap: () =>
                                          _removeSupportingImage(index),
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: Colors.black54,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const HugeIcon(
                                          icon: HugeIcons.strokeRoundedDelete02,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        const SizedBox(height: 32),

                        // Submit Button
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: () => _submitForm(blocContext),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.primary,
                              foregroundColor: Theme.of(
                                context,
                              ).colorScheme.onPrimary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'Save Changes',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
