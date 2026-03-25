// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchResult _$SearchResultFromJson(Map<String, dynamic> json) => SearchResult(
  userId: (json['userId'] as num).toInt(),
  username: json['username'] as String,
  name: json['name'] as String,
  memberSince: DateTime.parse(json['memberSince'] as String),
  hasProfile: json['hasProfile'] as bool,
  profileId: (json['profileId'] as num?)?.toInt(),
  bio: json['bio'] as String?,
  githubUrl: json['githubUrl'] as String?,
  linkedinUrl: json['linkedinUrl'] as String?,
  hasProjects: json['hasProjects'] as bool,
  projectCount: (json['projectCount'] as num).toInt(),
  isYou: json['isYou'] as bool,
);

// ignore: unused_element
Map<String, dynamic> _$SearchResultToJson(SearchResult instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'username': instance.username,
      'name': instance.name,
      'memberSince': instance.memberSince.toIso8601String(),
      'hasProfile': instance.hasProfile,
      'profileId': instance.profileId,
      'bio': instance.bio,
      'githubUrl': instance.githubUrl,
      'linkedinUrl': instance.linkedinUrl,
      'hasProjects': instance.hasProjects,
      'projectCount': instance.projectCount,
      'isYou': instance.isYou,
    };
