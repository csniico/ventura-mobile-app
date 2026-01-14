import 'package:fpdart/fpdart.dart' as fpdart;
import 'package:ventura/core/data/models/failure.dart';
import 'package:ventura/core/domain/use_cases/use_case.dart';
import 'package:ventura/features/sales/domain/repositories/product_repository.dart';

class DeleteProduct implements UseCase<String, DeleteProductParams> {
  final ProductRepository productRepository;

  DeleteProduct({required this.productRepository});

  @override
  Future<fpdart.Either<Failure, String>> call(
    DeleteProductParams params,
  ) async {
    return await productRepository.deleteProduct(
      productId: params.productId,
      businessId: params.businessId,
    );
  }
}

class DeleteProductParams {
  final String productId;
  final String businessId;

  DeleteProductParams({required this.productId, required this.businessId});
}
