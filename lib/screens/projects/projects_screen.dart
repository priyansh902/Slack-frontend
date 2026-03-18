import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/project_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/common/error_widget.dart';
import '../../widgets/navigation/bottom_nav_bar.dart';
import '../../widgets/navigation/app_drawer.dart';
import 'widgets/project_card.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key, this.username});

  final String? username;

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  int _currentIndex = 2;

  @override
  void initState() {
    super.initState();
    _loadProjects();
  }

  Future<void> _loadProjects() async {
    final projectProvider = Provider.of<ProjectProvider>(context, listen: false);
    
    if (widget.username != null) {
      await projectProvider.loadProjectsByUsername(widget.username!);
    } else {
      await projectProvider.loadMyProjects();
    }
  }

  @override
  Widget build(BuildContext context) {
    final projectProvider = Provider.of<ProjectProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final projects = widget.username != null 
        ? projectProvider.currentProjects 
        : projectProvider.myProjects;
    final isOwnProjects = widget.username == null || 
                         widget.username == authProvider.user?.username;

    return Scaffold(
      appBar: AppBar(
        title: Text(isOwnProjects ? 'My Projects' : '${widget.username}\'s Projects'),
        actions: [
          if (isOwnProjects)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => Navigator.pushNamed(context, '/projects/add'),
            ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _showSearchDialog(),
          ),
        ],
      ),
      drawer: isOwnProjects ? const AppDrawer() : null,
      body: projectProvider.isLoading
          ? const LoadingIndicator()
          : projectProvider.error != null
              ? CustomErrorWidget(
                  message: projectProvider.error!,
                  onRetry: _loadProjects,
                )
              : projects.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.folder_open, size: 64, color: Colors.grey),
                          const SizedBox(height: 16),
                          const Text(
                            'No projects found',
                            style: TextStyle(fontSize: 18),
                          ),
                          const SizedBox(height: 8),
                          if (isOwnProjects)
                            ElevatedButton(
                              onPressed: () => Navigator.pushNamed(context, '/projects/add'),
                              child: const Text('Add Your First Project'),
                            ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _loadProjects,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: projects.length,
                        itemBuilder: (ctx, index) {
                          final project = projects[index];
                          return ProjectCard(
                            project: project,
                            isOwnProject: isOwnProjects,
                            onTap: () {
                              if (isOwnProjects) {
                                Navigator.pushNamed(
                                  context,
                                  '/projects/edit/${project.id}',
                                );
                              } else {
                                _showProjectDetails(project);
                              }
                            },
                          );
                        },
                      ),
                    ),
      bottomNavigationBar: isOwnProjects
          ? BottomNavBar(
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
                if (index == 2) return;
                _handleNavigation(index);
              },
            )
          : null,
    );
  }

  void _showSearchDialog() {
    final searchController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Search Projects'),
        content: TextField(
          controller: searchController,
          decoration: const InputDecoration(
            hintText: 'Search by title or tech stack...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final query = searchController.text.trim();
              if (query.isNotEmpty) {
                final projectProvider = Provider.of<ProjectProvider>(
                  context,
                  listen: false,
                );
                await projectProvider.searchProjectsByTitle(query);
              }
            },
            child: const Text('Search'),
          ),
        ],
      ),
    );
  }

  void _showProjectDetails(project) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(project.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(project.description),
            const SizedBox(height: 8),
            Text('Tech: ${project.techStack}'),
          ],
        ),
        actions: [
          if (project.githubLink != null)
            TextButton(
              onPressed: () {
                // Launch GitHub URL
              },
              child: const Text('GitHub'),
            ),
          if (project.liveLink != null)
            TextButton(
              onPressed: () {
                // Launch Live URL
              },
              child: const Text('Live Demo'),
            ),
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _handleNavigation(int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/profile');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/resume');
        break;
      case 4:
        Navigator.pushReplacementNamed(context, '/search');
        break;
    }
  }
}