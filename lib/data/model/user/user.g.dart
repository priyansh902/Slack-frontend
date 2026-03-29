// GENERATED CODE - DO NOT MODIFY BY HAND
part of 'user.dart';

User _$UserFromJson(Map<String, dynamic> json) => User(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String? ?? '',
  username: json['username'] as String? ?? '',
  email: json['email'] as String? ?? '',
  role: _parseRole(json['role']),
  createdAt: DateTime.parse(json['createdAt'] as String),
);

/// Handles role as String, List, or null from different endpoints
String _parseRole(dynamic role) {
  if (role == null) return 'ROLE_USER';
  if (role is String) return role;
  if (role is List) return role.join(', ');
  return role.toString();
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'username': instance.username,
  'email': instance.email,
  'role': instance.role,
  'createdAt': instance.createdAt.toIso8601String(),
};

LoginRequest _$LoginRequestFromJson(Map<String, dynamic> json) => LoginRequest(
  email: json['email'] as String,
  password: json['password'] as String,
);
Map<String, dynamic> _$LoginRequestToJson(LoginRequest instance) =>
    <String, dynamic>{'email': instance.email, 'password': instance.password};

LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) => LoginResponse(
  token: json['token'] as String,
  username: json['username'] as String? ?? '',
  email: json['email'] as String?,
  name: json['name'] as String?,
);
Map<String, dynamic> _$LoginResponseToJson(LoginResponse instance) => <String, dynamic>{
  'token': instance.token,
  'username': instance.username,
  'email': instance.email,
  'name': instance.name,
};

RegisterRequest _$RegisterRequestFromJson(Map<String, dynamic> json) => RegisterRequest(
  name: json['name'] as String,
  username: json['username'] as String,
  email: json['email'] as String,
  password: json['password'] as String,
);
Map<String, dynamic> _$RegisterRequestToJson(RegisterRequest instance) => <String, dynamic>{
  'name': instance.name,
  'username': instance.username,
  'email': instance.email,
  'password': instance.password,
};

RegisterResponse _$RegisterResponseFromJson(Map<String, dynamic> json) => RegisterResponse(
  message: json['message'] as String? ?? '',
  email: json['email'] as String? ?? '',
  username: json['username'] as String? ?? '',
  role: json['role'] as String? ?? 'ROLE_USER',
  warning: json['warning'] as String?,
);
Map<String, dynamic> _$RegisterResponseToJson(RegisterResponse instance) => <String, dynamic>{
  'message': instance.message,
  'email': instance.email,
  'username': instance.username,
  'role': instance.role,
  'warning': instance.warning,
};
