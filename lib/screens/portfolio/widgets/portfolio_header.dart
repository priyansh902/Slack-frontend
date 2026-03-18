import 'package:flutter/material.dart';
import '../../../core/utils/helpers.dart';

class PortfolioHeader extends StatelessWidget {
  final String name;
  final String username;
  final String bio;
  final DateTime memberSince;

  const PortfolioHeader({
    super.key,
    required this.name,
    required this.username,
    required this.bio,
    required this.memberSince,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Theme.of(context).primaryColor,
              child: Text(
                name.substring(0, 1).toUpperCase(),
                style: const TextStyle(
                  fontSize: 40,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              name,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '@$username',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              bio,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                'Member since ${Helpers.formatDate(memberSince)}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}