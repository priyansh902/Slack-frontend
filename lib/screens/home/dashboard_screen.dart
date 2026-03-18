import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/profile_provider.dart';
import '../../providers/project_provider.dart';
import '../../providers/resume_provider.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/navigation/bottom_nav_bar.dart';
import '../../widgets/navigation/app_drawer.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    final projectProvider = Provider.of<ProjectProvider>(context, listen: false);
    final resumeProvider = Provider.of<ResumeProvider>(context, listen: false);

    await Future.wait([
      profileProvider.loadMyProfile(),
      projectProvider.loadMyProjects(),
      resumeProvider.loadMyResume(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final profileProvider = Provider.of<ProfileProvider>(context);
    final projectProvider = Provider.of<ProjectProvider>(context);
    final resumeProvider = Provider.of<ResumeProvider>(context);

    final user = authProvider.user;
    final hasProfile = profileProvider.hasProfile;
    final projectCount = projectProvider.myProjects.length;
    final hasResume = resumeProvider.hasResume;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadDashboardData,
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: profileProvider.isLoading || projectProvider.isLoading
          ? const LoadingIndicator()
          : RefreshIndicator(
              onRefresh: _loadDashboardData,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Welcome Card
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome back, ${user?.name ?? 'Developer'}!',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '@${user?.username ?? ''}',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Stats Grid
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      children: [
                        _buildStatCard(
                          'Profile',
                          hasProfile ? 'Completed' : 'Incomplete',
                          hasProfile ? Icons.check_circle : Icons.error,
                          hasProfile ? Colors.green : Colors.orange,
                          onTap: () => Navigator.pushNamed(context, '/profile'),
                        ),
                        _buildStatCard(
                          'Projects',
                          '$projectCount Project${projectCount != 1 ? 's' : ''}',
                          Icons.code,
                          Colors.blue,
                          onTap: () => Navigator.pushNamed(context, '/projects'),
                        ),
                        _buildStatCard(
                          'Resume',
                          hasResume ? 'Uploaded' : 'Not Uploaded',
                          Icons.description,
                          hasResume ? Colors.green : Colors.grey,
                          onTap: () => Navigator.pushNamed(context, '/resume'),
                        ),
                        _buildStatCard(
                          'Portfolio',
                          'View Public',
                          Icons.share,
                          Colors.purple,
                          onTap: () {
                            final username = user?.username ?? '';
                            Navigator.pushNamed(
                              context,
                              '/portfolio/$username',
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Quick Actions
                    const Text(
                      'Quick Actions',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildActionButton(
                            'Edit Profile',
                            Icons.edit,
                            () => Navigator.pushNamed(context, '/profile/edit'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildActionButton(
                            'Add Project',
                            Icons.add,
                            () => Navigator.pushNamed(context, '/projects/add'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _buildActionButton(
                            'Upload Resume',
                            Icons.upload_file,
                            () => Navigator.pushNamed(context, '/resume'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildActionButton(
                            'Search Users',
                            Icons.search,
                            () => Navigator.pushNamed(context, '/search'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Recent Projects
                    if (projectProvider.myProjects.isNotEmpty) ...[
                      const Text(
                        'Recent Projects',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...projectProvider.myProjects.take(3).map(
                        (project) => Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            leading: const Icon(Icons.folder),
                            title: Text(project.title),
                            subtitle: Text(project.techStack),
                            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/projects/edit/${project.id}',
                              );
                            },
                          ),
                        ),
                      ),
                      if (projectProvider.myProjects.length > 3)
                        TextButton(
                          onPressed: () => Navigator.pushNamed(context, '/projects'),
                          child: const Text('View All Projects'),
                        ),
                    ],

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          _handleNavigation(index);
        },
      ),
    )
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color, {
    VoidCallback? onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32, color: color),
              const SizedBox(height: 8),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(String label, IconData icon, VoidCallback onTap) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 48),
      ),
    );
  }

  void _handleNavigation(int index) {
    switch (index) {
      case 0:
        // Already on home
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/profile');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/projects');
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