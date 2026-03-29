import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phoenix_slack/data/model/project/project.dart';
import 'package:phoenix_slack/providers/auth_provider.dart';

List<Project> _parseProjects(Map<String, dynamic> r) =>
    ((r['projects'] ?? r['results'] ?? []) as List)
        .map((j) => Project.fromJson(j as Map<String, dynamic>))
        .toList();

final recentProjectsProvider = FutureProvider<List<Project>>((ref) async {
  final r = await ref.read(apiServiceProvider).getRecentProjects();
  return _parseProjects(r);
});

final myProjectsProvider = FutureProvider<List<Project>>((ref) async {
  final r = await ref.read(apiServiceProvider).getMyProjects();
  return _parseProjects(r);
});

final userProjectsProvider = FutureProvider.family<List<Project>, String>((ref, username) async {
  final r = await ref.read(apiServiceProvider).getProjectsByUsername(username);
  return _parseProjects(r);
});

final projectDetailsProvider = FutureProvider.family<Project?, int>((ref, id) async {
  try { return await ref.read(apiServiceProvider).getProjectById(id); }
  catch (_) { return null; }
});

class ProjectNotifier extends StateNotifier<AsyncValue<List<Project>>> {
  final Ref _ref;
  ProjectNotifier(this._ref) : super(const AsyncValue.loading());

  Future<void> loadMyProjects() async {
    state = const AsyncValue.loading();
    try {
      final r = await _ref.read(apiServiceProvider).getMyProjects();
      state = AsyncValue.data(_parseProjects(r));
    } catch (e, st) {
      if (e is DioException && e.response?.statusCode == 404) {
        state = const AsyncValue.data([]);
      } else {
        state = AsyncValue.error(e, st);
      }
    }
  }

  Future<bool> create(ProjectRequest request) async {
    try {
      await _ref.read(apiServiceProvider).createProject(request);
      await loadMyProjects();
      return true;
    } catch (_) { return false; }
  }

  Future<bool> update(int id, ProjectRequest request) async {
    try {
      await _ref.read(apiServiceProvider).updateProject(id, request);
      await loadMyProjects();
      return true;
    } catch (_) { return false; }
  }

  Future<bool> delete(int id) async {
    try {
      await _ref.read(apiServiceProvider).deleteProject(id);
      await loadMyProjects();
      return true;
    } catch (_) { return false; }
  }
}

final myProjectsNotifierProvider =
    StateNotifierProvider<ProjectNotifier, AsyncValue<List<Project>>>((ref) => ProjectNotifier(ref));
