import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phoenix_slack/data/model/profile/profile.dart';
import 'package:phoenix_slack/data/model/project/project.dart';
import 'package:phoenix_slack/providers/auth_provider.dart';

final profileProvider = FutureProvider.family<Profile?, String>((ref, username) async {
  try {
    return await ref.read(apiServiceProvider).getProfileByUsername(username);
  } catch (_) { return null; }
});

final myProfileProvider = FutureProvider<Profile?>((ref) async {
  if (!ref.watch(authStateProvider).isAuthenticated) return null;
  try {
    return await ref.read(apiServiceProvider).getMyProfile();
  } catch (_) { return null; }
});

class ProfileNotifier extends StateNotifier<AsyncValue<Profile?>> {
  final Ref _ref;
  ProfileNotifier(this._ref) : super(const AsyncValue.data(null));

  Future<void> loadProfile() async {
    state = const AsyncValue.loading();
    try {
      final p = await _ref.read(apiServiceProvider).getMyProfile();
      state = AsyncValue.data(p);
    } catch (e, st) {
      // 404 = no profile yet — show empty state, not error
      if (e is DioException && e.response?.statusCode == 404) {
        state = const AsyncValue.data(null);
      } else {
        state = AsyncValue.error(e, st);
      }
    }
  }

  Future<bool> createOrUpdate(ProfileRequest request) async {
    try {
      final p = await _ref.read(apiServiceProvider).createOrUpdateProfile(request);
      state = AsyncValue.data(p);
      return true;
    } catch (_) { return false; }
  }

  Future<bool> delete() async {
    try {
      await _ref.read(apiServiceProvider).deleteMyProfile();
      state = const AsyncValue.data(null);
      return true;
    } catch (_) { return false; }
  }
}

final myProfileNotifierProvider =
    StateNotifierProvider<ProfileNotifier, AsyncValue<Profile?>>((ref) => ProfileNotifier(ref));

// Profile by userId — used when username from search is actually email
final profileByIdProvider = FutureProvider.family<Profile?, int>((ref, userId) async {
  try {
    return await ref.read(apiServiceProvider).getProfileByUserId(userId);
  } catch (_) { return null; }
});

// Projects by userId
final userProjectsByIdProvider = FutureProvider.family<List<Project>, int>((ref, userId) async {
  try {
    final r = await ref.read(apiServiceProvider).getProjectsByUserId(userId);
    return ((r['projects'] ?? r['results'] ?? []) as List)
        .map((j) => Project.fromJson(j as Map<String, dynamic>))
        .toList();
  } catch (_) { return []; }
});
