import 'package:fpdart/fpdart.dart';
import 'package:ventura/core/data/models/failure.dart';
import 'package:ventura/core/domain/entities/business_entity.dart';
import 'package:ventura/core/domain/entities/user_entity.dart';

abstract interface class UseCase<SuccessType, Params> {
  Future<Either<Failure, SuccessType>> call(Params params);
}

class NoParams {}

class UserParams {
  User user;

  UserParams({required this.user});
}

class BusinessParams {
  Business business;

  BusinessParams({required this.business});
}
