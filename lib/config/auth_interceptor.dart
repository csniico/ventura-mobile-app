import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:ventura/config/server_routes.dart';
import 'package:ventura/core/services/user_service.dart';

/// Interceptor that automatically refreshes JWT tokens when they expire
class AuthInterceptor extends Interceptor {
  final Dio dio;
  final ServerRoutes routes = ServerRoutes.instance;
  final UserService userService = UserService();

  bool _isRefreshing = false;
  final List<({RequestOptions request, ErrorInterceptorHandler handler})>
  _requestsQueue = [];

  AuthInterceptor(this.dio);

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Check if the error is 401 Unauthorized
    if (err.response?.statusCode == 401) {
      final requestOptions = err.requestOptions;

      debugPrint('🔒 AuthInterceptor: 401 error on ${requestOptions.path}');

      // Don't refresh token for auth endpoints themselves
      if (requestOptions.path.contains('/auth/signin') ||
          requestOptions.path.contains('/auth/signup') ||
          requestOptions.path.contains('/auth/refresh-token') ||
          requestOptions.path.contains('/auth/google')) {
        debugPrint('🔒 AuthInterceptor: Skipping auth endpoint');
        return handler.next(err);
      }

      // If already refreshing, queue this request
      if (_isRefreshing) {
        debugPrint('🔒 AuthInterceptor: Already refreshing, queuing request');
        _requestsQueue.add((request: requestOptions, handler: handler));
        return;
      }

      _isRefreshing = true;
      debugPrint('🔒 AuthInterceptor: Attempting token refresh...');

      try {
        // Attempt to refresh the token
        final response = await dio.post(
          '${routes.serverUrl}${routes.refreshToken}',
          options: Options(
            headers: requestOptions.headers,
            // Don't use this interceptor for the refresh request
            extra: {'skipAuthInterceptor': true},
          ),
        );

        if (response.statusCode == 200) {
          debugPrint('✅ AuthInterceptor: Token refreshed successfully');
          _isRefreshing = false;

          // Retry the original failed request
          final retryResponse = await _retry(requestOptions);
          handler.resolve(retryResponse);

          // Process queued requests
          debugPrint(
            '🔒 AuthInterceptor: Processing ${_requestsQueue.length} queued requests',
          );
          for (final queued in _requestsQueue) {
            try {
              final queuedResponse = await _retry(queued.request);
              queued.handler.resolve(queuedResponse);
            } catch (e) {
              queued.handler.reject(
                DioException(requestOptions: queued.request, error: e),
              );
            }
          }
          _requestsQueue.clear();
          return;
        }
      } on DioException catch (refreshError) {
        _isRefreshing = false;
        debugPrint(
          '❌ AuthInterceptor: Refresh failed with ${refreshError.response?.statusCode}',
        );

        // If refresh fails with 401/403, user needs to sign in again
        if (refreshError.response?.statusCode == 401 ||
            refreshError.response?.statusCode == 403) {
          debugPrint('🚪 AuthInterceptor: Signing out user');
          // Clear user session
          await userService.signOut();

          // Reject all queued requests
          for (final queued in _requestsQueue) {
            queued.handler.reject(refreshError);
          }
          _requestsQueue.clear();

          return handler.reject(refreshError);
        }

        // For other errors, just pass through
        _requestsQueue.clear();
        return handler.reject(refreshError);
      } catch (e) {
        _isRefreshing = false;
        debugPrint('❌ AuthInterceptor: Unexpected error: $e');

        // Reject all queued requests
        for (final queued in _requestsQueue) {
          queued.handler.reject(
            DioException(requestOptions: queued.request, error: e),
          );
        }
        _requestsQueue.clear();
        return handler.reject(err);
      }
    }

    return handler.next(err);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Skip this interceptor for refresh token requests
    if (options.extra['skipAuthInterceptor'] == true) {
      return handler.next(options);
    }
    return handler.next(options);
  }

  /// Retry a request after token refresh
  Future<Response> _retry(RequestOptions requestOptions) async {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );

    return dio.request(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }
}
