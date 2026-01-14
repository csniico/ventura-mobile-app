import 'package:fpdart/fpdart.dart' as fpdart;
import 'package:ventura/core/data/models/failure.dart';
import 'package:ventura/features/sales/domain/entities/product_entity.dart';

abstract interface class ProductRepository {
  Future<fpdart.Either<Failure, Map<String, dynamic>>> searchResources({
    required String businessId,
    required String searchQuery,
    double? minPrice,
    double? maxPrice,
    int? minQty,
    int? page,
    int? limit,
  });

  Future<fpdart.Either<Failure, Product>> getProductById({
    required String productId,
    required String businessId,
  });

  Future<fpdart.Either<Failure, Product>> createProduct({
    required String businessId,
    required String name,
    required double price,
    required int availableQuantity,
    String? primaryImage,
    List<String>? supportingImages,
    String? description,
    String? notes,
  });

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
  });

  Future<fpdart.Either<Failure, String>> deleteProduct({
    required String productId,
    required String businessId,
  });
}
