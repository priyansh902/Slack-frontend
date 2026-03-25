import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialLinks extends StatelessWidget {
  final String? githubUrl;
  final String? linkedinUrl;
  final bool isEditable;
  final VoidCallback? onEdit;
  
  const SocialLinks({
    super.key,
    this.githubUrl,
    this.linkedinUrl,
    this.isEditable = false,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final hasLinks = githubUrl != null || linkedinUrl != null;
    
    if (!hasLinks && !isEditable) {
      return const SizedBox.shrink();
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Social Links',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            if (isEditable)
              TextButton(
                onPressed: onEdit,
                child: const Text('Edit'),
              ),
          ],
        ),
        const SizedBox(height: 12),
        if (!hasLinks)
          const Text('No social links added')
        else
          Row(
            children: [
              if (githubUrl != null)
                _SocialLink(
                  icon: Icons.code,
                  label: 'GitHub',
                  onTap: () => _launchUrl(githubUrl!),
                ),
              if (linkedinUrl != null)
                _SocialLink(
                  icon: Icons.business,
                  label: 'LinkedIn',
                  onTap: () => _launchUrl(linkedinUrl!),
                ),
            ],
          ),
      ],
    );
  }
  
  void _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}

class _SocialLink extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  
  const _SocialLink({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 4),
            Text(label),
          ],
        ),
      ),
    );
  }
}