import 'package:riverpod/riverpod.dart';
import '../data/repositories/auth_repository.dart';
import '../data/models/user.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(AuthRepository());
});

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;
  
  AuthNotifier(this._repository) : super(AuthInitial());

  Future<void> login(String email, String password) async {
    state = AuthLoading();
    try {
      final response = await _repository.login(email, password);
      state = AuthSuccess(response.user, response.token);
    } catch (e) {
      state = AuthError(e.toString());
    }
  }

  Future<void> register(RegisterRequest request) async {
    state = AuthLoading();
    try {
      final response = await _repository.register(request);
      state = AuthSuccess(response.user, response.token);
    } catch (e) {
      state = AuthError(e.toString());
    }
  }

  void logout() {
    _repository.logout();
    state = AuthInitial();
  }
}

// States
abstract class AuthState {}
class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class AuthSuccess extends AuthState {
  final User user;
  final String token;
  AuthSuccess(this.user, this.token);
}
class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}