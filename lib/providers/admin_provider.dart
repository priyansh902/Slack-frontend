import 'package:flutter/material.dart';
import '../data/repositories/profile_repository.dart';
import '../data/repositories/project_repository.dart';
import '../data/repositories/resume_repository.dart';
import '../data/models/profile.dart';
import '../data/models/project.dart';
import '../data/models/resume.dart';

class AdminProvider extends ChangeNotifier {
  final ProfileRepository _profileRepo = ProfileRepository();
  final ProjectRepository _projectRepo = ProjectRepository();
  final ResumeRepository _resumeRepo = ResumeRepository();
  
  List<Profile> _allProfiles = [];
  List<Project> _allProjects = [];
  List<Resume> _allResumes = [];
  bool _isLoading = false;
  String? _error;
  Map<String, dynamic> _stats = {};

  // Getters
  List<Profile> get allProfiles => _allProfiles;
  List<Project> get allProjects => _allProjects;
  List<Resume> get allResumes => _allResumes;
  bool get isLoading => _isLoading;
  String? get error => _error;
  Map<String, dynamic> get stats => _stats;

  // Load all data
  Future<void> loadAllData() async {
    _setLoading(true);
    _clearError();

    try {
      await Future.wait([
        _loadAllProfiles(),
        _loadAllProjects(),
        _loadAllResumes(),
        _loadStats(),
      ]);
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _loadAllProfiles() async {
    try {
      _allProfiles = await _profileRepo.getAllProfilesAdmin();
    } catch (e) {
      debugPrint('Error loading profiles: $e');
      _allProfiles = [];
    }
  }

  Future<void> _loadAllProjects() async {
    try {
      _allProjects = await _projectRepo.getAllProjectsAdmin();
    } catch (e) {
      debugPrint('Error loading projects: $e');
      _allProjects = [];
    }
  }

  Future<void> _loadAllResumes() async {
    try {
      _allResumes = await _resumeRepo.getAllResumesAdmin();
    } catch (e) {
      debugPrint('Error loading resumes: $e');
      _allResumes = [];
    }
  }

  Future<void> _loadStats() async {
    try {
      // You can implement combined stats or individual calls
      _stats = {
        'totalProfiles': _allProfiles.length,
        'totalProjects': _allProjects.length,
        'totalResumes': _allResumes.length,
      };
    } catch (e) {
      debugPrint('Error loading stats: $e');
      _stats = {};
    }
  }

  // Profile admin methods
  Future<bool> deleteProfile(int profileId) async {
    try {
      await _profileRepo.adminDeleteProfile(profileId);
      _allProfiles.removeWhere((p) => p.id == profileId);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    }
  }

  // Project admin methods
  Future<bool> deleteProject(int projectId) async {
    try {
      await _projectRepo.adminDeleteProject(projectId);
      _allProjects.removeWhere((p) => p.id == projectId);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    }
  }

  // Resume admin methods
  Future<bool> deleteResume(int resumeId) async {
    try {
      await _resumeRepo.adminDeleteResume(resumeId);
      _allResumes.removeWhere((r) => r.id == resumeId);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    }
  }

  // Bulk delete methods
  Future<Map<String, int>> deleteAllProfiles() async {
    int success = 0;
    int failed = 0;
    
    for (var profile in List.from(_allProfiles)) {
      try {
        await _profileRepo.adminDeleteProfile(profile.id);
        _allProfiles.remove(profile);
        success++;
      } catch (e) {
        failed++;
      }
    }
    
    notifyListeners();
    return {'success': success, 'failed': failed};
  }

  Future<Map<String, int>> deleteAllProjects() async {
    int success = 0;
    int failed = 0;
    
    for (var project in List.from(_allProjects)) {
      try {
        await _projectRepo.adminDeleteProject(project.id);
        _allProjects.remove(project);
        success++;
      } catch (e) {
        failed++;
      }
    }
    
    notifyListeners();
    return {'success': success, 'failed': failed};
  }

  Future<Map<String, int>> deleteAllResumes() async {
    int success = 0;
    int failed = 0;
    
    for (var resume in List.from(_allResumes)) {
      try {
        await _resumeRepo.adminDeleteResume(resume.id);
        _allResumes.remove(resume);
        success++;
      } catch (e) {
        failed++;
      }
    }
    
    notifyListeners();
    return {'success': success, 'failed': failed};
  }

  // Search/filter methods for admin
  List<Profile> searchProfiles(String query) {
    if (query.isEmpty) return _allProfiles;
    return _allProfiles.where((p) =>
      p.name.toLowerCase().contains(query.toLowerCase()) ||
      p.username.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }

  List<Project> searchProjects(String query) {
    if (query.isEmpty) return _allProjects;
    return _allProjects.where((p) =>
      p.title.toLowerCase().contains(query.toLowerCase()) ||
      p.techStack.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }

  List<Resume> searchResumes(String query) {
    if (query.isEmpty) return _allResumes;
    return _allResumes.where((r) =>
      r.fileName.toLowerCase().contains(query.toLowerCase()) ||
      r.username.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }

  // Refresh specific sections
  Future<void> refreshProfiles() async {
    await _loadAllProfiles();
    notifyListeners();
  }

  Future<void> refreshProjects() async {
    await _loadAllProjects();
    notifyListeners();
  }

  Future<void> refreshResumes() async {
    await _loadAllResumes();
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