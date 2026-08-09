import 'dart:async';
import 'package:dio/dio.dart';
import 'package:ebazarx/app/app_routes.dart';
import 'package:ebazarx/app/app_routes_name.dart';
import 'package:ebazarx/common/utils/invalidate_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart';
import '../failures/failure.dart';
import '../services/auth_storage.dart';
import 'api_response.dart';

final apiClientProvider = Provider<ApiClient>((ref)=>ApiClient(ref: ref));

class ApiClient {
  final Dio _dio;
  final String baseUrl;
  final Logger _logger = Logger();
  final Ref ref;

  ApiClient({
    required this.ref,
    Dio? dio,
    this.baseUrl = "http://192.168.10.128:8000/api/v1",
  }) : _dio = dio ??
      Dio(
        BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          sendTimeout: const Duration(seconds: 30),
          contentType: Headers.jsonContentType,
          responseType: ResponseType.json,
        ),
      ) {
    _addInterceptors();
  }

  // ─── Interceptors ──────────────────────────────────────────────
  void _addInterceptors() {
    _dio.interceptors.clear();
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: _onRequest,
      onResponse: _onResponse,
      onError: _onError,
    ));
  }

  Future<void> _onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await AuthStorage.instance.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    _logRequest(options);
    return handler.next(options);
  }

  void _onResponse(Response response, ResponseInterceptorHandler handler) {
    _logResponse(response);
    return handler.next(response);
  }

  Future<void> _onError(DioException error, ErrorInterceptorHandler handler) async {
    _logError(error);
    // Token refresh on 401 (except for refresh endpoint)
    if (error.response?.statusCode == 401 &&
        !error.requestOptions.path.contains('/auth/refresh')) {
      final newToken = await _refreshToken();
      if (newToken != null) {
        await AuthStorage.instance.saveAccessToken(newToken);
        error.requestOptions.headers['Authorization'] = 'Bearer $newToken';
        try {
          final retryResponse = await _dio.fetch(error.requestOptions);
          return handler.resolve(retryResponse);
        } on DioException catch (e) {
          return handler.next(e);
        }
      } else {
        await _clearSessionAndLogout();
        return handler.next(error);
      }
    }
    return handler.next(error);
  }

  // ─── Token Refresh ─────────────────────────────────────────────
  bool _isRefreshing = false;
  Completer<String?>? _refreshCompleter;

  Future<String?> _refreshToken() async {
    if (_isRefreshing) {
      return _refreshCompleter?.future;
    }

    _isRefreshing = true;
    _refreshCompleter = Completer<String?>();

    try {
      final refreshToken = await AuthStorage.instance.getRefreshToken();
      if (refreshToken == null) {
        _refreshCompleter!.complete(null);
        return null;
      }

      final response = await _dio.post(
        '/auth/refresh',
        data: {'refresh_token': refreshToken},
      );

      if (response.statusCode == 200) {
        final newToken = response.data['access_token'] as String?;
        if (newToken != null) {
          await AuthStorage.instance.saveAccessToken(newToken);
          _refreshCompleter!.complete(newToken);
          return newToken;
        }
      }
      _refreshCompleter!.complete(null);
      return null;
    } catch (e) {
      _refreshCompleter!.complete(null);
      return null;
    } finally {
      _isRefreshing = false;
      _refreshCompleter = null;
    }
  }

  Future<void> _clearSessionAndLogout() async {
    invalidateUserProviders(ref.read);
    await AuthStorage.instance.clearTokens();

    AppRoutes.router.goNamed(AppRoutesName.widgetTree);
    debugPrint('Session expired. User logged out.');
  }

  // ─── Logging ──────────────────────────────────────────────────
  void _logRequest(RequestOptions options) {
    _logger.i(
      '┌───────────────────────────────────────────\n'
          '│ REQUEST: ${options.method} ${options.uri}\n'
          '│ Headers: ${options.headers}\n'
          '│ Data: ${options.data}\n'
          '└───────────────────────────────────────────',
    );
  }

  void _logResponse(Response response) {
    _logger.i(
      '┌───────────────────────────────────────────\n'
          '│ RESPONSE: ${response.statusCode} ${response.requestOptions.uri}\n'
          '│ Data: ${response.data}\n'
          '└───────────────────────────────────────────',
    );
  }

  void _logError(DioException error) {
    _logger.e(
      '┌───────────────────────────────────────────\n'
          '│ REQUEST : ${error.requestOptions.method} ${error.requestOptions.uri}\n'
          '│ PATH    : ${error.requestOptions.path}\n'
          '│ QUERY   : ${error.requestOptions.queryParameters}\n'
          '│ BODY    : ${error.requestOptions.data}\n'
          '│\n'
          '│ STATUS  : ${error.response?.statusCode}\n'
          '│ RESPONSE: ${error.response?.data}\n'
          '└───────────────────────────────────────────',
    );
  }


  // ─── HTTP Methods ─────────────────────────────────────────────

  // GET
  Future<ApiResponse> get(
      String path, {
        Map<String, dynamic>? queryParameters,
        Options? options,
      }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  // POST
  Future<ApiResponse> post(
      String path, {
        Map<String, dynamic>? data,
        Map<String, dynamic>? queryParameters,
        Options? options,
      }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  // PUT
  Future<ApiResponse> put(
      String path, {
        Map<String, dynamic>? data,
        Map<String, dynamic>? queryParameters,
        Options? options,
      }) async {

    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  // PUT Multipart
  Future<ApiResponse> putMultipart(
      String path, {
        required FormData formData,
        Map<String, dynamic>? queryParameters,
        Options? options,
        ProgressCallback? onSendProgress,
      }) async {

    try {
      final response = await _dio.put(
        path,
        data: formData,
        queryParameters: queryParameters,
        options: options ??
            Options(
              contentType: 'multipart/form-data',
            ),
        onSendProgress: onSendProgress,
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  // PATCH
  Future<ApiResponse> patch(
      String path, {
        Map<String, dynamic>? data,
        Map<String, dynamic>? queryParameters,
        Options? options,
      }) async {

    try {
      final response = await _dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  // DELETE
  Future<ApiResponse> delete(
      String path, {
        Map<String, dynamic>? data,
        Map<String, dynamic>? queryParameters,
        Options? options,
      }) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  // POST Multipart
  Future<ApiResponse> postMultipart(
      String path, {
        required FormData formData,
        Map<String, dynamic>? queryParameters,
        Options? options,
        ProgressCallback? onSendProgress,
      }) async {
    try {
      final response = await _dio.post(
        path,
        data: formData,
        queryParameters: queryParameters,
        options: options ??
            Options(
              contentType: 'multipart/form-data',
            ),
        onSendProgress: onSendProgress,
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  // ─── Response / Error Handling ─────────────────────────────────
  ApiResponse _handleResponse(Response<dynamic> response) {
    final isSuccess = response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300;

    return ApiResponse(
      body: response.data,
      isSuccess: isSuccess,
      statusCode: response.statusCode ?? 0,
      errorMessage: isSuccess
          ? null
          : response.data?['message'] ?? response.statusMessage,
    );
  }

  ApiResponse _handleError(DioException error) {
    final statusCode = error.response?.statusCode ?? 0;
    final data = error.response?.data;

    Failure? failure;
    String message;

    switch (error.type) {
      case DioExceptionType.connectionError:
        failure = const NetworkFailure('No internet connection');
        message = 'No internet connection';
        break;

      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        failure = const TimeoutFailure('Connection timeout');
        message = 'Connection timeout';
        break;

      case DioExceptionType.badResponse:
        final serverMsg = data is Map ? (data['message'] ?? data['error']??data['detail']) : null;
        message = serverMsg ?? 'Server error';
        failure = ServerFailure(message);
        break;

      default:
        message = error.message ?? 'Something went wrong';
        failure = UnknownFailure(message);
    }

    return ApiResponse(
      body: data,
      isSuccess: false,
      statusCode: statusCode,
      errorMessage: message,
      failure: failure,
    );
  }

  // ─── Helper to return no internet response ─────────────────────
  ApiResponse _noInternetResponse() {
    return ApiResponse(
      body: {},
      isSuccess: false,
      statusCode: 0,
      errorMessage: 'No internet connection',
      failure: const NetworkFailure('No internet connection'),
    );
  }
}