import 'package:json_annotation/json_annotation.dart';

part 'profile.g.dart';

@JsonSerializable()
class Profile {
  final int id;
  final int userId;
  final String username;
  final String email;
  final String name;
  final String bio;
  final String skills;
  final String? githubUrl;
  final String? linkedinUrl;
  final DateTime memberSince;
  final DateTime? profileUpdated;
  
  Profile({
    required this.id,
    required this.userId,
    required this.username,
    required this.email,
    required this.name,
    required this.bio,
    required this.skills,
    this.githubUrl,
    this.linkedinUrl,
    required this.memberSince,
    this.profileUpdated,
  });
  
  factory Profile.fromJson(Map<String, dynamic> json) => _$ProfileFromJson(json);
  Map<String, dynamic> toJson() => _$ProfileToJson(this);
}

@JsonSerializable()
class ProfileRequest {
  final String? bio;
  final String? skills;
  final String? githubUrl;
  final String? linkedinUrl;
  
  ProfileRequest({
    this.bio,
    this.skills,
    this.githubUrl,
    this.linkedinUrl,
  });
  
  Map<String, dynamic> toJson() => _$ProfileRequestToJson(this);
}
extension ProfileX on Profile {
  List<String> get skillsList {
    if (skills.isEmpty) return [];
    return skills.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
  }
}
