import 'package:fpdart/fpdart.dart' as fpdart;
import 'package:ventura/core/data/models/failure.dart';
import 'package:ventura/core/domain/use_cases/use_case.dart';
import 'package:ventura/features/sales/domain/repositories/product_repository.dart';

class SearchResources
    implements UseCase<Map<String, dynamic>, SearchResourcesParams> {
  final ProductRepository productRepository;

  SearchResources({required this.productRepository});

  @override
  Future<fpdart.Either<Failure, Map<String, dynamic>>> call(
    SearchResourcesParams params,
  ) async {
    return await productRepository.searchResources(
      businessId: params.businessId,
      searchQuery: params.searchQuery,
      minPrice: params.minPrice,
      maxPrice: params.maxPrice,
      minQty: params.minQty,
      page: params.page,
      limit: params.limit,
    );
  }
}

class SearchResourcesParams {
  final String businessId;
  final String searchQuery;
  final double? minPrice;
  final double? maxPrice;
  final int? minQty;
  final int? page;
  final int? limit;

  SearchResourcesParams({
    required this.businessId,
    required this.searchQuery,
    this.minPrice,
    this.maxPrice,
    this.minQty,
    this.page,
    this.limit,
  });
}
