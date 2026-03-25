import 'package:json_annotation/json_annotation.dart';

part 'portfolio.g.dart';

@JsonSerializable()
class Portfolio {
  final int userId;
  final String username;
  final String name;
  final String? bio;
  final List<String> skills;
  final List<PortfolioProject> projects;
  final DateTime memberSince;
  
  Portfolio({
    required this.userId,
    required this.username,
    required this.name,
    this.bio,
    required this.skills,
    required this.projects,
    required this.memberSince,
  });
  
  factory Portfolio.fromJson(Map<String, dynamic> json) => _$PortfolioFromJson(json);
  Map<String, dynamic> toJson() => _$PortfolioToJson(this);
}

@JsonSerializable()
class PortfolioProject {
  final int id;
  final String title;
  final String description;
  final String? techStack;
  final String? githubLink;
  final String? liveLink;
  final DateTime createdAt;
  
  PortfolioProject({
    required this.id,
    required this.title,
    required this.description,
    this.techStack,
    this.githubLink,
    this.liveLink,
    required this.createdAt,
  });
  
  factory PortfolioProject.fromJson(Map<String, dynamic> json) => _$PortfolioProjectFromJson(json);
  Map<String, dynamic> toJson() => _$PortfolioProjectToJson(this);
}