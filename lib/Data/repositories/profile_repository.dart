import 'package:dio/dio.dart';
import '../models/profile.dart';
import '../services/api_service.dart';
import '../../core/constants/api_endpoints.dart';

class ProfileRepository {
  final ApiService _apiService = ApiService();

  Future<Profile> getMyProfile() async {
    try {
      final response = await _apiService.get(ApiEndpoints.profile);
      
      if (response.statusCode == 200) {
        return Profile.fromJson(response.data);
      }
      throw Exception('Failed to load profile');
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('Profile not found');
      }
      throw Exception('Failed to load profile: ${e.message}');
    }
  }

  Future<Profile> getProfileByUsername(String username) async {
    try {
      final response = await _apiService.get('${ApiEndpoints.profileByUsername}/$username');
      
      if (response.statusCode == 200) {
        return Profile.fromJson(response.data);
      }
      throw Exception('Profile not found');
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('Profile not found for username: $username');
      }
      throw Exception('Failed to load profile: ${e.message}');
    }
  }

  Future<Profile> getProfileByUserId(int userId) async {
    try {
      final response = await _apiService.get('${ApiEndpoints.profileByUserId}/$userId');
      
      if (response.statusCode == 200) {
        return Profile.fromJson(response.data);
      }
      throw Exception('Profile not found');
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('Profile not found for user ID: $userId');
      }
      throw Exception('Failed to load profile: ${e.message}');
    }
  }

  Future<Profile> createOrUpdateProfile({
    String? bio,
    String? skills,
    String? githubUrl,
    String? linkedinUrl,
  }) async {
    try {
      final response = await _apiService.post(
        ApiEndpoints.profile,
        data: {
          'bio': ?bio,
          'skills': ?skills,
          'githubUrl': ?githubUrl,
          'linkedinUrl': ?linkedinUrl,
        },
      );
      
      if (response.statusCode == 200) {
        return Profile.fromJson(response.data);
      }
      throw Exception('Failed to save profile');
    } on DioException catch (e) {
      throw Exception('Failed to save profile: ${e.message}');
    }
  }

  Future<void> deleteProfile() async {
    try {
      await _apiService.delete(ApiEndpoints.profile);
    } on DioException catch (e) {
      throw Exception('Failed to delete profile: ${e.message}');
    }
  }

  Future<List<Profile>> getAllProfiles() async {
    try {
      final response = await _apiService.get(ApiEndpoints.allProfiles);
      
      if (response.statusCode == 200) {
        final data = response.data['profiles'] as List;
        return data.map((p) => Profile.fromJson(p)).toList();
      }
      return [];
    } catch (e) {
      throw Exception('Failed to load profiles: $e');
    }
  }

  // Admin endpoints
  Future<List<Profile>> getAllProfilesAdmin() async {
    try {
      final response = await _apiService.get(ApiEndpoints.adminProfiles);
      
      if (response.statusCode == 200) {
        final data = response.data['profiles'] as List;
        return data.map((p) => Profile.fromJson(p)).toList();
      }
      return [];
    } catch (e) {
      throw Exception('Failed to load profiles: $e');
    }
  }

  Future<void> adminDeleteProfile(int profileId) async {
    try {
      await _apiService.delete('${ApiEndpoints.adminProfiles}/$profileId');
    } on DioException catch (e) {
      throw Exception('Failed to delete profile: ${e.message}');
    }
  }
}