import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phoenix_slack/providers/profile_provider.dart';
import 'package:phoenix_slack/providers/project_provider.dart';
import 'package:phoenix_slack/screens/projects/widgets/project_card.dart';

class PortfolioScreen extends ConsumerWidget {
  final String username;
  
  const PortfolioScreen({
    super.key,
    required this.username,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileProvider(username));
    final projectsAsync = ref.watch(userProjectsProvider(username));
    
    return Scaffold(
      appBar: AppBar(
        title: Text('@$username'),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: profileAsync.when(
              data: (profile) {
                if (profile == null) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: Text('Profile not found'),
                    ),
                  );
                }
                return _PortfolioHeader(profile: profile);
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(child: Text('Error: $error')),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Projects',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ),
          projectsAsync.when(
            data: (projects) {
              if (projects.isEmpty) {
                return const SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: Text('No projects yet'),
                    ),
                  ),
                );
              }
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => ProjectCard(project: projects[index]),
                  childCount: projects.length,
                ),
              );
            },
            loading: () => const SliverToBoxAdapter(
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, _) => const SliverToBoxAdapter(
              child: Center(child: Text('Error loading projects')),
            ),
          ),
        ],
      ),
    );
  }
}

class _PortfolioHeader extends StatelessWidget {
  final dynamic profile;
  
  const _PortfolioHeader({required this.profile});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          CircleAvatar(
            radius: 60,
            backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
            child: Text(
              profile.name.substring(0, 1).toUpperCase(),
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            profile.name,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 4),
          Text(
            '@${profile.username}',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          if (profile.bio.isNotEmpty)
            Text(
              profile.bio,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          const SizedBox(height: 16),
          if (profile.skillsList.isNotEmpty)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: profile.skillsList.map<Widget>((skill) {
                return Chip(
                  label: Text(skill),
                  backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                );
              }).toList(),
            ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (profile.githubUrl != null)
                IconButton(
                  icon: const Icon(Icons.code),
                  onPressed: () {
                    // TODO: Open GitHub
                  },
                ),
              if (profile.linkedinUrl != null)
                IconButton(
                  icon: const Icon(Icons.business),
                  onPressed: () {
                    // TODO: Open LinkedIn
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }
}