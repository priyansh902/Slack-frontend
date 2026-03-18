import 'package:dio/dio.dart';
import '../models/user.dart';
import '../models/auth_response.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';
import '../../core/constants/api_endpoints.dart';

class AuthRepository {
  final ApiService _apiService = ApiService();
  final StorageService _storage = StorageService();

  Future<AuthResponse> login(String email, String password) async {
    try {
      final response = await _apiService.post(
        ApiEndpoints.login,
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final user = User.fromJson(data);
        final token = data['token'];
        
        // Save to storage
        await _storage.saveToken(token);
        await _storage.saveUser(user.toJson());
        
        return AuthResponse(user: user, token: token);
      } else {
        throw Exception('Login failed: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Invalid email or password');
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  Future<AuthResponse> register({
    required String name,
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiService.post(
        ApiEndpoints.register,
        data: {
          'name': name,
          'username': username,
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        // After registration, login automatically
        return await login(email, password);
      } else {
        throw Exception('Registration failed: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        final error = e.response?.data['error'] ?? 'Registration failed';
        throw Exception(error);
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  Future<User?> getCurrentUser() async {
    try {
      final response = await _apiService.get(ApiEndpoints.me);
      
      if (response.statusCode == 200) {
        return User.fromJson(response.data);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<void> logout() async {
    await _storage.clearAuth();
  }

  Future<bool> isAuthenticated() async {
    final token = await _storage.getToken();
    return token != null;
  }
}