import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phoenix_slack/data/model/user/user.dart';
import 'package:phoenix_slack/providers/auth_provider.dart';

final currentUserProvider = Provider<User?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.user;
});

final isAdminProvider = Provider<bool>((ref) {
  final user = ref.watch(currentUserProvider);
  return user?.isAdmin ?? false;
});

final userIdProvider = Provider<int?>((ref) {
  final user = ref.watch(currentUserProvider);
  return user?.id;
});

final usernameProvider = Provider<String?>((ref) {
  final user = ref.watch(currentUserProvider);
  return user?.username;
});