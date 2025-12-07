import 'package:fpdart/fpdart.dart';
import 'package:ventura/core/models/failure/failure.dart';

abstract interface class UseCase<SuccessType, Params> {
  Future<Either<Failure, SuccessType>> call(Params params);
}
