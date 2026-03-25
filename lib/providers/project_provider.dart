import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:phoenix_slack/data/model/project/project.dart';
import 'package:phoenix_slack/providers/auth_provider.dart';


final recentProjectsProvider = FutureProvider<List<Project>>((ref) async {
  final apiService = ref.read(apiServiceProvider);
  final response = await apiService.getRecentProjects();
  final projects = (response['projects'] as List)
      .map((json) => Project.fromJson(json))
      .toList();
  return projects;
});

final myProjectsProvider = FutureProvider<List<Project>>((ref) async {
  final apiService = ref.read(apiServiceProvider);
  final response = await apiService.getMyProjects();
  final projects = (response['projects'] as List)
      .map((json) => Project.fromJson(json))
      .toList();
  return projects;
});

final userProjectsProvider = FutureProvider.family<List<Project>, String>((ref, username) async {
  final apiService = ref.read(apiServiceProvider);
  final response = await apiService.getProjectsByUsername(username);
  final projects = (response['projects'] as List)
      .map((json) => Project.fromJson(json))
      .toList();
  return projects;
});

final projectDetailsProvider = FutureProvider.family<Project?, int>((ref, projectId) async {
  final apiService = ref.read(apiServiceProvider);
  try {
    return await apiService.getProjectById(projectId);
  } catch (e) {
    return null;
  }
});

class ProjectNotifier extends StateNotifier<AsyncValue<List<Project>>> {
  final Ref _ref;
  
  ProjectNotifier(this._ref) : super(const AsyncValue.loading());
  
  Future<void> loadMyProjects() async {
    state = const AsyncValue.loading();
    try {
      final apiService = _ref.read(apiServiceProvider);
      final response = await apiService.getMyProjects();
      final projects = (response['projects'] as List)
          .map((json) => Project.fromJson(json))
          .toList();
      state = AsyncValue.data(projects);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
  
  Future<bool> create(ProjectRequest request) async {
    try {
      final apiService = _ref.read(apiServiceProvider);
      await apiService.createProject(request);
      await loadMyProjects();
      return true;
    } catch (e) {
      return false;
    }
  }
  
  Future<bool> update(int projectId, ProjectRequest request) async {
    try {
      final apiService = _ref.read(apiServiceProvider);
      await apiService.updateProject(projectId, request);
      await loadMyProjects();
      return true;
    } catch (e) {
      return false;
    }
  }
  
  Future<bool> delete(int projectId) async {
    try {
      final apiService = _ref.read(apiServiceProvider);
      await apiService.deleteProject(projectId);
      await loadMyProjects();
      return true;
    } catch (e) {
      return false;
    }
  }
}

final myProjectsNotifierProvider = StateNotifierProvider<ProjectNotifier, AsyncValue<List<Project>>>((ref) {
  return ProjectNotifier(ref);
});