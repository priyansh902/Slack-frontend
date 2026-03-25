import 'package:json_annotation/json_annotation.dart';

part 'project.g.dart';

@JsonSerializable()
class Project {
  final int id;
  final int userId;
  final String username;
  final String title;
  final String description;
  final String? techStack;
  final String? githubLink;
  final String? liveLink;
  final DateTime createdAt;
  final DateTime? updatedAt;
  
  Project({
    required this.id,
    required this.userId,
    required this.username,
    required this.title,
    required this.description,
    this.techStack,
    this.githubLink,
    this.liveLink,
    required this.createdAt,
    this.updatedAt,
  });
  
  factory Project.fromJson(Map<String, dynamic> json) => _$ProjectFromJson(json);
  Map<String, dynamic> toJson() => _$ProjectToJson(this);
  
  List<String> get techStackList {
    if (techStack == null || techStack!.isEmpty) return [];
    return techStack!.split(',').map((s) => s.trim()).toList();
  }
}

@JsonSerializable()
class ProjectRequest {
  final String title;
  final String? description;
  final String? techStack;
  final String? githubLink;
  final String? liveLink;
  
  ProjectRequest({
    required this.title,
    this.description,
    this.techStack,
    this.githubLink,
    this.liveLink,
  });
  
  Map<String, dynamic> toJson() => _$ProjectRequestToJson(this);
}