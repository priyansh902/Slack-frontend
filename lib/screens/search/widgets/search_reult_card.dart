import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phoenix_slack/data/model/search/search_result.dart';

class SearchResultCard extends StatelessWidget {
  final SearchResult result;
  
  const SearchResultCard({
    super.key,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: () {
          // Navigate to user profile
          context.push('/profile/${result.username}');
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                child: Text(
                  result.name.substring(0, 1).toUpperCase(),
                  style: const TextStyle(fontSize: 24),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      result.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '@${result.username}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    if (result.bio != null && result.bio!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          result.bio!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        if (result.hasProjects)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${result.projectCount} projects',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              if (result.isYou)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'You',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}