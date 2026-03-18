import '../models/user_search_result.dart';
import '../services/api_service.dart';
import '../../core/constants/api_endpoints.dart';

class SearchRepository {
  final ApiService _apiService = ApiService();

  Future<List<UserSearchResult>> searchByUsername(String query) async {
    try {
      final response = await _apiService.get(
        '${ApiEndpoints.searchByUsername}?query=$query',
      );
      
      if (response.statusCode == 200) {
        final results = response.data['results'] as List;
        return results.map((r) => UserSearchResult.fromJson(r)).toList();
      }
      return [];
    } catch (e) {
      throw Exception('Search failed: $e');
    }
  }

  Future<List<UserSearchResult>> searchByName(String query) async {
    try {
      final response = await _apiService.get(
        '${ApiEndpoints.searchByName}?query=$query',
      );
      
      if (response.statusCode == 200) {
        final results = response.data['results'] as List;
        return results.map((r) => UserSearchResult.fromJson(r)).toList();
      }
      return [];
    } catch (e) {
      throw Exception('Search failed: $e');
    }
  }

  Future<List<UserSearchResult>> searchByKeyword(String keyword) async {
    try {
      final response = await _apiService.get(
        '${ApiEndpoints.searchByKeyword}?keyword=$keyword',
      );
      
      if (response.statusCode == 200) {
        final results = response.data['results'] as List;
        return results.map((r) => UserSearchResult.fromJson(r)).toList();
      }
      return [];
    } catch (e) {
      throw Exception('Search failed: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getSearchSuggestions(String query) async {
    try {
      final response = await _apiService.get(
        '${ApiEndpoints.searchSuggestions}?query=$query',
      );
      
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(response.data['suggestions']);
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<List<UserSearchResult>> getRecentUsers({int limit = 10}) async {
    try {
      final response = await _apiService.get(
        '${ApiEndpoints.recentUsers}?limit=$limit',
      );
      
      if (response.statusCode == 200) {
        final results = response.data['users'] as List;
        return results.map((r) => UserSearchResult.fromJson(r)).toList();
      }
      return [];
    } catch (e) {
      throw Exception('Failed to load recent users: $e');
    }
  }

  Future<UserSearchResult?> getUserById(int userId) async {
    try {
      final response = await _apiService.get('${ApiEndpoints.searchByUsername}/id/$userId');
      
      if (response.statusCode == 200) {
        return UserSearchResult.fromJson(response.data);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<UserSearchResult?> getUserByUsername(String username) async {
    try {
      final response = await _apiService.get('${ApiEndpoints.searchByUsername}/username/$username');
      
      if (response.statusCode == 200) {
        return UserSearchResult.fromJson(response.data);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}