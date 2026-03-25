import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phoenix_slack/core/constants/app_constants.dart';
import 'package:phoenix_slack/core/utills/helpers.dart';
import 'package:phoenix_slack/providers/auth_provider.dart';
import 'package:phoenix_slack/screens/settings/account_settings.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ignore: unused_local_variable
    final authState = ref.watch(authStateProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 16),
          _SettingsSection(
            title: 'Account',
            children: [
              _SettingsTile(
                icon: Icons.person_outline,
                title: 'Account Settings',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AccountSettingsScreen()),
                  );
                },
              ),
              _SettingsTile(
                icon: Icons.lock_outline,
                title: 'Privacy & Security',
                onTap: () {},
              ),
            ],
          ),
          _SettingsSection(
            title: 'Preferences',
            children: [
              _SettingsTile(
                icon: Icons.dark_mode_outlined,
                title: 'Dark Mode',
                trailing: Switch(
                  value: false,
                  onChanged: (_) {},
                ),
              ),
              _SettingsTile(
                icon: Icons.notifications_outlined,
                title: 'Notifications',
                trailing: Switch(
                  value: true,
                  onChanged: (_) {},
                ),
              ),
            ],
          ),
          _SettingsSection(
            title: 'Support',
            children: [
              _SettingsTile(
                icon: Icons.help_outline,
                title: 'Help Center',
                onTap: () {},
              ),
              _SettingsTile(
                icon: Icons.feedback_outlined,
                title: 'Send Feedback',
                onTap: () {},
              ),
              _SettingsTile(
                icon: Icons.info_outline,
                title: 'About',
                onTap: () {},
              ),
            ],
          ),
          const Divider(),
          _SettingsTile(
            icon: Icons.logout,
            title: 'Logout',
            textColor: Colors.red,
            onTap: () async {
              final confirm = await Helpers.showConfirmDialog(
                context,
                title: 'Logout',
                message: 'Are you sure you want to logout?',
              );
              if (confirm) {
                await ref.read(authStateProvider.notifier).logout();
                if (context.mounted) {
                  Navigator.pushReplacementNamed(context, '/login');
                }
              }
            },
          ),
          const SizedBox(height: 32),
          Center(
            child: Text(
              'Version ${AppConstants.appVersion}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;
  
  const _SettingsSection({
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        ...children,
        const SizedBox(height: 16),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? textColor;
  
  const _SettingsTile({
    required this.icon,
    required this.title,
    this.trailing,
    this.onTap,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(
        title,
        style: TextStyle(color: textColor),
      ),
      trailing: trailing ?? (onTap != null ? const Icon(Icons.chevron_right) : null),
      onTap: onTap,
    );
  }
}