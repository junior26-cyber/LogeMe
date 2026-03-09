import 'package:dio/dio.dart';

import '../../core/constants/api_constants.dart';

typedef TokenGetter = Future<String?> Function();
typedef RefreshHandler = Future<bool> Function();

class ApiClient {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );

  static bool _initialized = false;
  static TokenGetter? _getAccessToken;
  static RefreshHandler? _refreshToken;

  Dio get dio {
    if (!_initialized) {
      _initInterceptors();
      _initialized = true;
    }
    return _dio;
  }

  static void configureAuth({
    required TokenGetter getAccessToken,
    required RefreshHandler refreshToken,
  }) {
    _getAccessToken = getAccessToken;
    _refreshToken = refreshToken;
  }

  void _initInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _getAccessToken?.call();
          if (token != null && token.isNotEmpty && options.headers['Authorization'] == null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          final req = error.requestOptions;
          final isAuthRoute = req.path.contains('/api/auth/login') ||
              req.path.contains('/api/auth/register') ||
              req.path.contains('/api/auth/refresh');

          if (error.response?.statusCode == 401 && !isAuthRoute && req.extra['retried'] != true) {
            final refreshed = await _refreshToken?.call() ?? false;
            if (refreshed) {
              req.extra['retried'] = true;
              final token = await _getAccessToken?.call();
              if (token != null) {
                req.headers['Authorization'] = 'Bearer $token';
              }
              final response = await _dio.fetch(req);
              return handler.resolve(response);
            }
          }
          handler.next(error);
        },
      ),
    );
  }
}
