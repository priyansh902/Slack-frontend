import 'package:phoenix_slack/data/datasources/api_service.dart';
import 'package:phoenix_slack/data/model/user/user.dart';

class UserRepository {
  final ApiService _apiService;
  
  UserRepository(this._apiService);
  
  Future<User> getCurrentUser() async {
    return await _apiService.getCurrentUser();
  }
  
  Future<Map<String, dynamic>> getUserById(int userId) async {
    return await _apiService.getUserById(userId);
  }
  
  Future<Map<String, dynamic>> getUserByExactUsername(String username) async {
    return await _apiService.getUserByExactUsername(username);
  }
  
  Future<Map<String, dynamic>> getUserStats(int userId) async {
    return await _apiService.getUserStats(userId);
  }
}