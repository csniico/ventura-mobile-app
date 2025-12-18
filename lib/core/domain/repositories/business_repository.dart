import 'package:fpdart/fpdart.dart';
import 'package:ventura/core/data/models/failure.dart';
import 'package:ventura/core/domain/entities/business_entity.dart';

abstract interface class BusinessRepository {
  Future<Either<Failure, Business>> localGetBusiness();

  Future<Either<Failure, Business>> localSaveBusiness({
    required Business business,
  });

  Future<void> clearBusiness();
}
