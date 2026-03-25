import 'package:json_annotation/json_annotation.dart';

part 'admin_user.g.dart';

@JsonSerializable()
class AdminUser {
  final int id;
  final String name;
  final String email;
  final String username;
  final String role;
  final DateTime createdAt;
  final bool hasProfile;
  final int projectCount;
  
  AdminUser({
    required this.id,
    required this.name,
    required this.email,
    required this.username,
    required this.role,
    required this.createdAt,
    required this.hasProfile,
    required this.projectCount,
  });
  
  factory AdminUser.fromJson(Map<String, dynamic> json) => _$AdminUserFromJson(json);
  Map<String, dynamic> toJson() => _$AdminUserToJson(this);
}