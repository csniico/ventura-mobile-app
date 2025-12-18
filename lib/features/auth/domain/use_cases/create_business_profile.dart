import 'package:fpdart/fpdart.dart';
import 'package:ventura/core/data/models/failure.dart';
import 'package:ventura/core/domain/entities/business_entity.dart';
import 'package:ventura/core/domain/use_cases/use_case.dart';

class CreateBusinessProfile implements UseCase<String, CreateBusinessProfileParams>{
  @override
  Future<Either<Failure, String>> call(CreateBusinessProfileParams params) async {
    // TODO: implement call
    throw UnimplementedError();
  }
}

class CreateBusinessProfileParams {
  final Business business;

  CreateBusinessProfileParams({required this.business});
}