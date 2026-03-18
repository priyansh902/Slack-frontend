import 'package:flutter/material.dart';
import '../data/models/project.dart';
import '../data/repositories/project_repository.dart';

class ProjectProvider extends ChangeNotifier {
  final ProjectRepository _repository = ProjectRepository();
  
  List<Project> _myProjects = [];
  List<Project> _currentProjects = [];
  Project? _currentProject;
  bool _isLoading = false;
  String? _error;

  // Getters
  List<Project> get myProjects => _myProjects;
  List<Project> get currentProjects => _currentProjects;
  Project? get currentProject => _currentProject;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<bool> loadMyProjects() async {
    _setLoading(true);
    _clearError();

    try {
      _myProjects = await _repository.getMyProjects();
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

  Future<bool> loadProjectsByUserId(int userId) async {
    _setLoading(true);
    _clearError();

    try {
      _currentProjects = await _repository.getProjectsByUserId(userId);
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

  Future<bool> loadProjectsByUsername(String username) async {
    _setLoading(true);
    _clearError();

    try {
      _currentProjects = await _repository.getProjectsByUsername(username);
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

  Future<bool> loadProjectById(int projectId) async {
    _setLoading(true);
    _clearError();

    try {
      _currentProject = await _repository.getProjectById(projectId);
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

  Future<bool> createProject({
    required String title,
    String? description,
    String? techStack,
    String? githubLink,
    String? liveLink,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final newProject = await _repository.createProject(
        title: title,
        description: description,
        techStack: techStack,
        githubLink: githubLink,
        liveLink: liveLink,
      );
      _myProjects.add(newProject);
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

  Future<bool> updateProject({
    required int projectId,
    String? title,
    String? description,
    String? techStack,
    String? githubLink,
    String? liveLink,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final updatedProject = await _repository.updateProject(
        projectId: projectId,
        title: title,
        description: description,
        techStack: techStack,
        githubLink: githubLink,
        liveLink: liveLink,
      );
      
      // Update in list
      final index = _myProjects.indexWhere((p) => p.id == projectId);
      if (index != -1) {
        _myProjects[index] = updatedProject;
      }
      
      if (_currentProject?.id == projectId) {
        _currentProject = updatedProject;
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

  Future<bool> deleteProject(int projectId) async {
    _setLoading(true);
    _clearError();

    try {
      await _repository.deleteProject(projectId);
      _myProjects.removeWhere((p) => p.id == projectId);
      _currentProjects.removeWhere((p) => p.id == projectId);
      
      if (_currentProject?.id == projectId) {
        _currentProject = null;
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

  Future<bool> searchProjectsByTitle(String query) async {
    _setLoading(true);
    _clearError();

    try {
      _currentProjects = await _repository.searchProjectsByTitle(query);
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

  Future<bool> searchProjectsByTech(String tech) async {
    _setLoading(true);
    _clearError();

    try {
      _currentProjects = await _repository.searchProjectsByTech(tech);
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

  Future<bool> loadRecentProjects() async {
    _setLoading(true);
    _clearError();

    try {
      _currentProjects = await _repository.getRecentProjects();
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

  void clearProjects() {
    _myProjects = [];
    _currentProjects = [];
    _currentProject = null;
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