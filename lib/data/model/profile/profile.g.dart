// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Profile _$ProfileFromJson(Map<String, dynamic> json) => Profile(
  id: (json['id'] as num).toInt(),
  userId: (json['userId'] as num).toInt(),
  username: json['username'] as String,
  email: json['email'] as String,
  name: json['name'] as String,
  bio: json['bio'] as String,
  skills: json['skills'] as String,
  githubUrl: json['githubUrl'] as String?,
  linkedinUrl: json['linkedinUrl'] as String?,
  memberSince: DateTime.parse(json['memberSince'] as String),
  profileUpdated: json['profileUpdated'] == null
      ? null
      : DateTime.parse(json['profileUpdated'] as String),
);

Map<String, dynamic> _$ProfileToJson(Profile instance) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'username': instance.username,
  'email': instance.email,
  'name': instance.name,
  'bio': instance.bio,
  'skills': instance.skills,
  'githubUrl': instance.githubUrl,
  'linkedinUrl': instance.linkedinUrl,
  'memberSince': instance.memberSince.toIso8601String(),
  'profileUpdated': instance.profileUpdated?.toIso8601String(),
};

ProfileRequest _$ProfileRequestFromJson(Map<String, dynamic> json) =>
    ProfileRequest(
      bio: json['bio'] as String?,
      skills: json['skills'] as String?,
      githubUrl: json['githubUrl'] as String?,
      linkedinUrl: json['linkedinUrl'] as String?,
    );

Map<String, dynamic> _$ProfileRequestToJson(ProfileRequest instance) =>
    <String, dynamic>{
      'bio': instance.bio,
      'skills': instance.skills,
      'githubUrl': instance.githubUrl,
      'linkedinUrl': instance.linkedinUrl,
    };
