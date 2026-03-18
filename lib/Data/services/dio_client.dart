import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();
  factory DioClient() => _instance;
  DioClient._internal();

  final Dio dio = Dio(BaseOptions(
    baseUrl: 'http://localhost:8080/api',
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
    headers: {'Content-Type': 'application/json'},
  ));

  final storage = const FlutterSecureStorage();

  void addInterceptor() {
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Add token to requests
        String? token = await storage.read(key: 'token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (error, handler) {
        if (error.response?.statusCode == 401) {
          // Handle unauthorized - redirect to login
        }
        return handler.next(error);
      },
    ));
  }
}