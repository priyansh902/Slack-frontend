import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phoenix_slack/core/extensions/context_extensions.dart';
import 'package:phoenix_slack/providers/auth_provider.dart';
import 'package:phoenix_slack/providers/profile_provider.dart';
import 'package:phoenix_slack/utills/date_time_utils.dart';
import 'package:phoenix_slack/widgets/common/custom_button.dart';
class AccountSettingsScreen extends ConsumerStatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  ConsumerState<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends ConsumerState<AccountSettingsScreen> {
  // ignore: unused_field
  bool _isDeleting = false;

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final user = authState.user;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Account Information',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Divider(),
                  _InfoRow(label: 'Name', value: user?.name ?? ''),
                  _InfoRow(label: 'Username', value: user?.username ?? ''),
                  _InfoRow(label: 'Email', value: user?.email ?? ''),
                  _InfoRow(label: 'Role', value: user?.role ?? ''),
                  _InfoRow(
                    label: 'Member Since',
                    value: user?.createdAt != null
                        ? DateTimeUtils.formatDate(user!.createdAt)
                        : '',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Danger Zone',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  const Divider(),
                  const Text(
                    'Delete your account and all associated data. This action cannot be undone.',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  CustomButton(
                    text: 'Delete Account',
                    onPressed: _showDeleteConfirmation,
                    isOutlined: true,
                    color: Colors.red,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to delete your account? '
          'All your data including projects, profile, and resume will be permanently deleted.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: _deleteAccount,
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
  
  Future<void> _deleteAccount() async {
    setState(() => _isDeleting = true);
    
    // Delete profile first
    await ref.read(myProfileNotifierProvider.notifier).delete();
    
    // Logout
    await ref.read(authStateProvider.notifier).logout();
    
    setState(() => _isDeleting = false);
    
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/login');
      context.showSnackBar('Account deleted successfully');
    }
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  
  const _InfoRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}