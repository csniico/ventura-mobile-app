import 'package:dio/dio.dart';
import 'package:ventura/core/common/app_logger.dart';

class ServerException implements Exception {
  final logger = AppLogger('ServerException');
  final int statusCode;
  final String status;
  final String message;

  ServerException({
    required this.statusCode,
    required this.status,
    required this.message,
  });

  factory ServerException.fromDioError(DioException e) {
    final response = e.response;

    if (response != null && response.data != null) {
      final statusCode = response.statusCode ?? 500;
      final data = response.data;

      // Handle NestJS class-validator errors (array of messages)
      if (data is Map<String, dynamic>) {
        final message = data['message'];

        if (message is List) {
          // class-validator returns array of error messages
          return ServerException(
            statusCode: statusCode,
            status: data['error'] ?? _getStatusText(statusCode),
            message: message.join(', '),
          );
        } else if (message is String) {
          // Single error message
          return ServerException(
            statusCode: statusCode,
            status: data['error'] ?? _getStatusText(statusCode),
            message: message,
          );
        }

        // Fallback for other map structures
        return ServerException(
          statusCode: statusCode,
          status: data['error'] ?? _getStatusText(statusCode),
          message: data.toString(),
        );
      }

      // Handle string responses
      if (data is String) {
        return ServerException(
          statusCode: statusCode,
          status: _getStatusText(statusCode),
          message: data,
        );
      }
    }

    // Handle network/connection errors
    return ServerException(
      statusCode: 0,
      status: 'Network Error',
      message: e.message ?? 'Connection failed',
    );
  }

  static String _getStatusText(int statusCode) {
    switch (statusCode) {
      case 400:
        return 'Bad Request';
      case 401:
        return 'Unauthorized';
      case 403:
        return 'Forbidden';
      case 404:
        return 'Not Found';
      case 409:
        return 'Conflict';
      case 422:
        return 'Unprocessable Entity';
      case 500:
        return 'Internal Server Error';
      case 502:
        return 'Bad Gateway';
      case 503:
        return 'Service Unavailable';
      default:
        return 'Error';
    }
  }

  @override
  String toString() => '$status ($statusCode): $message';
}