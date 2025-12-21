import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ventura/core/common/app_logger.dart';
import 'package:ventura/core/data/data_sources/remote/abstract_interfaces/assets_remote_data_source.dart';
import 'package:ventura/core/common/server_routes.dart';
import 'package:ventura/core/data/models/server_exception.dart';

class AssetsRemoteDataSourceImpl implements AssetsRemoteDataSource {
  final Dio dio;
  final routes = ServerRoutes.instance;
  final logger = AppLogger('AssetsRemoteDataSourceImpl');

  AssetsRemoteDataSourceImpl({required this.dio});

  @override
  Future<String> uploadImageAsset({required File file}) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          file.path,
          filename: file.path.split('/').last,
        ),
      });
      final response = await dio.post(
        '${routes.serverUrl}${routes.uploadImageAsset}',
        data: formData,
        options: Options(headers: {'Content-Type': 'multipart/form-data'}),
      );
      if (response.statusCode == 200) {
        final imageUrl = response.data['imageUrl'] as String;
        return imageUrl;
      } else {
        throw ServerException(
          statusCode: response.statusCode!,
          status: response.statusMessage!,
          message:
              'Failed to upload image asset. Status code: ${response.statusCode}',
        );
      }
    } on DioException catch (error) {
      logger.error(error.response!.data.toString());
      throw ServerException.fromDioError(error);
    }
  }
}
