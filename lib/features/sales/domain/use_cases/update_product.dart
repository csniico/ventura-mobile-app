import 'package:fpdart/fpdart.dart' as fpdart;
import 'package:ventura/core/data/models/failure.dart';
import 'package:ventura/core/domain/use_cases/use_case.dart';
import 'package:ventura/features/sales/domain/entities/product_entity.dart';
import 'package:ventura/features/sales/domain/repositories/product_repository.dart';

class UpdateProduct implements UseCase<Product, UpdateProductParams> {
  final ProductRepository productRepository;

  UpdateProduct({required this.productRepository});

  @override
  Future<fpdart.Either<Failure, Product>> call(
    UpdateProductParams params,
  ) async {
    return await productRepository.updateProduct(
      productId: params.productId,
      businessId: params.businessId,
      name: params.name,
      price: params.price,
      availableQuantity: params.availableQuantity,
      primaryImage: params.primaryImage,
      supportingImages: params.supportingImages,
      description: params.description,
      notes: params.notes,
    );
  }
}

class UpdateProductParams {
  final String productId;
  final String businessId;
  final String? name;
  final double? price;
  final int? availableQuantity;
  final String? primaryImage;
  final List<String>? supportingImages;
  final String? description;
  final String? notes;

  UpdateProductParams({
    required this.productId,
    required this.businessId,
    this.name,
    this.price,
    this.availableQuantity,
    this.primaryImage,
    this.supportingImages,
    this.description,
    this.notes,
  });
}
