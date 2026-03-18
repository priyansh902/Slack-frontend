import 'dart:io';
import 'package:dio/dio.dart';
import '../models/resume.dart';
import '../services/api_service.dart';

class ResumeRepository {
  final ApiService _apiService = ApiService();

  Future<Resume> uploadResume(File file) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          file.path,
          filename: file.path.split('/').last,
        ),
      });

      final response = await _apiService.postMultipart(
        '/resumes/upload',
        data: formData,
      );
      
      if (response.statusCode == 200) {
        return Resume.fromJson(response.data['resume']);
      }
      throw Exception('Failed to upload resume');
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw Exception(e.response?.data['error'] ?? 'Invalid file');
      }
      throw Exception('Failed to upload resume: ${e.message}');
    }
  }

  Future<Resume?> getMyResume() async {
    try {
      final response = await _apiService.get('/resumes/me');
      
      if (response.statusCode == 200) {
        return Resume.fromJson(response.data);
      }
      return null;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return null;
      }
      throw Exception('Failed to load resume: ${e.message}');
    }
  }

  Future<Resume?> getResumeByUserId(int userId) async {
    try {
      final response = await _apiService.get('/resumes/user/$userId');
      
      if (response.statusCode == 200) {
        return Resume.fromJson(response.data);
      }
      return null;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return null;
      }
      throw Exception('Failed to load resume: ${e.message}');
    }
  }

  Future<Resume?> getResumeByUsername(String username) async {
    try {
      final response = await _apiService.get('/resumes/username/$username');
      
      if (response.statusCode == 200) {
        return Resume.fromJson(response.data);
      }
      return null;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return null;
      }
      throw Exception('Failed to load resume: ${e.message}');
    }
  }

  Future<void> deleteResume() async {
    try {
      await _apiService.delete('/resumes/me');
    } on DioException catch (e) {
      throw Exception('Failed to delete resume: ${e.message}');
    }
  }

  // Admin endpoints
  Future<List<Resume>> getAllResumes() async {
    try {
      final response = await _apiService.get('/resumes/admin/all');
      
      if (response.statusCode == 200) {
        final data = response.data['resumes'] as List;
        return data.map((r) => Resume.fromJson(r)).toList();
      }
      return [];
    } catch (e) {
      throw Exception('Failed to load resumes: $e');
    }
  }

  Future<void> adminDeleteResume(int resumeId) async {
    try {
      await _apiService.delete('/resumes/admin/$resumeId');
    } on DioException catch (e) {
      throw Exception('Failed to delete resume: ${e.message}');
    }
  }
}