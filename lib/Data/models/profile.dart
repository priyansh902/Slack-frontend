class Profile {
  final int id;
  final int userId;
  final String username;
  final String name;
  final String? bio;
  final List<String> skills;
  final String? githubUrl;
  final String? linkedinUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  Profile({
    required this.id,
    required this.userId,
    required this.username,
    required this.name,
    this.bio,
    required this.skills,
    this.githubUrl,
    this.linkedinUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    // Parse skills string into list
    List<String> skillsList = [];
    if (json['skills'] != null && json['skills'].isNotEmpty) {
      skillsList = (json['skills'] as String)
          .split(',')
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();
    }

    return Profile(
      id: json['id'],
      userId: json['userId'],
      username: json['username'],
      name: json['name'],
      bio: json['bio'],
      skills: skillsList,
      githubUrl: json['githubUrl'],
      linkedinUrl: json['linkedinUrl'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}