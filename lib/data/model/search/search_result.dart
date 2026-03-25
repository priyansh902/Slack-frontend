import 'package:json_annotation/json_annotation.dart';

part 'search_result.g.dart';

@JsonSerializable()
class SearchResult {
  final int userId;
  final String username;
  final String name;
  final DateTime memberSince;
  final bool hasProfile;
  final int? profileId;
  final String? bio;
  final String? githubUrl;
  final String? linkedinUrl;
  final bool hasProjects;
  final int projectCount;
  final bool isYou;
  
  SearchResult({
    required this.userId,
    required this.username,
    required this.name,
    required this.memberSince,
    required this.hasProfile,
    this.profileId,
    this.bio,
    this.githubUrl,
    this.linkedinUrl,
    required this.hasProjects,
    required this.projectCount,
    required this.isYou,
  });
  
  factory SearchResult.fromJson(Map<String, dynamic> json) => 
      _$SearchResultFromJson(json);
}