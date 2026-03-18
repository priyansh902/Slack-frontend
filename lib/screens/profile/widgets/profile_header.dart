import 'package:flutter/material.dart';
import '../../../core/utils/helpers.dart';

class ProfileHeader extends StatelessWidget {
  final String name;
  final String username;
  final String? email;
  final DateTime memberSince;

  const ProfileHeader({
    super.key,
    required this.name,
    required this.username,
    this.email,
    required this.memberSince,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Theme.of(context).primaryColor,
          child: Text(
            name.substring(0, 1).toUpperCase(),
            style: const TextStyle(
              fontSize: 32,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '@$username',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              if (email != null) ...[
                const SizedBox(height: 4),
                Text(
                  email!,
                  style: const TextStyle(fontSize: 14),
                ),
              ],
              const SizedBox(height: 4),
              Text(
                'Member since ${Helpers.formatDate(memberSince)}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}