import 'package:phoenix_slack/Data/models/project.dart';

class PublicPortfolio {
  final String username;
  final String name;
  final String? email;
  final String bio;
  final List<String> skills;
  final String? githubUrl;
  final String? linkedinUrl;
  final List<Project> projects;
  final String? resumeUrl;
  final int projectCount;
  final DateTime memberSince;
  final DateTime lastUpdated;

  PublicPortfolio({
    required this.username,
    required this.name,
    this.email,
    required this.bio,
    required this.skills,
    this.githubUrl,
    this.linkedinUrl,
    required this.projects,
    this.resumeUrl,
    required this.projectCount,
    required this.memberSince,
    required this.lastUpdated,
  });

  factory PublicPortfolio.fromJson(Map<String, dynamic> json) {
    return PublicPortfolio(
      username: json['username'],
      name: json['name'],
      email: json['email'],
      bio: json['bio'] ?? '',
      skills: List<String>.from(json['skills'] ?? []),
      githubUrl: json['githubUrl'],
      linkedinUrl: json['linkedinUrl'],
      projects: (json['projects'] as List)
          .map((p) => Project.fromJson(p))
          .toList(),
      resumeUrl: json['resumeUrl'],
      projectCount: json['projectCount'],
      memberSince: DateTime.parse(json['memberSince']),
      lastUpdated: DateTime.parse(json['lastUpdated']),
    );
  }
}