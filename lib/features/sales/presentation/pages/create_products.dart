import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ventura/core/domain/use_cases/asset_upload_image.dart';
import 'package:ventura/core/services/toast_service.dart';
import 'package:ventura/core/services/user_service.dart';
import 'package:ventura/features/sales/presentation/bloc/product_bloc.dart';
import 'package:ventura/features/sales/presentation/widgets/text_input_component.dart';
import 'package:ventura/init_dependencies.dart';

class CreateProducts extends StatefulWidget {
  const CreateProducts({super.key});

  @override
  State<CreateProducts> createState() => _CreateProductsState();
}

class _CreateProductsState extends State<CreateProducts> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _quantityController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _notesController = TextEditingController();

  late String _businessId;
  String? _primaryImageUrl;
  final List<String> _supportingImageUrls = [];
  bool _isUploadingPrimary = false;
  bool _isUploadingSupporting = false;

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

  void _submitForm(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      final name = _nameController.text.trim();
      final price = double.tryParse(_priceController.text.trim()) ?? 0.0;
      final quantity = int.tryParse(_quantityController.text.trim()) ?? 0;
      final description = _descriptionController.text.trim();
      final notes = _notesController.text.trim();

      context.read<ProductBloc>().add(
        ProductCreateEvent(
          businessId: _businessId,
          name: name,
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
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(8.0),
            child: const SizedBox(height: 8.0),
          ),
          title: Text(
            'Create Product',
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
          actions: [], // Removed actions
        ),
        body: SafeArea(
          child: BlocListener<ProductBloc, ProductState>(
            listener: (context, state) {
              if (state is ProductCreateSuccessState) {
                ToastService.showSuccess('Product created successfully');
                Navigator.of(context).pop();
              } else if (state is ProductErrorState) {
                ToastService.showError('Error: ${state.message}');
              }
            },
            child: SingleChildScrollView(
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
                      title: 'Price *',
                      hintText: '0.00',
                      controller: _priceController,
                      onSaved: (_) {},
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Price is required';
                        }
                        final price = double.tryParse(value.trim());
                        if (price == null || price < 0) {
                          return 'Please enter a valid price';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Quantity
                    TextInputComponent(
                      title: 'Available Quantity *',
                      hintText: '0',
                      controller: _quantityController,
                      onSaved: (_) {},
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Quantity is required';
                        }
                        final quantity = int.tryParse(value.trim());
                        if (quantity == null || quantity < 0) {
                          return 'Please enter a valid quantity';
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
                    Text(
                      'Product Images',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Primary Image
                    Text(
                      'Primary Image',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: _isUploadingPrimary
                          ? null
                          : () => _pickAndUploadImage(isPrimary: true),
                      child: Container(
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .surfaceContainerHighest
                              .withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Theme.of(context).colorScheme.outlineVariant,
                          ),
                          image: _primaryImageUrl != null
                              ? DecorationImage(
                                  image: NetworkImage(_primaryImageUrl!),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: _isUploadingPrimary
                            ? const Center(child: CircularProgressIndicator())
                            : _primaryImageUrl == null
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  HugeIcon(
                                    icon: HugeIcons.strokeRoundedImageUpload01,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    size: 32,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Tap to upload primary image',
                                    style: TextStyle(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                    ),
                                  ),
                                ],
                              )
                            : Stack(
                                children: [
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: IconButton.filled(
                                      onPressed: _removePrimaryImage,
                                      icon: const Icon(Icons.close),
                                      style: IconButton.styleFrom(
                                        backgroundColor: Colors.black
                                            .withOpacity(0.5),
                                        foregroundColor: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Supporting Images (Only visible if primary image is selected)
                    if (_primaryImageUrl != null) ...[
                      Text(
                        'Supporting Images',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 100,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            ..._supportingImageUrls.asMap().entries.map((
                              entry,
                            ) {
                              final index = entry.key;
                              final url = entry.value;
                              return Container(
                                width: 100,
                                margin: const EdgeInsets.only(right: 8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.outlineVariant,
                                  ),
                                  image: DecorationImage(
                                    image: NetworkImage(url),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Stack(
                                  children: [
                                    Positioned(
                                      top: 4,
                                      right: 4,
                                      child: GestureDetector(
                                        onTap: () =>
                                            _removeSupportingImage(index),
                                        child: Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            color: Colors.black.withOpacity(
                                              0.5,
                                            ),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.close,
                                            size: 14,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                            GestureDetector(
                              onTap: _isUploadingSupporting
                                  ? null
                                  : () => _pickAndUploadImage(isPrimary: false),
                              child: Container(
                                width: 100,
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .surfaceContainerHighest
                                      .withValues(alpha: 0.3),
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
                                    : Icon(
                                        Icons.add,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                        size: 32,
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: BlocBuilder<ProductBloc, ProductState>(
                        builder: (context, state) {
                          return ElevatedButton(
                            onPressed: state is ProductLoadingState
                                ? null
                                : () => _submitForm(context),
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
                            ),
                            child: state is ProductLoadingState
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    'Create Product',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
