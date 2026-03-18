import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/profile_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/common/error_widget.dart';
import '../../widgets/navigation/bottom_nav_bar.dart';
import '../../widgets/navigation/app_drawer.dart';
import 'widgets/profile_header.dart';
import 'widgets/skills_section.dart';
import '../../core/utils/helpers.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, this.username});

  final String? username;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _currentIndex = 1;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    
    if (widget.username != null) {
      await profileProvider.loadProfileByUsername(widget.username!);
    } else {
      await profileProvider.loadMyProfile();
    }
  }

  Future<void> _handleDelete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Profile'),
        content: const Text('Are you sure you want to delete your profile? This action cannot be undone.'),
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
      final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
      final success = await profileProvider.deleteProfile();
      
      if (success && mounted) {
        Helpers.showSnackBar(context, 'Profile deleted successfully');
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final profile = profileProvider.profile;
    final isOwnProfile = widget.username == null || 
                         widget.username == authProvider.user?.username;

    return Scaffold(
      appBar: AppBar(
        title: Text(isOwnProfile ? 'My Profile' : '${widget.username}\'s Profile'),
        actions: [
          if (isOwnProfile) ...[
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => Navigator.pushNamed(context, '/profile/edit'),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: _handleDelete,
            ),
          ],
        ],
      ),
      drawer: isOwnProfile ? const AppDrawer() : null,
      body: profileProvider.isLoading
          ? const LoadingIndicator()
          : profileProvider.error != null
              ? CustomErrorWidget(
                  message: profileProvider.error!,
                  onRetry: _loadProfile,
                )
              : profile == null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.person_off, size: 64, color: Colors.grey),
                          const SizedBox(height: 16),
                          const Text(
                            'No profile found',
                            style: TextStyle(fontSize: 18),
                          ),
                          const SizedBox(height: 8),
                          if (isOwnProfile)
                            ElevatedButton(
                              onPressed: () => Navigator.pushNamed(context, '/profile/edit'),
                              child: const Text('Create Profile'),
                            ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _loadProfile,
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ProfileHeader(
                              name: profile.name,
                              username: profile.username,
                              email: isOwnProfile ? profile.email : null,
                              memberSince: profile.createdAt,
                            ),
                            const SizedBox(height: 24),
                            
                            if (profile.bio != null && profile.bio!.isNotEmpty) ...[
                              const Text(
                                'Bio',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(profile.bio!),
                              const SizedBox(height: 24),
                            ],
                            
                            if (profile.skills.isNotEmpty) ...[
                              const Text(
                                'Skills',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              SkillsSection(skills: profile.skills),
                              const SizedBox(height: 24),
                            ],
                            
                            if (profile.githubUrl != null || profile.linkedinUrl != null) ...[
                              const Text(
                                'Social Links',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  if (profile.githubUrl != null)
                                    _buildSocialButton(
                                      'GitHub',
                                      Icons.code,
                                      profile.githubUrl!,
                                    ),
                                  if (profile.linkedinUrl != null)
                                    _buildSocialButton(
                                      'LinkedIn',
                                      Icons.business,
                                      profile.linkedinUrl!,
                                    ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
      bottomNavigationBar: isOwnProfile
          ? BottomNavBar(
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
                if (index == 1) return; // Already on profile
                _handleNavigation(index);
              },
            )
          : null,
    );
  }

  Widget _buildSocialButton(String label, IconData icon, String url) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ElevatedButton.icon(
        onPressed: () {
          // Launch URL
        },
        icon: Icon(icon),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(120, 40),
        ),
      ),
    );
  }

  void _handleNavigation(int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/');
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