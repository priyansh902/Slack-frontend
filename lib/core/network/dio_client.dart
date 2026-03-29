import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:phoenix_slack/core/constants/api_constants.dart';

class DioClient {
  static Dio? _dio;
  static const _storage = FlutterSecureStorage();

  static Dio get instance {
    if (_dio != null) return _dio!;

    _dio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        ApiConstants.contentType: ApiConstants.applicationJson,
      },
    ));

    _dio!.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _storage.read(key: 'access_token');
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onResponse: (response, handler) => handler.next(response),
      onError: (error, handler) async {
        if (error.response?.statusCode == 401) {
          await _storage.delete(key: 'access_token');
        }
        return handler.next(error);
      },
    ));

    return _dio!;
  }

  static void reset() => _dio = null;
}
