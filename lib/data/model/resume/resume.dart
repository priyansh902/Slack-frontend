import 'package:json_annotation/json_annotation.dart';

part 'resume.g.dart';

@JsonSerializable()
class Resume {
  final int id;
  final int userId;
  final String username;
  final String fileName;
  final String fileUrl;
  final int? fileSize;
  final String? contentType;
  final DateTime uploadedAt;
  final DateTime? updatedAt;
  
  Resume({
    required this.id,
    required this.userId,
    required this.username,
    required this.fileName,
    required this.fileUrl,
    this.fileSize,
    this.contentType,
    required this.uploadedAt,
    this.updatedAt,
  });
  
  factory Resume.fromJson(Map<String, dynamic> json) => _$ResumeFromJson(json);
  
  String get formattedFileSize {
    if (fileSize == null) return 'Unknown';
    if (fileSize! < 1024) return '$fileSize B';
    if (fileSize! < 1024 * 1024) {
      return '${(fileSize! / 1024).toStringAsFixed(1)} KB';
    }
    return '${(fileSize! / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}