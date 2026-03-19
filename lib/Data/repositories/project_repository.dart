import 'package:dio/dio.dart';
import '../models/project.dart';
import '../services/api_service.dart';
import '../../core/constants/api_endpoints.dart';

class ProjectRepository {
  final ApiService _apiService = ApiService();

  // ========== USER METHODS ==========

  Future<List<Project>> getMyProjects() async {
    try {
      final response = await _apiService.get(ApiEndpoints.myProjects);
      
      if (response.statusCode == 200) {
        final data = response.data['projects'] as List;
        return data.map((p) => Project.fromJson(p)).toList();
      }
      return [];
    } on DioException catch (e) {
      throw Exception('Failed to load projects: ${e.message}');
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
    } on DioException catch (e) {
      throw Exception('Failed to load projects: ${e.message}');
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
    } on DioException catch (e) {
      throw Exception('Failed to load projects: ${e.message}');
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
          if (description != null) 'description': description,
          if (techStack != null) 'techStack': techStack,
          if (githubLink != null) 'githubLink': githubLink,
          if (liveLink != null) 'liveLink': liveLink,
        },
      );
      
      if (response.statusCode == 201 || response.statusCode == 200) {
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
          if (title != null) 'title': title,
          if (description != null) 'description': description,
          if (techStack != null) 'techStack': techStack,
          if (githubLink != null) 'githubLink': githubLink,
          if (liveLink != null) 'liveLink': liveLink,
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
    } on DioException catch (e) {
      throw Exception('Failed to search projects: ${e.message}');
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
    } on DioException catch (e) {
      throw Exception('Failed to search projects: ${e.message}');
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
    } on DioException catch (e) {
      throw Exception('Failed to load recent projects: ${e.message}');
    } catch (e) {
      throw Exception('Failed to load recent projects: $e');
    }
  }

  // ========== ADMIN METHODS ==========

  Future<List<Project>> getAllProjectsAdmin() async {
    try {
      final response = await _apiService.get(ApiEndpoints.adminProjects);
      
      if (response.statusCode == 200) {
        // Handle both possible response formats
        if (response.data is Map && response.data.containsKey('projects')) {
          final data = response.data['projects'] as List;
          return data.map((p) => Project.fromJson(p)).toList();
        } else if (response.data is List) {
          return (response.data as List).map((p) => Project.fromJson(p)).toList();
        }
      }
      return [];
    } on DioException catch (e) {
      throw Exception('Failed to load all projects: ${e.message}');
    } catch (e) {
      throw Exception('Failed to load all projects: $e');
    }
  }

  Future<void> adminDeleteProject(int projectId) async {
    try {
      await _apiService.delete('${ApiEndpoints.adminProjects}/$projectId');
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('Project not found');
      }
      throw Exception('Failed to delete project: ${e.message}');
    }
  }

  Future<Map<String, dynamic>> getProjectStats() async {
    try {
      final response = await _apiService.get('${ApiEndpoints.adminProjects}/stats');
      
      if (response.statusCode == 200) {
        return response.data;
      }
      return {};
    } on DioException catch (e) {
      throw Exception('Failed to get project stats: ${e.message}');
    }
  }
}