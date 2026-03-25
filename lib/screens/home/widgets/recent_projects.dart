import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phoenix_slack/providers/project_provider.dart';
import 'package:phoenix_slack/screens/projects/widgets/project_card.dart';

class RecentProjectsWidget extends ConsumerWidget {
  const RecentProjectsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentProjects = ref.watch(recentProjectsProvider);
    
    return recentProjects.when(
      data: (projects) {
        if (projects.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Text('No recent projects'),
            ),
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Recent Projects',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: projects.length,
              itemBuilder: (context, index) {
                return ProjectCard(project: projects[index]);
              },
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Error: $error')),
    );
  }
}