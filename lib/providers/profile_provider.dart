import 'package:flutter/material.dart';
import '../data/models/profile.dart';
import '../data/repositories/profile_repository.dart';

class ProfileProvider extends ChangeNotifier {
  final ProfileRepository _repository = ProfileRepository();
  
  Profile? _profile;
  List<Profile> _allProfiles = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  Profile? get profile => _profile;
  List<Profile> get allProfiles => _allProfiles;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasProfile => _profile != null;

  Future<bool> loadMyProfile() async {
    _setLoading(true);
    _clearError();

    try {
      _profile = await _repository.getMyProfile();
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setLoading(false);
      if (e.toString().contains('not found')) {
        _profile = null;
      } else {
        _error = e.toString();
      }
      notifyListeners();
      return false;
    }
  }

  Future<bool> loadProfileByUsername(String username) async {
    _setLoading(true);
    _clearError();

    try {
      _profile = await _repository.getProfileByUsername(username);
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setLoading(false);
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> createOrUpdateProfile({
    String? bio,
    String? skills,
    String? githubUrl,
    String? linkedinUrl,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      _profile = await _repository.createOrUpdateProfile(
        bio: bio,
        skills: skills,
        githubUrl: githubUrl,
        linkedinUrl: linkedinUrl,
      );
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setLoading(false);
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteProfile() async {
    _setLoading(true);
    _clearError();

    try {
      await _repository.deleteProfile();
      _profile = null;
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setLoading(false);
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> loadAllProfiles() async {
    _setLoading(true);
    _clearError();

    try {
      _allProfiles = await _repository.getAllProfiles();
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setLoading(false);
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  void clearProfile() {
    _profile = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }
}