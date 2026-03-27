import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:phoenix_slack/core/network/dio_client.dart';
import 'package:phoenix_slack/data/datasources/api_service.dart';
import 'package:phoenix_slack/data/model/user/user.dart';

final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService(DioClient.instance);
});

class AuthState {
  final bool isAuthenticated;
  final User? user;
  final bool isLoading;
  final String? error;
  
  AuthState({
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
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final Ref _ref;
  
  AuthNotifier(this._ref) : super(AuthState(isAuthenticated: false));
  
    Future<bool> login(String email, String password) async {
      state = state.copyWith(isLoading: true, error: null);
      
      try {
        final apiService = _ref.read(apiServiceProvider);
        final response = await apiService.login(LoginRequest(
          email: email,
          password: password,
        ));
        
        // Store token exactly as received, no cleaning needed since backend is clean now
        final token = response.token;
        
        print('📦 Token received: ${token.substring(0, 50)}...');
        print('📦 Token length: ${token.length}');
        
        await _ref.read(secureStorageProvider).write(
          key: 'access_token',
          value: token,  // Store as is
        );
        
        // Verify token was stored
        final storedToken = await _ref.read(secureStorageProvider).read(key: 'access_token');
        print('📦 Token stored: ${storedToken != null ? "Yes" : "No"}');
        print('📦 Stored token length: ${storedToken?.length}');
        
        // Invalidate and recreate API service with new token
        _ref.invalidate(apiServiceProvider);
        final newApiService = _ref.read(apiServiceProvider);
        
        print('📡 Fetching user data...');
        final user = await newApiService.getCurrentUser();
        print('✅ User fetched: ${user.name} (${user.email})');
        
        state = state.copyWith(
          isAuthenticated: true,
          user: user,
          isLoading: false,
        );
        
        return true;
      } catch (e) {
        print('❌ Login error: $e');
        if (e is DioException) {
          print('❌ Error type: ${e.type}');
          print('❌ Error message: ${e.message}');
          if (e.response != null) {
            print('❌ Response status: ${e.response?.statusCode}');
            print('❌ Response data: ${e.response?.data}');
          }
        }
        
        state = state.copyWith(
          isLoading: false,
          error: 'Login failed: $e',
        );
        
        return false;
      }
    }
  Future<bool> register(RegisterRequest request) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final apiService = _ref.read(apiServiceProvider);
      await apiService.register(request);
      
      final loginSuccess = await login(request.email, request.password);
      
      if (loginSuccess) {
        return true;
      }
      
      state = state.copyWith(isLoading: false);
      return false;
    } catch (e) {
      String errorMessage = 'Registration failed';
      if (e is DioException && e.response?.data['error'] != null) {
        errorMessage = e.response!.data['error'];
      }
      
      state = state.copyWith(
        isLoading: false,
        error: errorMessage,
      );
      
      return false;
    }
  }
  
  Future<void> logout() async {
    await _ref.read(secureStorageProvider).delete(key: 'access_token');
    state = AuthState(isAuthenticated: false);
  }
  
  Future<void> loadCurrentUser() async {
    try {
      final apiService = _ref.read(apiServiceProvider);
      final user = await apiService.getCurrentUser();
      state = state.copyWith(user: user);
    } catch (e) {
      await logout();
    }
  }
}

final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref);
});