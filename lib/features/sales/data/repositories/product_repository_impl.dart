import 'package:fpdart/fpdart.dart' as fpdart;
import 'package:ventura/config/app_logger.dart';
import 'package:ventura/core/data/models/failure.dart';
import 'package:ventura/features/sales/data/data_sources/remote/abstract_interfaces/product_remote_data_source.dart';
import 'package:ventura/features/sales/domain/entities/product_entity.dart';
import 'package:ventura/features/sales/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource productRemoteDataSource;
  final logger = AppLogger('ProductRepositoryImpl');

  ProductRepositoryImpl({required this.productRemoteDataSource});

  @override
  Future<fpdart.Either<Failure, Map<String, dynamic>>> searchResources({
    required String businessId,
    required String searchQuery,
    double? minPrice,
    double? maxPrice,
    int? minQty,
    int? page,
    int? limit,
  }) async {
    try {
      final result = await productRemoteDataSource.searchResources(
        businessId: businessId,
        searchQuery: searchQuery,
        minPrice: minPrice,
        maxPrice: maxPrice,
        minQty: minQty,
        page: page,
        limit: limit,
      );
      if (result == null) {
        return fpdart.left(Failure('Failed to search resources'));
      }
      return fpdart.right(result);
    } catch (e) {
      logger.error('Error searching resources: $e');
      return fpdart.left(Failure('Failed to search resources'));
    }
  }

  @override
  Future<fpdart.Either<Failure, Product>> getProductById({
    required String productId,
    required String businessId,
  }) async {
    try {
      final product = await productRemoteDataSource.getProductById(
        productId: productId,
        businessId: businessId,
      );
      if (product == null) {
        return fpdart.left(Failure('Product not found'));
      }
      return fpdart.right(product.toEntity());
    } catch (e) {
      logger.error('Error fetching product: $e');
      return fpdart.left(Failure('Failed to fetch product'));
    }
  }

  @override
  Future<fpdart.Either<Failure, Product>> createProduct({
    required String businessId,
    required String name,
    required double price,
    required int availableQuantity,
    String? primaryImage,
    List<String>? supportingImages,
    String? description,
    String? notes,
  }) async {
    try {
      final product = await productRemoteDataSource.createProduct(
        businessId: businessId,
        name: name,
        price: price,
        availableQuantity: availableQuantity,
        primaryImage: primaryImage,
        supportingImages: supportingImages,
        description: description,
        notes: notes,
      );
      if (product == null) {
        return fpdart.left(Failure('Failed to create product'));
      }
      return fpdart.right(product.toEntity());
    } catch (e) {
      logger.error('Error creating product: $e');
      return fpdart.left(Failure('Failed to create product'));
    }
  }

  @override
  Future<fpdart.Either<Failure, Product>> updateProduct({
    required String productId,
    required String businessId,
    String? name,
    double? price,
    int? availableQuantity,
    String? primaryImage,
    List<String>? supportingImages,
    String? description,
    String? notes,
  }) async {
    try {
      final product = await productRemoteDataSource.updateProduct(
        productId: productId,
        businessId: businessId,
        name: name,
        price: price,
        availableQuantity: availableQuantity,
        primaryImage: primaryImage,
        supportingImages: supportingImages,
        description: description,
        notes: notes,
      );
      if (product == null) {
        return fpdart.left(Failure('Failed to update product'));
      }
      return fpdart.right(product.toEntity());
    } catch (e) {
      logger.error('Error updating product: $e');
      return fpdart.left(Failure('Failed to update product'));
    }
  }

  @override
  Future<fpdart.Either<Failure, String>> deleteProduct({
    required String productId,
    required String businessId,
  }) async {
    try {
      final result = await productRemoteDataSource.deleteProduct(
        productId: productId,
        businessId: businessId,
      );
      if (result == null) {
        return fpdart.left(Failure('Failed to delete product'));
      }
      return fpdart.right(result);
    } catch (e) {
      logger.error('Error deleting product: $e');
      return fpdart.left(Failure('Failed to delete product'));
    }
  }
}
