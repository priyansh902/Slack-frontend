import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phoenix_slack/core/extensions/context_extensions.dart';
import 'package:phoenix_slack/providers/project_provider.dart';
import 'package:phoenix_slack/providers/user_provider.dart';
import 'package:phoenix_slack/utills/date_time_utils.dart';
import 'package:phoenix_slack/widgets/common/loading_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class ProjectDetailScreen extends ConsumerWidget {
  final int projectId;
  
  const ProjectDetailScreen({
    super.key,
    required this.projectId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectAsync = ref.watch(projectDetailsProvider(projectId));
    final currentUser = ref.watch(currentUserProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Project Details'),
        actions: [
          projectAsync.when(
            data: (project) {
              if (project != null && project.userId == currentUser?.id) {
                return PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') {
                      Navigator.pushNamed(
                        context,
                        '/projects/edit',
                        arguments: project,
                      );
                    } else if (value == 'delete') {
                      _showDeleteConfirmation(context, ref, project.id);
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit),
                          SizedBox(width: 8),
                          Text('Edit'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Delete', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
            loading: () => const SizedBox.shrink(),
            error: (error, _) => const SizedBox.shrink(),
          ),
        ],
      ),
      body: projectAsync.when(
        data: (project) {
          if (project == null) {
            return const Center(child: Text('Project not found'));
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  project.title,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'by @${project.username}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'Created: ${DateTimeUtils.formatDate(project.createdAt)}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 24),
                if (project.description.isNotEmpty) ...[
                  Text(
                    'Description',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    project.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                ],
                if (project.techStackList.isNotEmpty) ...[
                  Text(
                    'Tech Stack',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: project.techStackList.map((tech) {
                      return Chip(label: Text(tech));
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                ],
                Text(
                  'Links',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                if (project.githubLink != null)
                  _LinkButton(
                    icon: Icons.code,
                    label: 'GitHub Repository',
                    url: project.githubLink!,
                  ),
                if (project.liveLink != null)
                  _LinkButton(
                    icon: Icons.open_in_browser,
                    label: 'Live Demo',
                    url: project.liveLink!,
                  ),
              ],
            ),
          );
        },
        loading: () => const Center(child: LoadingWidget()),
        error: (error, _) => Center(child: Text('Error: $error')),
      ),
    );
  }
  
  void _showDeleteConfirmation(BuildContext context, WidgetRef ref, int projectId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Project'),
        content: const Text('Are you sure you want to delete this project?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final success = await ref.read(myProjectsNotifierProvider.notifier)
                  .delete(projectId);
              if (success && context.mounted) {
                Navigator.pop(context);
                context.showSnackBar('Project deleted successfully');
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class _LinkButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String url;
  
  const _LinkButton({
    required this.icon,
    required this.label,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () async {
          final uri = Uri.parse(url);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri);
          }
        },
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(icon),
              const SizedBox(width: 12),
              Expanded(child: Text(label)),
              const Icon(Icons.arrow_forward, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}