import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/admin_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/common/error_widget.dart';
import '../../widgets/navigation/app_drawer.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadAdminData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadAdminData() async {
    final adminProvider = Provider.of<AdminProvider>(context, listen: false);
    await adminProvider.loadAllData();
  }

  void _filterResults(String query) {
    // Filtering is handled in the UI
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    // Check if user is admin
    if (user == null || !user.isAdmin) {
      return Scaffold(
        appBar: AppBar(title: const Text('Access Denied')),
        body: const Center(
          child: Text('You do not have permission to access this page.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Profiles', icon: Icon(Icons.person)),
            Tab(text: 'Projects', icon: Icon(Icons.code)),
            Tab(text: 'Resumes', icon: Icon(Icons.description)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadAdminData,
          ),
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: _showStats,
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: Consumer<AdminProvider>(
        builder: (context, adminProvider, child) {
          if (adminProvider.isLoading) {
            return const LoadingIndicator();
          }

          if (adminProvider.error != null) {
            return CustomErrorWidget(
              message: adminProvider.error!,
              onRetry: _loadAdminData,
            );
          }

          return Column(
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: _searchController,
                  onChanged: _filterResults,
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
              
              // Tab Content
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildProfilesTab(adminProvider),
                    _buildProjectsTab(adminProvider),
                    _buildResumesTab(adminProvider),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProfilesTab(AdminProvider provider) {
    final filtered = provider.searchProfiles(_searchController.text);
    
    if (filtered.isEmpty) {
      return const Center(child: Text('No profiles found'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filtered.length,
      itemBuilder: (ctx, index) {
        final profile = filtered[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              child: Text(profile.name[0].toUpperCase()),
            ),
            title: Text(profile.name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('@${profile.username}'),
                if (profile.email != null) Text(profile.email!),
                Text('Skills: ${profile.skills.join(', ')}'),
              ],
            ),
            isThreeLine: true,
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _showDeleteDialog(
                context,
                'Delete Profile',
                'Delete profile for @${profile.username}?',
                () => provider.deleteProfile(profile.id),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProjectsTab(AdminProvider provider) {
    final filtered = provider.searchProjects(_searchController.text);
    
    if (filtered.isEmpty) {
      return const Center(child: Text('No projects found'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filtered.length,
      itemBuilder: (ctx, index) {
        final project = filtered[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: const Icon(Icons.folder),
            title: Text(project.title),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('by @${project.username}'),
                Text('Tech: ${project.techStack}'),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _showDeleteDialog(
                context,
                'Delete Project',
                'Delete project "${project.title}" by @${project.username}?',
                () => provider.deleteProject(project.id),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildResumesTab(AdminProvider provider) {
    final filtered = provider.searchResumes(_searchController.text);
    
    if (filtered.isEmpty) {
      return const Center(child: Text('No resumes found'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filtered.length,
      itemBuilder: (ctx, index) {
        final resume = filtered[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
            title: Text(resume.fileName),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('by @${resume.username}'),
                Text('Size: ${resume.formattedFileSize}'),
                Text('Uploaded: ${resume.uploadedAt.toString().split(' ')[0]}'),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _showDeleteDialog(
                context,
                'Delete Resume',
                'Delete resume for @${resume.username}?',
                () => provider.deleteResume(resume.id),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _showDeleteDialog(
    BuildContext context,
    String title,
    String content,
    Future<bool> Function() onDelete,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final success = await onDelete();
      if (success && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Deleted successfully')),
        );
      }
    }
  }

  void _showStats() {
    final provider = Provider.of<AdminProvider>(context, listen: false);
    
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Statistics'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Total Profiles: ${provider.allProfiles.length}'),
            Text('Total Projects: ${provider.allProjects.length}'),
            Text('Total Resumes: ${provider.allResumes.length}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}