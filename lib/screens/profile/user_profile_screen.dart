import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phoenix_slack/providers/profile_provider.dart';
import 'package:phoenix_slack/providers/project_provider.dart';
import 'package:phoenix_slack/screens/profile/widgets/profile_header.dart';
import 'package:phoenix_slack/screens/projects/widgets/project_card.dart';


class UserProfileScreen extends ConsumerWidget {
  final String username;
  
  const UserProfileScreen({
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
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(profileProvider(username));
          ref.invalidate(userProjectsProvider(username));
        },
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: profileAsync.when(
                data: (profile) {
                  if (profile == null) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: Text('User not found'),
                      ),
                    );
                  }
                  return ProfileHeader(profile: profile);
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
      ),
    );
  }
}