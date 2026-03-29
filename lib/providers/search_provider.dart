import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phoenix_slack/data/model/search/search_result.dart';
import 'package:phoenix_slack/providers/auth_provider.dart';

final isSearchingProvider = StateProvider<bool>((ref) => false);

/// Safely pulls results from whichever key the backend happens to use
List<SearchResult> _parseResults(Map<String, dynamic> response) {
  final raw = response['results'] ?? response['users'] ?? response['suggestions'] ?? [];
  return (raw as List)
      .map((j) => SearchResult.fromJson(j as Map<String, dynamic>))
      .toList();
}

class SearchNotifier extends StateNotifier<AsyncValue<List<SearchResult>>> {
  final Ref _ref;
  SearchNotifier(this._ref) : super(const AsyncValue.data([]));

  Future<void> searchByUsername(String query) async {
    if (query.trim().length < 2) return;
    state = const AsyncValue.loading();
    try {
      final r = await _ref.read(apiServiceProvider).searchByUsername(query.trim());
      state = AsyncValue.data(_parseResults(r));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> searchByName(String query) async {
    if (query.trim().length < 2) return;
    state = const AsyncValue.loading();
    try {
      final r = await _ref.read(apiServiceProvider).searchByName(query.trim());
      state = AsyncValue.data(_parseResults(r));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> searchByKeyword(String keyword) async {
    if (keyword.trim().length < 2) return;
    state = const AsyncValue.loading();
    try {
      final r = await _ref.read(apiServiceProvider).searchByKeyword(keyword.trim());
      state = AsyncValue.data(_parseResults(r));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void clear() => state = const AsyncValue.data([]);
}

final searchNotifierProvider =
    StateNotifierProvider<SearchNotifier, AsyncValue<List<SearchResult>>>(
        (ref) => SearchNotifier(ref));

// Recent users for showing on search landing
final recentUsersProvider = FutureProvider<List<SearchResult>>((ref) async {
  try {
    final r = await ref.read(apiServiceProvider).getRecentUsers(10);
    return _parseResults(r);
  } catch (_) {
    return [];
  }
});
