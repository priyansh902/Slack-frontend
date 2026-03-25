// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resume.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Resume _$ResumeFromJson(Map<String, dynamic> json) => Resume(
  id: (json['id'] as num).toInt(),
  userId: (json['userId'] as num).toInt(),
  username: json['username'] as String,
  fileName: json['fileName'] as String,
  fileUrl: json['fileUrl'] as String,
  fileSize: (json['fileSize'] as num?)?.toInt(),
  contentType: json['contentType'] as String?,
  uploadedAt: DateTime.parse(json['uploadedAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

// ignore: unused_element
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
