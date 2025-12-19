import 'dart:io';
import 'package:fpdart/fpdart.dart';
import 'package:ventura/core/data/models/failure.dart';
import 'package:ventura/core/domain/repositories/assets_repository.dart';
import 'package:ventura/core/domain/use_cases/use_case.dart';

class AssetUploadImage implements UseCase<String, AssetUploadImageParams> {
  final AssetsRepository assetsRepository;

  AssetUploadImage({required this.assetsRepository});

  @override
  Future<Either<Failure, String>> call(AssetUploadImageParams params) async {
    return await assetsRepository.uploadImageAsset(file: params.file);
  }
}

class AssetUploadImageParams {
  final File file;

  AssetUploadImageParams({required this.file});
}
