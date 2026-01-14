import 'package:dio/dio.dart';
import 'package:ventura/config/app_logger.dart';
import 'package:ventura/config/server_routes.dart';
import 'package:ventura/features/sales/data/data_sources/remote/abstract_interfaces/product_remote_data_source.dart';
import 'package:ventura/features/sales/data/models/product_model.dart';

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final Dio dio;
  final routes = ServerRoutes.instance;
  final logger = AppLogger('ProductRemoteDataSourceImpl');

  ProductRemoteDataSourceImpl({required this.dio});

  @override
  Future<Map<String, dynamic>?> searchResources({
    required String businessId,
    required String searchQuery,
    double? minPrice,
    double? maxPrice,
    int? minQty,
    int? page,
    int? limit,
  }) async {
    try {
      final response = await dio.get(
        '${routes.serverUrl}${routes.searchResources}',
        queryParameters: {
          'businessId': businessId,
          'q': searchQuery,
          'filters': (minPrice != null || maxPrice != null || minQty != null)
              ? 'on'
              : 'off',
          if (minPrice != null) 'minPrice': minPrice,
          if (maxPrice != null) 'maxPrice': maxPrice,
          if (minQty != null) 'minQty': minQty,
          'page': page ?? 1,
          'limit': limit ?? 10,
        },
      );
      logger.info(response.data.toString());
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      logger.error(e.response.toString());
      return null;
    }
  }

  @override
  Future<ProductModel?> getProductById({
    required String productId,
    required String businessId,
  }) async {
    try {
      final response = await dio.get(
        '${routes.serverUrl}${routes.getResources}',
        queryParameters: {
          'businessId': businessId,
          'type': 'product',
          'filter': 'one',
          'resourceId': productId,
        },
      );
      logger.info(response.data.toString());
      return ProductModel.fromJson(response.data);
    } on DioException catch (e) {
      logger.error(e.response.toString());
      return null;
    }
  }

  @override
  Future<ProductModel?> createProduct({
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
      final response = await dio.post(
        '${routes.serverUrl}${routes.createProduct}',
        data: {
          'businessId': businessId,
          'name': name,
          'price': price,
          'availableQuantity': availableQuantity,
          if (primaryImage != null) 'primaryImage': primaryImage,
          if (supportingImages != null) 'supportingImages': supportingImages,
          if (description != null) 'description': description,
          if (notes != null) 'notes': notes,
        },
      );
      logger.info(response.data.toString());
      return ProductModel.fromJson(response.data);
    } on DioException catch (e) {
      logger.error(e.response.toString());
      return null;
    }
  }

  @override
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
  }) async {
    try {
      final response = await dio.put(
        '${routes.serverUrl}${routes.updateProduct(productId)}',
        queryParameters: {'businessId': businessId},
        data: {
          if (name != null) 'name': name,
          if (price != null) 'price': price,
          if (availableQuantity != null) 'availableQuantity': availableQuantity,
          if (primaryImage != null) 'primaryImage': primaryImage,
          if (supportingImages != null) 'supportingImages': supportingImages,
          if (description != null) 'description': description,
          if (notes != null) 'notes': notes,
        },
      );
      logger.info(response.data.toString());
      return ProductModel.fromJson(response.data);
    } on DioException catch (e) {
      logger.error(e.response.toString());
      return null;
    }
  }

  @override
  Future<String?> deleteProduct({
    required String productId,
    required String businessId,
  }) async {
    try {
      final response = await dio.delete(
        '${routes.serverUrl}${routes.deleteProduct(productId)}',
        queryParameters: {'businessId': businessId},
      );
      logger.info(response.data.toString());
      if (response.data is Map<String, dynamic>) {
        return response.data['message'] as String?;
      }
      return response.data as String?;
    } on DioException catch (e) {
      logger.error(e.response.toString());
      return null;
    }
  }
}
