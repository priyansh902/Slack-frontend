class Project {
  final int id;
  final int userId;
  final String username;
  final String title;
  final String description;
  final String techStack;
  final String? githubLink;
  final String? liveLink;
  final DateTime createdAt;
  final DateTime updatedAt;

  Project({
    required this.id,
    required this.userId,
    required this.username,
    required this.title,
    required this.description,
    required this.techStack,
    this.githubLink,
    this.liveLink,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'],
      userId: json['userId'],
      username: json['username'],
      title: json['title'],
      description: json['description'] ?? '',
      techStack: json['techStack'] ?? '',
      githubLink: json['githubLink'],
      liveLink: json['liveLink'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'techStack': techStack,
      'githubLink': githubLink,
      'liveLink': liveLink,
    };
  }
}