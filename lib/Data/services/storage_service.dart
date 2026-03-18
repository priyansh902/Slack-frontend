import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_constants.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  late SharedPreferences _prefs;

  // Initialize
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Secure Storage (for tokens, sensitive data)
  Future<void> setSecureData(String key, String value) async {
    await _secureStorage.write(key: key, value: value);
  }

  Future<String?> getSecureData(String key) async {
    return await _secureStorage.read(key: key);
  }

  Future<void> removeSecureData(String key) async {
    await _secureStorage.delete(key: key);
  }

  Future<void> clearAllSecureData() async {
    await _secureStorage.deleteAll();
  }

  // Shared Preferences (for non-sensitive data)
  Future<void> setData(String key, dynamic value) async {
    if (value is String) {
      await _prefs.setString(key, value);
    } else if (value is int) {
      await _prefs.setInt(key, value);
    } else if (value is bool) {
      await _prefs.setBool(key, value);
    } else if (value is double) {
      await _prefs.setDouble(key, value);
    } else if (value is List<String>) {
      await _prefs.setStringList(key, value);
    }
  }

  String? getString(String key) => _prefs.getString(key);
  int? getInt(String key) => _prefs.getInt(key);
  bool? getBool(String key) => _prefs.getBool(key);
  double? getDouble(String key) => _prefs.getDouble(key);
  List<String>? getStringList(String key) => _prefs.getStringList(key);

  Future<void> removeData(String key) async {
    await _prefs.remove(key);
  }

  Future<void> clearAllData() async {
    await _prefs.clear();
  }

  // Auth specific methods
  Future<void> saveToken(String token) async {
    await setSecureData(AppConstants.tokenKey, token);
  }

  Future<String?> getToken() async {
    return await getSecureData(AppConstants.tokenKey);
  }

  Future<void> removeToken() async {
    await removeSecureData(AppConstants.tokenKey);
  }

  Future<void> saveUser(Map<String, dynamic> user) async {
    final userJson = json.encode(user);
    await setData(AppConstants.userKey, userJson);
  }

  Map<String, dynamic>? getUser() {
    final userJson = getString(AppConstants.userKey);
    if (userJson != null) {
      return json.decode(userJson);
    }
    return null;
  }

  Future<void> removeUser() async {
    await removeData(AppConstants.userKey);
  }

  Future<void> clearAuth() async {
    await removeToken();
    await removeUser();
  }
}