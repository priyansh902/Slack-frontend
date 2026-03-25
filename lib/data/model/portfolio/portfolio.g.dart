// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'portfolio.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Portfolio _$PortfolioFromJson(Map<String, dynamic> json) => Portfolio(
  userId: (json['userId'] as num).toInt(),
  username: json['username'] as String,
  name: json['name'] as String,
  bio: json['bio'] as String?,
  skills: (json['skills'] as List<dynamic>).map((e) => e as String).toList(),
  projects: (json['projects'] as List<dynamic>)
      .map((e) => PortfolioProject.fromJson(e as Map<String, dynamic>))
      .toList(),
  memberSince: DateTime.parse(json['memberSince'] as String),
);

Map<String, dynamic> _$PortfolioToJson(Portfolio instance) => <String, dynamic>{
  'userId': instance.userId,
  'username': instance.username,
  'name': instance.name,
  'bio': instance.bio,
  'skills': instance.skills,
  'projects': instance.projects,
  'memberSince': instance.memberSince.toIso8601String(),
};

PortfolioProject _$PortfolioProjectFromJson(Map<String, dynamic> json) =>
    PortfolioProject(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      description: json['description'] as String,
      techStack: json['techStack'] as String?,
      githubLink: json['githubLink'] as String?,
      liveLink: json['liveLink'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$PortfolioProjectToJson(PortfolioProject instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'techStack': instance.techStack,
      'githubLink': instance.githubLink,
      'liveLink': instance.liveLink,
      'createdAt': instance.createdAt.toIso8601String(),
    };
