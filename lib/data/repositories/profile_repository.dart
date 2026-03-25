import 'package:phoenix_slack/data/datasources/api_service.dart';
import 'package:phoenix_slack/data/model/profile/profile.dart';

class ProfileRepository {
  final ApiService _apiService;
  
  ProfileRepository(this._apiService);
  
  Future<Profile> getMyProfile() async {
    return await _apiService.getMyProfile();
  }
  
  Future<Profile> getProfileByUsername(String username) async {
    return await _apiService.getProfileByUsername(username);
  }
  
  Future<Profile> getProfileByUserId(int userId) async {
    return await _apiService.getProfileByUserId(userId);
  }
  
  Future<Profile> createOrUpdateProfile(ProfileRequest request) async {
    return await _apiService.createOrUpdateProfile(request);
  }
  
  Future<void> deleteMyProfile() async {
    await _apiService.deleteMyProfile();
  }
  
  Future<Map<String, dynamic>> getAllProfiles() async {
    return await _apiService.getAllProfiles();
  }
}