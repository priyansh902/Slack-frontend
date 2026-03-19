import 'dart:io';
import 'package:flutter/material.dart';
import '../data/models/resume.dart';
import '../data/repositories/resume_repository.dart';

class ResumeProvider extends ChangeNotifier {
  final ResumeRepository _repository = ResumeRepository();
  
  Resume? _resume;
  List<Resume> _allResumes = [];
  bool _isLoading = false;
  String? _error;
  double _uploadProgress = 0.0;

  // Getters
  Resume? get resume => _resume;
  List<Resume> get allResumes => _allResumes;
  bool get isLoading => _isLoading;
  String? get error => _error;
  double get uploadProgress => _uploadProgress;
  bool get hasResume => _resume != null;

  Future<bool> loadMyResume() async {
    _setLoading(true);
    _clearError();

    try {
      _resume = await _repository.getMyResume();
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setLoading(false);
      if (!e.toString().contains('not found')) {
        _error = e.toString().replaceFirst('Exception: ', '');
      }
      notifyListeners();
      return false;
    }
  }

  Future<bool> loadResumeByUserId(int userId) async {
    _setLoading(true);
    _clearError();

    try {
      _resume = await _repository.getResumeByUserId(userId);
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setLoading(false);
      if (!e.toString().contains('not found')) {
        _error = e.toString().replaceFirst('Exception: ', '');
      }
      notifyListeners();
      return false;
    }
  }

  Future<bool> loadResumeByUsername(String username) async {
    _setLoading(true);
    _clearError();

    try {
      _resume = await _repository.getResumeByUsername(username);
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setLoading(false);
      if (!e.toString().contains('not found')) {
        _error = e.toString().replaceFirst('Exception: ', '');
      }
      notifyListeners();
      return false;
    }
  }

  Future<bool> uploadResume(File file) async {
    _setLoading(true);
    _clearError();
    _uploadProgress = 0.0;

    try {
      _resume = await _repository.uploadResume(file);
      _uploadProgress = 1.0;
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setLoading(false);
      _uploadProgress = 0.0;
      _error = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteResume() async {
    _setLoading(true);
    _clearError();

    try {
      await _repository.deleteResume();
      _resume = null;
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setLoading(false);
      _error = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  // ========== ADMIN METHODS ==========

  Future<bool> loadAllResumes() async {
    _setLoading(true);
    _clearError();

    try {
      // FIXED: Changed from getAllResumes() to getAllResumesAdmin()
      _allResumes = await _repository.getAllResumesAdmin();
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setLoading(false);
      _error = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  Future<bool> adminDeleteResume(int resumeId) async {
    _setLoading(true);
    _clearError();

    try {
      await _repository.adminDeleteResume(resumeId);
      _allResumes.removeWhere((r) => r.id == resumeId);
      if (_resume?.id == resumeId) {
        _resume = null;
      }
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setLoading(false);
      _error = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  Future<void> refreshAllResumes() async {
    await loadAllResumes();
  }

  void clearResume() {
    _resume = null;
    notifyListeners();
  }

  void clearAllResumes() {
    _allResumes = [];
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