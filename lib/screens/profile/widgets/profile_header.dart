import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:phoenix_slack/utills/date_time_utils.dart';

class ProfileHeader extends StatelessWidget {
  final dynamic profile;
  
  const ProfileHeader({
    super.key,
    required this.profile,
  });

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
              profile.name.substring(0, 1).toUpperCase(),
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            profile.name,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 4),
          Text(
            '@${profile.username}',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          if (profile.memberSince != null) ...[
            const SizedBox(height: 8),
            Text(
              'Member since ${DateTimeUtils.formatDate(profile.memberSince)}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
          const SizedBox(height: 16),
          if (profile.bio != null && profile.bio.isNotEmpty)
            Text(
              profile.bio,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          const SizedBox(height: 16),
          if (profile.skillsList.isNotEmpty)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: profile.skillsList.map<Widget>((skill) {
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
              if (profile.githubUrl != null)
                IconButton(
                  icon: const Icon(Icons.code),
                  onPressed: () => _launchUrl(profile.githubUrl),
                ),
              if (profile.linkedinUrl != null)
                IconButton(
                  icon: const Icon(Icons.business),
                  onPressed: () => _launchUrl(profile.linkedinUrl),
                ),
            ],
          ),
        ],
      ),
    );
  }
  
  void _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}