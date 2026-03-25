import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phoenix_slack/providers/project_provider.dart';
import 'package:phoenix_slack/screens/projects/widgets/project_card.dart';

class ProjectsScreen extends ConsumerWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projects = ref.watch(myProjectsProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Projects'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(myProjectsProvider);
        },
        child: projects.when(
          data: (projectList) {
            if (projectList.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.code_off, size: 64),
                    SizedBox(height: 16),
                    Text('No projects yet'),
                    SizedBox(height: 8),
                    Text('Create your first project!'),
                  ],
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: projectList.length,
              itemBuilder: (context, index) {
                return ProjectCard(project: projectList[index]);
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(child: Text('Error: $error')),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/projects/create');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}