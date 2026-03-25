import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phoenix_slack/providers/auth_provider.dart';
import 'package:phoenix_slack/providers/profile_provider.dart';
import 'package:phoenix_slack/providers/project_provider.dart';
import 'package:phoenix_slack/screens/projects/widgets/project_card.dart';
import 'package:phoenix_slack/widgets/common/loading_widget.dart';

class MyProfileScreen extends ConsumerStatefulWidget {
  const MyProfileScreen({super.key});

  @override
  ConsumerState<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends ConsumerState<MyProfileScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(myProfileNotifierProvider.notifier).loadProfile();
      ref.read(myProjectsNotifierProvider.notifier).loadMyProjects();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final profileAsync = ref.watch(myProfileNotifierProvider);
    final projectsAsync = ref.watch(myProjectsNotifierProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => Navigator.pushNamed(context, '/profile/edit'),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await ref.read(authStateProvider.notifier).logout();
              if (mounted) {
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(myProfileNotifierProvider.notifier).loadProfile();
          await ref.read(myProjectsNotifierProvider.notifier).loadMyProjects();
        },
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: profileAsync.when(
                data: (profile) => _ProfileHeader(profile: profile),
                loading: () => const LoadingWidget(),
                error: (error, _) => Center(child: Text('Error: $error')),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'My Projects',
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
                        child: Column(
                          children: [
                            Icon(Icons.code_off, size: 64),
                            SizedBox(height: 16),
                            Text('No projects yet'),
                            SizedBox(height: 8),
                            Text('Create your first project!'),
                          ],
                        ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/projects/create');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final dynamic profile;
  
  const _ProfileHeader({required this.profile});

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
              profile?.name?.substring(0, 1).toUpperCase() ?? 'U',
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            profile?.name ?? '',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 4),
          Text(
            '@${profile?.username ?? ''}',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          if (profile?.bio != null && profile!.bio.isNotEmpty)
            Text(
              profile!.bio,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          const SizedBox(height: 16),
          if (profile?.skillsList != null && profile!.skillsList.isNotEmpty)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: profile!.skillsList.map<Widget>((skill) {
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
              if (profile?.githubUrl != null)
                IconButton(
                  icon: const Icon(Icons.code),
                  onPressed: () {
                    // TODO: Open GitHub
                  },
                ),
              if (profile?.linkedinUrl != null)
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