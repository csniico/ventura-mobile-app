import 'package:fpdart/fpdart.dart';
import 'package:ventura/core/data/data_sources/local/abstract_interfaces/business_local_data_source.dart';
import 'package:ventura/core/data/models/business_model.dart';
import 'package:ventura/core/data/models/failure.dart';
import 'package:ventura/core/domain/entities/business_entity.dart';
import 'package:ventura/core/domain/repositories/business_repository.dart';

class BusinessRepositoryImpl implements BusinessRepository {
  final BusinessLocalDataSource businessLocalDataSource;

  BusinessRepositoryImpl({required this.businessLocalDataSource});

  @override
  Future<void> clearBusiness() async {
    return await businessLocalDataSource.clearBusiness();
  }

  @override
  Future<Either<Failure, Business>> localGetBusiness() async {
    try {
      final res = await businessLocalDataSource.getBusiness();
      if (res == null) {
        return left(Failure('No business found.'));
      }
      return right(res.toEntity());
    } catch (e) {
      return left(Failure('Failed to save business locally'));
    }
  }

  @override
  Future<Either<Failure, Business>> localSaveBusiness({
    required Business business,
  }) async {
    try {
      final res = await businessLocalDataSource.saveBusiness(
        BusinessModel.fromEntity(business),
      );
      return right(res.toEntity());
    } catch (e) {
      return left(Failure('Failed to save business locally'));
    }
  }
}
