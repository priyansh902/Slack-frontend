import 'package:dio/dio.dart';
import '../models/project.dart';
import '../services/api_service.dart';
import '../../core/constants/api_endpoints.dart';

class ProjectRepository {
  final ApiService _apiService = ApiService();

  Future<List<Project>> getMyProjects() async {
    try {
      final response = await _apiService.get(ApiEndpoints.myProjects);
      
      if (response.statusCode == 200) {
        final data = response.data['projects'] as List;
        return data.map((p) => Project.fromJson(p)).toList();
      }
      return [];
    } catch (e) {
      throw Exception('Failed to load projects: $e');
    }
  }

  Future<List<Project>> getProjectsByUserId(int userId) async {
    try {
      final response = await _apiService.get('${ApiEndpoints.projectsByUser}/$userId');
      
      if (response.statusCode == 200) {
        final data = response.data['projects'] as List;
        return data.map((p) => Project.fromJson(p)).toList();
      }
      return [];
    } catch (e) {
      throw Exception('Failed to load projects: $e');
    }
  }

  Future<List<Project>> getProjectsByUsername(String username) async {
    try {
      final response = await _apiService.get('${ApiEndpoints.projectsByUsername}/$username');
      
      if (response.statusCode == 200) {
        final data = response.data['projects'] as List;
        return data.map((p) => Project.fromJson(p)).toList();
      }
      return [];
    } catch (e) {
      throw Exception('Failed to load projects: $e');
    }
  }

  Future<Project> getProjectById(int projectId) async {
    try {
      final response = await _apiService.get('${ApiEndpoints.projects}/$projectId');
      
      if (response.statusCode == 200) {
        return Project.fromJson(response.data);
      }
      throw Exception('Project not found');
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('Project not found');
      }
      throw Exception('Failed to load project: ${e.message}');
    }
  }

  Future<Project> createProject({
    required String title,
    String? description,
    String? techStack,
    String? githubLink,
    String? liveLink,
  }) async {
    try {
      final response = await _apiService.post(
        ApiEndpoints.projects,
        data: {
          'title': title,
          'description': ?description,
          'techStack': ?techStack,
          'githubLink': ?githubLink,
          'liveLink': ?liveLink,
        },
      );
      
      if (response.statusCode == 201) {
        return Project.fromJson(response.data);
      }
      throw Exception('Failed to create project');
    } on DioException catch (e) {
      throw Exception('Failed to create project: ${e.message}');
    }
  }

  Future<Project> updateProject({
    required int projectId,
    String? title,
    String? description,
    String? techStack,
    String? githubLink,
    String? liveLink,
  }) async {
    try {
      final response = await _apiService.put(
        '${ApiEndpoints.projects}/$projectId',
        data: {
          'title': ?title,
          'description': ?description,
          'techStack': ?techStack,
          'githubLink': ?githubLink,
          'liveLink': ?liveLink,
        },
      );
      
      if (response.statusCode == 200) {
        return Project.fromJson(response.data);
      }
      throw Exception('Failed to update project');
    } on DioException catch (e) {
      throw Exception('Failed to update project: ${e.message}');
    }
  }

  Future<void> deleteProject(int projectId) async {
    try {
      await _apiService.delete('${ApiEndpoints.projects}/$projectId');
    } on DioException catch (e) {
      throw Exception('Failed to delete project: ${e.message}');
    }
  }

  Future<List<Project>> searchProjectsByTitle(String query) async {
    try {
      final response = await _apiService.get(
        '${ApiEndpoints.searchProjectsByTitle}?query=$query',
      );
      
      if (response.statusCode == 200) {
        final data = response.data['results'] as List;
        return data.map((p) => Project.fromJson(p)).toList();
      }
      return [];
    } catch (e) {
      throw Exception('Failed to search projects: $e');
    }
  }

  Future<List<Project>> searchProjectsByTech(String tech) async {
    try {
      final response = await _apiService.get(
        '${ApiEndpoints.searchProjectsByTech}?tech=$tech',
      );
      
      if (response.statusCode == 200) {
        final data = response.data['results'] as List;
        return data.map((p) => Project.fromJson(p)).toList();
      }
      return [];
    } catch (e) {
      throw Exception('Failed to search projects: $e');
    }
  }

  Future<List<Project>> getRecentProjects() async {
    try {
      final response = await _apiService.get(ApiEndpoints.recentProjects);
      
      if (response.statusCode == 200) {
        final data = response.data['projects'] as List;
        return data.map((p) => Project.fromJson(p)).toList();
      }
      return [];
    } catch (e) {
      throw Exception('Failed to load recent projects: $e');
    }
  }

  // Admin endpoints
  Future<List<Project>> getAllProjectsAdmin() async {
    try {
      final response = await _apiService.get(ApiEndpoints.adminProjects);
      
      if (response.statusCode == 200) {
        final data = response.data['projects'] as List;
        return data.map((p) => Project.fromJson(p)).toList();
      }
      return [];
    } catch (e) {
      throw Exception('Failed to load projects: $e');
    }
  }

  Future<void> adminDeleteProject(int projectId) async {
    try {
      await _apiService.delete('${ApiEndpoints.adminProjects}/$projectId');
    } on DioException catch (e) {
      throw Exception('Failed to delete project: ${e.message}');
    }
  }
}