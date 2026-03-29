import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phoenix_slack/data/model/resume/resume.dart';
import 'package:phoenix_slack/providers/auth_provider.dart';

final myResumeProvider = FutureProvider<Resume?>((ref) async {
  final apiService = ref.read(apiServiceProvider);
  try {
    final response = await apiService.getMyResume();
    return _parseResume(response);
  } catch (_) {
    return null;
  }
});

Resume? _parseResume(Map<String, dynamic> response) {
  // Backend returns Resume directly OR wrapped in { resume: {...} }
  if (response.containsKey('id')) {
    return Resume.fromJson(response);
  }
  if (response.containsKey('resume') && response['resume'] is Map) {
    return Resume.fromJson(response['resume'] as Map<String, dynamic>);
  }
  return null;
}

class ResumeNotifier extends StateNotifier<AsyncValue<Resume?>> {
  final Ref _ref;
  ResumeNotifier(this._ref) : super(const AsyncValue.data(null));

  Future<void> loadResume() async {
    state = const AsyncValue.loading();
    try {
      final response = await _ref.read(apiServiceProvider).getMyResume();
      state = AsyncValue.data(_parseResume(response));
    } catch (e, st) {
      // 404 means no resume — not an error
      if (e is DioException && e.response?.statusCode == 404) {
        state = const AsyncValue.data(null);
      } else {
        state = AsyncValue.error(e, st);
      }
    }
  }

  Future<bool> upload(MultipartFile file) async {
    try {
      await _ref.read(apiServiceProvider).uploadResume(file);
      await loadResume();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> delete() async {
    try {
      await _ref.read(apiServiceProvider).deleteMyResume();
      state = const AsyncValue.data(null);
      return true;
    } catch (_) {
      return false;
    }
  }
}

final resumeNotifierProvider =
    StateNotifierProvider<ResumeNotifier, AsyncValue<Resume?>>((ref) => ResumeNotifier(ref));
