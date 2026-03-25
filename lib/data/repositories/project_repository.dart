import 'package:phoenix_slack/data/datasources/api_service.dart';
import 'package:phoenix_slack/data/model/project/project.dart';


class ProjectRepository {
  final ApiService _apiService;
  
  ProjectRepository(this._apiService);
  
  Future<List<Project>> getMyProjects() async {
    final response = await _apiService.getMyProjects();
    return (response['projects'] as List)
        .map((json) => Project.fromJson(json))
        .toList();
  }
  
  Future<List<Project>> getProjectsByUsername(String username) async {
    final response = await _apiService.getProjectsByUsername(username);
    return (response['projects'] as List)
        .map((json) => Project.fromJson(json))
        .toList();
  }
  
  Future<Project> getProjectById(int projectId) async {
    return await _apiService.getProjectById(projectId);
  }
  
  Future<Project> createProject(ProjectRequest request) async {
    return await _apiService.createProject(request);
  }
  
  Future<Project> updateProject(int projectId, ProjectRequest request) async {
    return await _apiService.updateProject(projectId, request);
  }
  
  Future<void> deleteProject(int projectId) async {
    await _apiService.deleteProject(projectId);
  }
  
  Future<List<Project>> searchProjectsByTitle(String query) async {
    final response = await _apiService.searchProjectsByTitle(query);
    return (response['results'] as List)
        .map((json) => Project.fromJson(json))
        .toList();
  }
  
  Future<List<Project>> searchProjectsByTech(String tech) async {
    final response = await _apiService.searchProjectsByTech(tech);
    return (response['results'] as List)
        .map((json) => Project.fromJson(json))
        .toList();
  }
  
  Future<List<Project>> getRecentProjects() async {
    final response = await _apiService.getRecentProjects();
    return (response['projects'] as List)
        .map((json) => Project.fromJson(json))
        .toList();
  }
}