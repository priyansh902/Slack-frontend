// GENERATED CODE - DO NOT MODIFY BY HAND
part of 'project.dart';

Project _$ProjectFromJson(Map<String, dynamic> json) => Project(
  id: (json['id'] as num).toInt(),
  userId: (json['userId'] as num).toInt(),
  username: json['username'] as String? ?? '',
  title: json['title'] as String? ?? '',
  description: json['description'] as String? ?? '',
  techStack: json['techStack'] as String?,
  githubLink: json['githubLink'] as String?,
  liveLink: json['liveLink'] as String?,
  createdAt: json['createdAt'] != null
    ? DateTime.parse(json['createdAt'] as String)
    : DateTime.now(),
  updatedAt: json['updatedAt'] == null
    ? null
    : DateTime.tryParse(json['updatedAt'] as String),
);

Map<String, dynamic> _$ProjectToJson(Project instance) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'username': instance.username,
  'title': instance.title,
  'description': instance.description,
  'techStack': instance.techStack,
  'githubLink': instance.githubLink,
  'liveLink': instance.liveLink,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
};

ProjectRequest _$ProjectRequestFromJson(Map<String, dynamic> json) => ProjectRequest(
  title: json['title'] as String,
  description: json['description'] as String?,
  techStack: json['techStack'] as String?,
  githubLink: json['githubLink'] as String?,
  liveLink: json['liveLink'] as String?,
);

Map<String, dynamic> _$ProjectRequestToJson(ProjectRequest instance) => <String, dynamic>{
  'title': instance.title,
  'description': instance.description,
  'techStack': instance.techStack,
  'githubLink': instance.githubLink,
  'liveLink': instance.liveLink,
};
