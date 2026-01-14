import 'package:fpdart/fpdart.dart' as fpdart;
import 'package:ventura/core/data/models/failure.dart';
import 'package:ventura/core/domain/use_cases/use_case.dart';
import 'package:ventura/features/sales/domain/entities/product_entity.dart';
import 'package:ventura/features/sales/domain/repositories/product_repository.dart';

class CreateProduct implements UseCase<Product, CreateProductParams> {
  final ProductRepository productRepository;

  CreateProduct({required this.productRepository});

  @override
  Future<fpdart.Either<Failure, Product>> call(
    CreateProductParams params,
  ) async {
    return await productRepository.createProduct(
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

class CreateProductParams {
  final String businessId;
  final String name;
  final double price;
  final int availableQuantity;
  final String? primaryImage;
  final List<String>? supportingImages;
  final String? description;
  final String? notes;

  CreateProductParams({
    required this.businessId,
    required this.name,
    required this.price,
    required this.availableQuantity,
    this.primaryImage,
    this.supportingImages,
    this.description,
    this.notes,
  });
}
