import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:ventura/core/data/models/failure.dart';

abstract interface class AssetsRepository {
  Future<Either<Failure, String>> uploadImageAsset({required File file});
}
