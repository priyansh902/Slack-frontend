import 'package:dio/dio.dart';
import 'package:phoenix_slack/data/datasources/api_service.dart';
import 'package:phoenix_slack/data/model/resume/resume.dart';


class ResumeRepository {
  final ApiService _apiService;
  
  ResumeRepository(this._apiService);
  
  Future<Resume?> getMyResume() async {
    try {
      final response = await _apiService.getMyResume();
      if (response.containsKey('resume')) {
        return Resume.fromJson(response['resume']);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
  
  Future<Resume> uploadResume(MultipartFile file) async {
    final response = await _apiService.uploadResume(file);
    return Resume.fromJson(response['resume']);
  }
  
  Future<void> deleteMyResume() async {
    await _apiService.deleteMyResume();
  }
  
  Future<Map<String, dynamic>> getResumeByUsername(String username) async {
    return await _apiService.getResumeByUsername(username);
  }
  
  Future<Map<String, dynamic>> getResumeByUserId(int userId) async {
    return await _apiService.getResumeByUserId(userId);
  }
}