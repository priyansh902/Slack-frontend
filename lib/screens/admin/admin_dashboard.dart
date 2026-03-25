import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phoenix_slack/providers/auth_provider.dart';

class AdminDashboard extends ConsumerWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final user = authState.user;
    
    if (!user!.isAdmin) {
      return const Scaffold(
        body: Center(child: Text('Access Denied')),
      );
    }
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _AdminCard(
            title: 'Manage Users',
            icon: Icons.people,
            count: 'View all users',
            onTap: () {
              // Navigate to manage users
            },
          ),
          const SizedBox(height: 16),
          _AdminCard(
            title: 'Manage Projects',
            icon: Icons.code,
            count: 'View all projects',
            onTap: () {
              // Navigate to manage projects
            },
          ),
          const SizedBox(height: 16),
          _AdminCard(
            title: 'Manage Profiles',
            icon: Icons.person,
            count: 'View all profiles',
            onTap: () {
              // Navigate to manage profiles
            },
          ),
          const SizedBox(height: 16),
          _AdminCard(
            title: 'Manage Resumes',
            icon: Icons.description,
            count: 'View all resumes',
            onTap: () {
              // Navigate to manage resumes
            },
          ),
          const SizedBox(height: 16),
          _AdminCard(
            title: 'System Stats',
            icon: Icons.analytics,
            count: 'View statistics',
            onTap: () {
              // Navigate to stats
            },
          ),
        ],
      ),
    );
  }
}

class _AdminCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final String count;
  final VoidCallback onTap;
  
  const _AdminCard({
    required this.title,
    required this.icon,
    required this.count,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: Theme.of(context).primaryColor),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      count,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}