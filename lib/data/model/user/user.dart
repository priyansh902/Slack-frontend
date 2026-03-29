import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final int id;
  final String name;
  final String username; // NOTE: backend getUsername() returns email; actual username stored separately
  final String email;
  final String role;    // "[ROLE_ADMIN]" or "[ROLE_USER]" — use contains()
  final DateTime createdAt;

  const User({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.role,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

  /// Handles "[ROLE_ADMIN]" (Spring brackets) and plain "ROLE_ADMIN"
  bool get isAdmin => role.contains('ROLE_ADMIN');
  String get roleDisplay => isAdmin ? 'Admin' : 'User';

  User copyWith({
    int? id,
    String? name,
    String? username,
    String? email,
    String? role,
    DateTime? createdAt,
  }) =>
      User(
        id: id ?? this.id,
        name: name ?? this.name,
        username: username ?? this.username,
        email: email ?? this.email,
        role: role ?? this.role,
        createdAt: createdAt ?? this.createdAt,
      );
}

@JsonSerializable()
class LoginRequest {
  final String email;
  final String password;
  const LoginRequest({required this.email, required this.password});
  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);
}

@JsonSerializable()
class LoginResponse {
  final String token;
  final String username; // = email from backend
  final String? email;
  final String? name;

  const LoginResponse({
    required this.token,
    required this.username,
    this.email,
    this.name,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);
  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}

@JsonSerializable()
class RegisterRequest {
  final String name;
  final String username; // The ACTUAL username — save this!
  final String email;
  final String password;

  const RegisterRequest({
    required this.name,
    required this.username,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() => _$RegisterRequestToJson(this);
  factory RegisterRequest.fromJson(Map<String, dynamic> json) =>
      _$RegisterRequestFromJson(json);
}

@JsonSerializable()
class RegisterResponse {
  final String message;
  final String email;
  final String username;
  final String role;
  final String? warning;

  const RegisterResponse({
    required this.message,
    required this.email,
    required this.username,
    required this.role,
    this.warning,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) =>
      _$RegisterResponseFromJson(json);
  Map<String, dynamic> toJson() => _$RegisterResponseToJson(this);
}
