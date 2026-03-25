import 'package:phoenix_slack/data/datasources/api_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:phoenix_slack/data/model/user/user.dart';

class AuthRepository {
  final ApiService _apiService;
  final FlutterSecureStorage _storage;
  
  AuthRepository(this._apiService, this._storage);
  
  Future<LoginResponse> login(String email, String password) async {
    final request = LoginRequest(email: email, password: password);
    return await _apiService.login(request);
  }
  
  Future<RegisterResponse> register(RegisterRequest request) async {
    return await _apiService.register(request);
  }
  
  Future<User> getCurrentUser() async {
    return await _apiService.getCurrentUser();
  }
  
  Future<void> saveToken(String token) async {
    await _storage.write(key: 'access_token', value: token);
  }
  
  Future<String?> getToken() async {
    return await _storage.read(key: 'access_token');
  }
  
  Future<void> deleteToken() async {
    await _storage.delete(key: 'access_token');
  }
  
  Future<void> logout() async {
    await deleteToken();
  }
}