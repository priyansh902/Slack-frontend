class Resume {
  final int id;
  final int userId;
  final String username;
  final String fileName;
  final String? fileUrl;
  final int fileSize;
  final String contentType;
  final DateTime uploadedAt;
  final DateTime updatedAt;

  Resume({
    required this.id,
    required this.userId,
    required this.username,
    required this.fileName,
    this.fileUrl,
    required this.fileSize,
    required this.contentType,
    required this.uploadedAt,
    required this.updatedAt,
  });

  factory Resume.fromJson(Map<String, dynamic> json) {
    return Resume(
      id: json['id'],
      userId: json['userId'],
      username: json['username'],
      fileName: json['fileName'],
      fileUrl: json['fileUrl'],
      fileSize: json['fileSize'],
      contentType: json['contentType'],
      uploadedAt: DateTime.parse(json['uploadedAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  String get formattedFileSize {
    if (fileSize <= 0) return '0 B';
    const suffixes = ['B', 'KB', 'MB'];
    var i = (fileSize / 1024).floor();
    if (i == 0) return '$fileSize B';
    return '${(fileSize / 1024).toStringAsFixed(1)} ${suffixes[i]}';
  }
}