import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final int id;
  final String name;
  final String username;
  final String email;
  final String role;
  final DateTime createdAt;
  
  User({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.role,
    required this.createdAt,
  });
  
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
  
  bool get isAdmin => role == 'ROLE_ADMIN';
  String get displayName => name.isNotEmpty ? name : username;
}

@JsonSerializable()
class LoginRequest {
  final String email;
  final String password;
  
  LoginRequest({
    required this.email,
    required this.password,
  });
  
  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}

@JsonSerializable()
class RegisterRequest {
  final String name;
  final String username;
  final String email;
  final String password;
  
  RegisterRequest({
    required this.name,
    required this.username,
    required this.email,
    required this.password,
  });
  
  Map<String, dynamic> toJson() => _$RegisterRequestToJson(this);
}

@JsonSerializable()
class LoginResponse {
  final String token;
  final String username;
  final String email;
  final String name;
  
  LoginResponse({
    required this.token,
    required this.username,
    required this.email,
    required this.name,
  });
  
  factory LoginResponse.fromJson(Map<String, dynamic> json) => 
      _$LoginResponseFromJson(json);
}

@JsonSerializable()
class RegisterResponse {
  final String message;
  final String email;
  final String username;
  final String role;
  final String? warning;
  
  RegisterResponse({
    required this.message,
    required this.email,
    required this.username,
    required this.role,
    this.warning,
  });
  
  factory RegisterResponse.fromJson(Map<String, dynamic> json) => 
      _$RegisterResponseFromJson(json);
}