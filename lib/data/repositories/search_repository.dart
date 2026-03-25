import 'package:phoenix_slack/data/datasources/api_service.dart';
import 'package:phoenix_slack/data/model/search/search_result.dart';

class SearchRepository {
  final ApiService _apiService;
  
  SearchRepository(this._apiService);
  
  Future<List<SearchResult>> searchByUsername(String query) async {
    final response = await _apiService.searchByUsername(query);
    return (response['results'] as List)
        .map((json) => SearchResult.fromJson(json))
        .toList();
  }
  
  Future<List<SearchResult>> searchByName(String query) async {
    final response = await _apiService.searchByName(query);
    return (response['results'] as List)
        .map((json) => SearchResult.fromJson(json))
        .toList();
  }
  
  Future<List<SearchResult>> searchByKeyword(String keyword) async {
    final response = await _apiService.searchByKeyword(keyword);
    return (response['results'] as List)
        .map((json) => SearchResult.fromJson(json))
        .toList();
  }
  
  Future<List<SearchResult>> getSuggestions(String query) async {
    final response = await _apiService.getSuggestions(query);
    return (response['suggestions'] as List)
        .map((json) => SearchResult.fromJson(json))
        .toList();
  }
  
  Future<List<SearchResult>> getRecentUsers(int limit) async {
    final response = await _apiService.getRecentUsers(limit);
    return (response['users'] as List)
        .map((json) => SearchResult.fromJson(json))
        .toList();
  }
}