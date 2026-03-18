class UserSearchResult {
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

  UserSearchResult({
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

  factory UserSearchResult.fromJson(Map<String, dynamic> json) {
    return UserSearchResult(
      userId: json['userId'],
      username: json['username'],
      name: json['name'],
      memberSince: DateTime.parse(json['memberSince']),
      hasProfile: json['hasProfile'] ?? false,
      profileId: json['profileId'],
      bio: json['bio'],
      githubUrl: json['githubUrl'],
      linkedinUrl: json['linkedinUrl'],
      hasProjects: json['hasProjects'] ?? false,
      projectCount: json['projectCount'] ?? 0,
      isYou: json['isYou'] ?? false,
    );
  }
}