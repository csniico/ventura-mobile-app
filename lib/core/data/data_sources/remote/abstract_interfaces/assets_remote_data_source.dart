import 'dart:io';

abstract interface class AssetsRemoteDataSource {
  Future<String> uploadImageAsset({required File file});
}
