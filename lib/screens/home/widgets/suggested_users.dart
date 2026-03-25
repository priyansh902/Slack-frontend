import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phoenix_slack/providers/search_provider.dart';
import 'package:phoenix_slack/screens/search/widgets/user_search_card.dart';

class SuggestedUsersWidget extends ConsumerWidget {
  const SuggestedUsersWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentUsers = ref.watch(recentUsersProvider);
    
    return recentUsers.when(
      data: (users) {
        if (users.isEmpty) {
          return const SizedBox.shrink();
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Suggested Users',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: users.length,
              itemBuilder: (context, index) {
                return UserSearchCard(result: users[index]);
              },
            ),
          ],
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (error, _) => const SizedBox.shrink(),
    );
  }
}