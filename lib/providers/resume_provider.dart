import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:phoenix_slack/data/model/resume/resume.dart';
import 'package:phoenix_slack/providers/auth_provider.dart';

final myResumeProvider = FutureProvider<Resume?>((ref) async {
  final apiService = ref.read(apiServiceProvider);
  try {
    final response = await apiService.getMyResume();
    if (response.containsKey('resume')) {
      return Resume.fromJson(response['resume']);
    }
    return null;
  } catch (e) {
    return null;
  }
});

class ResumeNotifier extends StateNotifier<AsyncValue<Resume?>> {
  final Ref _ref;
  
  ResumeNotifier(this._ref) : super(const AsyncValue.data(null));
  
  Future<void> loadResume() async {
    state = const AsyncValue.loading();
    try {
      final apiService = _ref.read(apiServiceProvider);
      final response = await apiService.getMyResume();
      if (response.containsKey('resume')) {
        state = AsyncValue.data(Resume.fromJson(response['resume']));
      } else {
        state = const AsyncValue.data(null);
      }
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
  
  Future<bool> upload(MultipartFile file) async {
    try {
      final apiService = _ref.read(apiServiceProvider);
      await apiService.uploadResume(file);
      await loadResume();
      return true;
    } catch (e) {
      return false;
    }
  }
  
  Future<bool> delete() async {
    try {
      final apiService = _ref.read(apiServiceProvider);
      await apiService.deleteMyResume();
      state = const AsyncValue.data(null);
      return true;
    } catch (e) {
      return false;
    }
  }
}

final resumeNotifierProvider = StateNotifierProvider<ResumeNotifier, AsyncValue<Resume?>>((ref) {
  return ResumeNotifier(ref);
});