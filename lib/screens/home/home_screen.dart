import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phoenix_slack/providers/auth_provider.dart';
import 'package:phoenix_slack/providers/project_provider.dart';
import 'package:phoenix_slack/screens/profile/my_profile_screen.dart';
import 'package:phoenix_slack/screens/projects/projects_screen.dart';
import 'package:phoenix_slack/screens/projects/widgets/project_card.dart';
import 'package:phoenix_slack/screens/search/search_screen.dart';
import 'package:phoenix_slack/widgets/common/bottom_nav_bar.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0;
  
  final List<Widget> _screens = [
    const FeedScreen(),
    const SearchScreen(),
    const ProjectsScreen(),
    const MyProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    
    if (!authState.isAuthenticated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/login');
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentProjects = ref.watch(recentProjectsProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('DevConnect'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: Notifications
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(recentProjectsProvider);
        },
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome Back!',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Discover latest projects from developers',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            recentProjects.when(
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
              error: (error, _) => SliverToBoxAdapter(
                child: Center(child: Text('Error: $error')),
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