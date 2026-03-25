import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:phoenix_slack/data/model/profile/profile.dart';
import 'package:phoenix_slack/providers/auth_provider.dart';

final profileProvider = FutureProvider.family<Profile?, String>((ref, username) async {
  final apiService = ref.read(apiServiceProvider);
  try {
    return await apiService.getProfileByUsername(username);
  } catch (e) {
    return null;
  }
});

final myProfileProvider = FutureProvider<Profile?>((ref) async {
  final authState = ref.watch(authStateProvider);
  if (!authState.isAuthenticated) return null;
  
  final apiService = ref.read(apiServiceProvider);
  try {
    return await apiService.getMyProfile();
  } catch (e) {
    return null;
  }
});

class ProfileNotifier extends StateNotifier<AsyncValue<Profile?>> {
  final Ref _ref;
  
  ProfileNotifier(this._ref) : super(const AsyncValue.data(null));
  
  Future<void> loadProfile() async {
    state = const AsyncValue.loading();
    try {
      final apiService = _ref.read(apiServiceProvider);
      final profile = await apiService.getMyProfile();
      state = AsyncValue.data(profile);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
  
  Future<bool> createOrUpdate(ProfileRequest request) async {
    try {
      final apiService = _ref.read(apiServiceProvider);
      final profile = await apiService.createOrUpdateProfile(request);
      state = AsyncValue.data(profile);
      return true;
    } catch (e) {
      return false;
    }
  }
  
  Future<bool> delete() async {
    try {
      final apiService = _ref.read(apiServiceProvider);
      await apiService.deleteMyProfile();
      state = const AsyncValue.data(null);
      return true;
    } catch (e) {
      return false;
    }
  }
}

final myProfileNotifierProvider = StateNotifierProvider<ProfileNotifier, AsyncValue<Profile?>>((ref) {
  return ProfileNotifier(ref);
});