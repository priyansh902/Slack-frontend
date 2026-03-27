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
          // Use the token exactly as stored
          options.headers[ApiConstants.authorization] = 'Bearer $token';
          print('🔐 Auth header set for ${options.path}');
          print('🔐 Token preview: ${token.substring(0, 50)}...');
        } else {
          print('⚠️ No token for ${options.path}');
        }
        return handler.next(options);
      },
      onResponse: (response, handler) {
        print('✅ ${response.statusCode} - ${response.requestOptions.path}');
        return handler.next(response);
      },
      onError: (error, handler) async {
        print('❌ Error: ${error.message}');
        print('❌ URL: ${error.requestOptions.path}');
        if (error.response != null) {
          print('❌ Status: ${error.response?.statusCode}');
          print('❌ Data: ${error.response?.data}');
        }
        if (error.response?.statusCode == 401) {
          await _storage.delete(key: 'access_token');
        }
        return handler.next(error);
      },
    ));
    
    return _dio!;
  }
  
  // Add this method to reset Dio client (for testing)
  static void reset() {
    _dio = null;
  }
}