import 'package:dio/dio.dart';

class ServerException implements Exception {
  final String message;

  ServerException({required this.message});

  factory ServerException.fromDioError(DioException e) {
    if (e.response != null && e.response?.data is Map) {
      return ServerException(
        message: e.response!.data['message'] ?? 'Server error',
      );
    } else {
      return ServerException(
        message: e.message ?? 'Unknown error',
      );
    }
  }
}