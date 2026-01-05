import 'dart:developer';

import 'package:dio/dio.dart';
import '../service/session_service.dart';

class ApiClient {
  static const String baseUrl = 'https://api.syroltech.com/screensy';
  static const String fileBaseUrl = 'https://realta360.b-cdn.net';
  static const String apiToken = 'NlwvQOhvOgMARJ21Jfs1yLsG';

  late final Dio dio;

  ApiClient() {
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 120),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'token': apiToken,
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          log("Api call: ${options.path}");
          log("Request headers: ${options.headers}");
          log("Request data: ${options.data.toString()}");
          return handler.next(options);
        },
        onResponse: (response, handler) {
          log("Response: ${response.statusCode}");
          log("Response data: ${response.data}");
          if (response.statusCode == 200) {
            final data = response.data;
            final path = response.requestOptions.path;

            // Skip validation for endpoints that return data directly (not wrapped in 'data' field)
            final proceedWithValidation = path.contains('/verify-account');

            // Skip validation for forgot-password and similar public endpoints
            final isPublicEndpoint =
                path.contains('/forgot-password') ||
                path.contains('/reset-password');

            if (proceedWithValidation && !isPublicEndpoint) {
              if (data is Map &&
                  (data['data'] == null || data['data'].toString() == '{}')) {
                return handler.reject(
                  DioException(
                    requestOptions: response.requestOptions,
                    error: "Invalid response returned by server.",
                    type: DioExceptionType.badResponse,
                  ),
                );
              }
            }
          }

          return handler.next(response);
        },
        onError: (DioException e, handler) async {
          log("Error: ${e.message}");
          log("Error response: ${e.response?.data}");
          log("Error status code: ${e.response?.statusCode}");
          return handler.next(e);
        },
      ),
    );
  }

  Future<void> _withAuth(Options options, {bool requireAuth = true}) async {
    if (!requireAuth) return;

    final token = await SessionService.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers ??= {};
      options.headers!['Authorization'] = 'Bearer $token';
    }
  }

  /// Check if endpoint requires authentication
  bool _requiresAuth(String path) {
    final publicEndpoints = [
      '/user/signup',
      '/user/validate-account',
      '/user/verify-account',
      '/auth/login',
      '/user/forgot-password',
      '/user/list', // Public endpoint - artists list accessible to all users
    ];

    return !publicEndpoints.any((endpoint) => path.contains(endpoint));
  }

  Future<Response> post(String path, {Map<String, dynamic>? data}) async {
    final options = Options();
    options.headers ??= {};
    options.headers!['Authorization'] = 'Bearer $apiToken';
    final requireAuth = _requiresAuth(path);
    await _withAuth(options, requireAuth: requireAuth);
    return await dio.post(path, data: data, options: options);
  }

  Future<Response> postFormData(String path, {required FormData data}) async {
    final options = Options(contentType: 'multipart/form-data');
    options.headers ??= {};
    options.headers!['Authorization'] = 'Bearer $apiToken';
    final requireAuth = _requiresAuth(path);
    await _withAuth(options, requireAuth: requireAuth);
    return await dio.post(path, data: data, options: options);
  }

  Future<Response> putFormData(String path, {required FormData data}) async {
    final options = Options(contentType: 'multipart/form-data');
    options.headers ??= {};
    options.headers!['Authorization'] = 'Bearer $apiToken';
    final requireAuth = _requiresAuth(path);
    await _withAuth(options, requireAuth: requireAuth);
    return await dio.put(path, data: data, options: options);
  }

  Future<Response> get(String path, {Map<String, dynamic>? query}) async {
    final options = Options();
    options.headers ??= {};
    options.headers!['Authorization'] = 'Bearer $apiToken';
    final requireAuth = _requiresAuth(path);
    await _withAuth(options, requireAuth: requireAuth);
    return await dio.get(path, queryParameters: query, options: options);
  }

  Future<Response> put(String path, {Map<String, dynamic>? data}) async {
    final options = Options();
    options.headers ??= {};
    options.headers!['Authorization'] = 'Bearer $apiToken';
    final requireAuth = _requiresAuth(path);
    await _withAuth(options, requireAuth: requireAuth);
    return await dio.put(path, data: data, options: options);
  }

  Future<Response> delete(String path) async {
    final options = Options();
    final requireAuth = _requiresAuth(path);
    await _withAuth(options, requireAuth: requireAuth);
    // Add API token to query parameters
    final queryParams = {'token': apiToken};
    return await dio.delete(
      path,
      queryParameters: queryParams,
      options: options,
    );
  }
}
