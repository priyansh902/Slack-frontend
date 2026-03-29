import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:phoenix_slack/core/network/dio_client.dart';
import 'package:phoenix_slack/data/datasources/api_service.dart';
import 'package:phoenix_slack/data/model/user/user.dart';

final secureStorageProvider =
    Provider<FlutterSecureStorage>((_) => const FlutterSecureStorage());

final apiServiceProvider =
    Provider<ApiService>((ref) => ApiService(DioClient.instance));

class AuthState {
  final bool isAuthenticated;
  final User? user;
  final bool isLoading;
  final String? error;

  const AuthState({
    required this.isAuthenticated,
    this.user,
    this.isLoading = false,
    this.error,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    User? user,
    bool? isLoading,
    String? error,
  }) =>
      AuthState(
        isAuthenticated: isAuthenticated ?? this.isAuthenticated,
        user: user ?? this.user,
        isLoading: isLoading ?? this.isLoading,
        error: error,
      );
}

class AuthNotifier extends StateNotifier<AuthState> {
  final Ref _ref;
  AuthNotifier(this._ref) : super(const AuthState(isAuthenticated: false));

  Future<bool> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final storage = _ref.read(secureStorageProvider);
      final api = _ref.read(apiServiceProvider);

      final response =
          await api.login(LoginRequest(email: email, password: password));

      await storage.write(key: 'access_token', value: response.token);

      // Recreate client so subsequent requests carry the token
      DioClient.reset();
      _ref.invalidate(apiServiceProvider);

      final user = await _ref.read(apiServiceProvider).getCurrentUser();

      // Persist the actual username typed by user — the /api/users/me 'username'
      // field is email (Spring Security override). We save the stored username
      // separately. If we have it from a previous registration, keep it.
      // Otherwise fall back to what the response returned.
      final savedUsername = await storage.read(key: 'actual_username');
      if (savedUsername == null && response.username.isNotEmpty) {
        // response.username from login is also email — but store it as fallback
        await storage.write(key: 'actual_username', value: response.username);
      }

      final actualUsername =
          await storage.read(key: 'actual_username') ?? user.username;
      final userWithRealUsername =
          user.username == user.email ? user.copyWith(username: actualUsername) : user;

      state = state.copyWith(
          isAuthenticated: true, user: userWithRealUsername, isLoading: false);
      return true;
    } on DioException catch (e) {
      state = state.copyWith(isLoading: false, error: _err(e, 'Login failed'));
      return false;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Login failed');
      return false;
    }
  }

  Future<bool> register(RegisterRequest request) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _ref.read(apiServiceProvider).register(request);

      // Save actual username from registration form BEFORE logging in
      await _ref
          .read(secureStorageProvider)
          .write(key: 'actual_username', value: request.username);

      return login(request.email, request.password);
    } on DioException catch (e) {
      state = state.copyWith(
          isLoading: false, error: _err(e, 'Registration failed'));
      return false;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Registration failed');
      return false;
    }
  }

  Future<void> logout() async {
    final storage = _ref.read(secureStorageProvider);
    await storage.delete(key: 'access_token');
    // Keep actual_username so it survives logout/login cycles
    DioClient.reset();
    state = const AuthState(isAuthenticated: false);
  }

  Future<void> loadCurrentUser() async {
    final storage = _ref.read(secureStorageProvider);
    final token = await storage.read(key: 'access_token');
    if (token == null) return;
    try {
      final user = await _ref.read(apiServiceProvider).getCurrentUser();
      final saved = await storage.read(key: 'actual_username');
      final realUser = (saved != null && user.username == user.email)
          ? user.copyWith(username: saved)
          : user;
      state = state.copyWith(isAuthenticated: true, user: realUser);
    } catch (_) {
      await logout();
    }
  }

  String _err(DioException e, String fallback) {
    try {
      final d = e.response?.data;
      if (d is Map) return d['error'] as String? ?? fallback;
    } catch (_) {}
    return fallback;
  }
}

final authStateProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) => AuthNotifier(ref));
