import 'package:ventura/features/sales/data/models/product_model.dart';

abstract interface class ProductRemoteDataSource {
  Future<Map<String, dynamic>?> searchResources({
    required String businessId,
    required String searchQuery,
    double? minPrice,
    double? maxPrice,
    int? minQty,
    int? page,
    int? limit,
  });

  Future<ProductModel?> getProductById({
    required String productId,
    required String businessId,
  });

  Future<ProductModel?> createProduct({
    required String businessId,
    required String name,
    required double price,
    required int availableQuantity,
    String? primaryImage,
    List<String>? supportingImages,
    String? description,
    String? notes,
  });

  Future<ProductModel?> updateProduct({
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

  Future<String?> deleteProduct({
    required String productId,
    required String businessId,
  });
}
