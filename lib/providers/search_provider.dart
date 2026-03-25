import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:phoenix_slack/data/model/search/search_result.dart';
import 'package:phoenix_slack/providers/auth_provider.dart';

final searchResultsProvider = StateProvider<List<SearchResult>>((ref) => []);

final searchQueryProvider = StateProvider<String>((ref) => '');

final isSearchingProvider = StateProvider<bool>((ref) => false);

final recentUsersProvider = FutureProvider<List<SearchResult>>((ref) async {
  final apiService = ref.read(apiServiceProvider);
  try {
    final response = await apiService.getRecentUsers(10); // Get 10 recent users
    final users = (response['users'] as List)
        .map((json) => SearchResult.fromJson(json))
        .toList();
    return users;
  } catch (e) {
    print('Error loading recent users: $e');
    return [];
  }
});

class SearchNotifier extends StateNotifier<AsyncValue<List<SearchResult>>> {
  final Ref _ref;
  
  SearchNotifier(this._ref) : super(const AsyncValue.data([]));
  
  Future<void> searchByUsername(String query) async {
    if (query.length < 2) return;
    
    state = const AsyncValue.loading();
    try {
      final apiService = _ref.read(apiServiceProvider);
      final response = await apiService.searchByUsername(query);
      final results = (response['results'] as List)
          .map((json) => SearchResult.fromJson(json))
          .toList();
      state = AsyncValue.data(results);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
  
  Future<void> searchByName(String query) async {
    if (query.length < 2) return;
    
    state = const AsyncValue.loading();
    try {
      final apiService = _ref.read(apiServiceProvider);
      final response = await apiService.searchByName(query);
      final results = (response['results'] as List)
          .map((json) => SearchResult.fromJson(json))
          .toList();
      state = AsyncValue.data(results);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
  
  Future<void> searchByKeyword(String keyword) async {
    if (keyword.length < 2) return;
    
    state = const AsyncValue.loading();
    try {
      final apiService = _ref.read(apiServiceProvider);
      final response = await apiService.searchByKeyword(keyword);
      final results = (response['results'] as List)
          .map((json) => SearchResult.fromJson(json))
          .toList();
      state = AsyncValue.data(results);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
  
  Future<List<SearchResult>> getSuggestions(String query) async {
    if (query.length < 2) return [];
    
    try {
      final apiService = _ref.read(apiServiceProvider);
      final response = await apiService.getSuggestions(query);
      final suggestions = (response['suggestions'] as List)
          .map((json) => SearchResult.fromJson(json))
          .toList();
      return suggestions;
    } catch (e) {
      return [];
    }
  }
  
  void clear() {
    state = const AsyncValue.data([]);
  }
}

final searchNotifierProvider = StateNotifierProvider<SearchNotifier, AsyncValue<List<SearchResult>>>((ref) {
  return SearchNotifier(ref);
});