import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LocalStorage {
  static const String _keyRecentProjects = 'recent_projects';
  static const String _keyMyProfile = 'my_profile';
  static const String _keyMyProjects = 'my_projects';
  
  final SharedPreferences _prefs;
  
  LocalStorage(this._prefs);
  
  Future<void> saveRecentProjects(List<dynamic> projects) async {
    await _prefs.setString(_keyRecentProjects, jsonEncode(projects));
  }
  
  List<dynamic>? getRecentProjects() {
    final data = _prefs.getString(_keyRecentProjects);
    if (data != null) {
      return jsonDecode(data);
    }
    return null;
  }
  
  Future<void> clearCache() async {
    await _prefs.remove(_keyRecentProjects);
    await _prefs.remove(_keyMyProfile);
    await _prefs.remove(_keyMyProjects);
  }
  
  Future<void> clearAll() async {
    await _prefs.clear();
  }
}