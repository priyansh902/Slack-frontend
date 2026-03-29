// GENERATED CODE - DO NOT MODIFY BY HAND
part of 'search_result.dart';

SearchResult _$SearchResultFromJson(Map<String, dynamic> json) => SearchResult(
  userId: (json['userId'] as num?)?.toInt() ?? 0,
  username: json['username'] as String? ?? '',
  name: json['name'] as String? ?? '',
  memberSince: json['memberSince'] != null
    ? DateTime.tryParse(json['memberSince'] as String) ?? DateTime.now()
    : DateTime.now(),
  hasProfile: json['hasProfile'] as bool? ?? false,
  profileId: (json['profileId'] as num?)?.toInt(),
  bio: json['bio'] as String?,
  githubUrl: json['githubUrl'] as String?,
  linkedinUrl: json['linkedinUrl'] as String?,
  hasProjects: json['hasProjects'] as bool? ?? false,
  projectCount: (json['projectCount'] as num?)?.toInt() ?? 0,
  isYou: json['isYou'] as bool? ?? false,
);

Map<String, dynamic> _$SearchResultToJson(SearchResult instance) => <String, dynamic>{
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
