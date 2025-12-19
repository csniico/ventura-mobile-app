import 'dart:io';
import 'package:fpdart/fpdart.dart';
import 'package:ventura/core/data/data_sources/remote/abstract_interfaces/assets_remote_data_source.dart';
import 'package:ventura/core/data/models/failure.dart';
import 'package:ventura/core/data/models/server_exception.dart';
import 'package:ventura/core/domain/repositories/assets_repository.dart';

class AssetsRepositoryImpl implements AssetsRepository {
  final AssetsRemoteDataSource assetsRemoteDataSource;

  AssetsRepositoryImpl({required this.assetsRemoteDataSource});

  @override
  Future<Either<Failure, String>> uploadImageAsset({required File file}) async {
    try {
      final imageUrl = await assetsRemoteDataSource.uploadImageAsset(
        file: file,
      );
      return right(imageUrl);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
