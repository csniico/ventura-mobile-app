import 'package:fpdart/fpdart.dart' as fpdart;
import 'package:ventura/core/data/models/failure.dart';
import 'package:ventura/core/domain/use_cases/use_case.dart';
import 'package:ventura/features/sales/domain/entities/product_entity.dart';
import 'package:ventura/features/sales/domain/repositories/product_repository.dart';

class GetProductById implements UseCase<Product, GetProductByIdParams> {
  final ProductRepository productRepository;

  GetProductById({required this.productRepository});

  @override
  Future<fpdart.Either<Failure, Product>> call(
    GetProductByIdParams params,
  ) async {
    return await productRepository.getProductById(
      productId: params.productId,
      businessId: params.businessId,
    );
  }
}

class GetProductByIdParams {
  final String productId;
  final String businessId;

  GetProductByIdParams({required this.productId, required this.businessId});
}
