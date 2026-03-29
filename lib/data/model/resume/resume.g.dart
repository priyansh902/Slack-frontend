// GENERATED CODE - DO NOT MODIFY BY HAND
part of 'resume.dart';

Resume _$ResumeFromJson(Map<String, dynamic> json) => Resume(
  id: (json['id'] as num?)?.toInt() ?? 0,
  userId: (json['userId'] as num?)?.toInt() ?? 0,
  username: json['username'] as String? ?? '',
  fileName: json['fileName'] as String? ?? 'resume.pdf',
  fileUrl: json['fileUrl'] as String? ?? '',
  fileSize: (json['fileSize'] as num?)?.toInt(),
  contentType: json['contentType'] as String?,
  uploadedAt: json['uploadedAt'] != null
    ? DateTime.tryParse(json['uploadedAt'] as String) ?? DateTime.now()
    : DateTime.now(),
  updatedAt: json['updatedAt'] == null
    ? null
    : DateTime.tryParse(json['updatedAt'] as String),
);

Map<String, dynamic> _$ResumeToJson(Resume instance) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'username': instance.username,
  'fileName': instance.fileName,
  'fileUrl': instance.fileUrl,
  'fileSize': instance.fileSize,
  'contentType': instance.contentType,
  'uploadedAt': instance.uploadedAt.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
};
