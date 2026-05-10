import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../utils/constants/app_const.dart';
import '../../utils/errors/app_exceptions.dart';

/// API Manager for handling HTTP requests
class ApiManager {
  late Dio _dio;

  ApiManager() {
    _initializeDio();
  }

  /// Initialize Dio instance
  void _initializeDio() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConstant.baseUrl,
        connectTimeout: AppConstant.apiTimeout,
        receiveTimeout: AppConstant.apiTimeout,
        contentType: 'application/json',
        headers: {'Accept': 'application/json'},
      ),
    );

    // Add interceptors
    _dio.interceptors.addAll([LoggingInterceptor(), ErrorInterceptor()]);
  }

  /// GET request
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on DioException catch (e) {
      throw NetworkException(
        message: e.message ?? 'Network error',
        code: e.response?.statusCode.toString(),
        originalException: e,
      );
    }
  }

  /// POST request
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on DioException catch (e) {
      throw NetworkException(
        message: e.message ?? 'Network error',
        code: e.response?.statusCode.toString(),
        originalException: e,
      );
    }
  }

  /// PUT request
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on DioException catch (e) {
      throw NetworkException(
        message: e.message ?? 'Network error',
        code: e.response?.statusCode.toString(),
        originalException: e,
      );
    }
  }

  /// PATCH request
  Future<Response> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on DioException catch (e) {
      throw NetworkException(
        message: e.message ?? 'Network error',
        code: e.response?.statusCode.toString(),
        originalException: e,
      );
    }
  }

  /// DELETE request
  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } on DioException catch (e) {
      throw NetworkException(
        message: e.message ?? 'Network error',
        code: e.response?.statusCode.toString(),
        originalException: e,
      );
    }
  }

  /// Download file
  Future<Response> download(
    String path,
    String savePath, {
    ProgressCallback? onReceiveProgress,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.download(
        path,
        savePath,
        onReceiveProgress: onReceiveProgress,
        cancelToken: cancelToken,
      );
      return response;
    } on DioException catch (e) {
      throw NetworkException(
        message: e.message ?? 'Download error',
        code: e.response?.statusCode.toString(),
        originalException: e,
      );
    }
  }

  /// Set authorization header
  void setAuthorizationHeader(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  /// Remove authorization header
  void removeAuthorizationHeader() {
    _dio.options.headers.remove('Authorization');
  }

  /// Get Dio instance
  Dio get dio => _dio;
}

/// Logging interceptor
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    debugPrint('🌐 REQUEST: ${options.method} ${options.path}');
    debugPrint('   Headers: ${options.headers}');
    debugPrint('   Data: ${options.data}');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint(
        '✅ RESPONSE: ${response.statusCode} ${response.requestOptions.path}');
    debugPrint('   Data: ${response.data}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    debugPrint(
        '❌ ERROR: ${err.response?.statusCode} ${err.requestOptions.path}');
    debugPrint('   Message: ${err.message}');
    debugPrint('   Error: ${err.error}');
    super.onError(err, handler);
  }
}

/// Error interceptor
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Handle specific error codes
    if (err.response != null) {
      switch (err.response!.statusCode) {
        case 401:
          // Handle unauthorized
          break;
        case 403:
          // Handle forbidden
          break;
        case 404:
          // Handle not found
          break;
        case 500:
          // Handle server error
          break;
      }
    }
    super.onError(err, handler);
  }
}
