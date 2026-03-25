// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminUser _$AdminUserFromJson(Map<String, dynamic> json) => AdminUser(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  email: json['email'] as String,
  username: json['username'] as String,
  role: json['role'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  hasProfile: json['hasProfile'] as bool,
  projectCount: (json['projectCount'] as num).toInt(),
);

Map<String, dynamic> _$AdminUserToJson(AdminUser instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'email': instance.email,
  'username': instance.username,
  'role': instance.role,
  'createdAt': instance.createdAt.toIso8601String(),
  'hasProfile': instance.hasProfile,
  'projectCount': instance.projectCount,
};
