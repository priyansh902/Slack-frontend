import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class CacheManager {
  static const String _keyRecentProjects = 'recent_projects';
  static const String _keyMyProfile = 'my_profile';
  static const String _keyMyProjects = 'my_projects';
  static const String _keyRecentUsers = 'recent_users';
  static const String _keyUserPreferences = 'user_preferences';
  
  final SharedPreferences _prefs;
  
  CacheManager(this._prefs);
  
  // Recent Projects
  Future<void> cacheRecentProjects(List<dynamic> projects) async {
    await _prefs.setString(_keyRecentProjects, jsonEncode(projects));
  }
  
  List<dynamic>? getCachedRecentProjects() {
    final data = _prefs.getString(_keyRecentProjects);
    if (data != null) {
      return jsonDecode(data);
    }
    return null;
  }
  
  // My Profile
  Future<void> cacheMyProfile(Map<String, dynamic> profile) async {
    await _prefs.setString(_keyMyProfile, jsonEncode(profile));
  }
  
  Map<String, dynamic>? getCachedMyProfile() {
    final data = _prefs.getString(_keyMyProfile);
    if (data != null) {
      return jsonDecode(data);
    }
    return null;
  }
  
  // My Projects
  Future<void> cacheMyProjects(List<dynamic> projects) async {
    await _prefs.setString(_keyMyProjects, jsonEncode(projects));
  }
  
  List<dynamic>? getCachedMyProjects() {
    final data = _prefs.getString(_keyMyProjects);
    if (data != null) {
      return jsonDecode(data);
    }
    return null;
  }
  
  // Recent Users
  Future<void> cacheRecentUsers(List<dynamic> users) async {
    await _prefs.setString(_keyRecentUsers, jsonEncode(users));
  }
  
  List<dynamic>? getCachedRecentUsers() {
    final data = _prefs.getString(_keyRecentUsers);
    if (data != null) {
      return jsonDecode(data);
    }
    return null;
  }
  
  // User Preferences
  Future<void> saveUserPreference(String key, dynamic value) async {
    // ignore: unused_local_variable
    final prefs = _prefs;
    final prefsMap = getCachedUserPreferences() ?? {};
    prefsMap[key] = value;
    await _prefs.setString(_keyUserPreferences, jsonEncode(prefsMap));
  }
  
  Map<String, dynamic>? getCachedUserPreferences() {
    final data = _prefs.getString(_keyUserPreferences);
    if (data != null) {
      return jsonDecode(data);
    }
    return null;
  }
  
  // Clear all cache
  Future<void> clearAllCache() async {
    await _prefs.remove(_keyRecentProjects);
    await _prefs.remove(_keyMyProfile);
    await _prefs.remove(_keyMyProjects);
    await _prefs.remove(_keyRecentUsers);
  }
  
  // Clear specific cache
  Future<void> clearRecentProjectsCache() async {
    await _prefs.remove(_keyRecentProjects);
  }
  
  Future<void> clearMyProfileCache() async {
    await _prefs.remove(_keyMyProfile);
  }
  
  Future<void> clearMyProjectsCache() async {
    await _prefs.remove(_keyMyProjects);
  }
}