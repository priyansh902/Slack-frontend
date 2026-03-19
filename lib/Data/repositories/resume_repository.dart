import 'dart:io';
import 'package:dio/dio.dart';
import '../models/resume.dart';
import '../services/api_service.dart';
import '../../core/constants/api_endpoints.dart';

class ResumeRepository {
  final ApiService _apiService = ApiService();

  // ========== USER METHODS ==========

  Future<Resume> uploadResume(File file) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          file.path,
          filename: file.path.split('/').last,
        ),
      });

      final response = await _apiService.postMultipart(
        ApiEndpoints.resumeUpload,
        data: formData,
      );
      
      if (response.statusCode == 200) {
        // Handle response format
        if (response.data is Map && response.data.containsKey('resume')) {
          return Resume.fromJson(response.data['resume']);
        } else {
          return Resume.fromJson(response.data);
        }
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
      final response = await _apiService.get(ApiEndpoints.myResume);
      
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
      final response = await _apiService.get('${ApiEndpoints.resumeByUser}/$userId');
      
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
      final response = await _apiService.get('${ApiEndpoints.resumeByUsername}/$username');
      
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
      await _apiService.delete(ApiEndpoints.myResume);
    } on DioException catch (e) {
      throw Exception('Failed to delete resume: ${e.message}');
    }
  }

  // ========== ADMIN METHODS ==========

  Future<List<Resume>> getAllResumesAdmin() async {
    try {
      final response = await _apiService.get(ApiEndpoints.adminResumes);
      
      if (response.statusCode == 200) {
        // Handle both possible response formats
        if (response.data is Map && response.data.containsKey('resumes')) {
          final data = response.data['resumes'] as List;
          return data.map((r) => Resume.fromJson(r)).toList();
        } else if (response.data is List) {
          return (response.data as List).map((r) => Resume.fromJson(r)).toList();
        }
      }
      return [];
    } on DioException catch (e) {
      throw Exception('Failed to load all resumes: ${e.message}');
    } catch (e) {
      throw Exception('Failed to load all resumes: $e');
    }
  }

  Future<void> adminDeleteResume(int resumeId) async {
    try {
      await _apiService.delete('${ApiEndpoints.adminResumes}/$resumeId');
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('Resume not found');
      }
      throw Exception('Failed to delete resume: ${e.message}');
    }
  }

  Future<Map<String, dynamic>> getResumeStats() async {
    try {
      final response = await _apiService.get('${ApiEndpoints.adminResumes}/stats');
      
      if (response.statusCode == 200) {
        return response.data;
      }
      return {};
    } on DioException catch (e) {
      throw Exception('Failed to get resume stats: ${e.message}');
    }
  }
}