import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phoenix_slack/providers/search_provider.dart';
import 'package:phoenix_slack/screens/search/widgets/search_reult_card.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _searchController = TextEditingController();
  String _searchType = 'keyword'; // keyword, username, name

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch() {
    final query = _searchController.text.trim();
    if (query.length < 2) return;
    
    final searchNotifier = ref.read(searchNotifierProvider.notifier);
    
    switch (_searchType) {
      case 'username':
        searchNotifier.searchByUsername(query);
        break;
      case 'name':
        searchNotifier.searchByName(query);
        break;
      default:
        searchNotifier.searchByKeyword(query);
    }
  }

  @override
  Widget build(BuildContext context) {
    final searchResults = ref.watch(searchNotifierProvider);
    final isSearching = ref.watch(isSearchingProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search developers...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        ref.read(searchNotifierProvider.notifier).clear();
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onSubmitted: (_) => _performSearch(),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _SearchTypeChip(
                      label: 'Keyword',
                      isSelected: _searchType == 'keyword',
                      onTap: () {
                        setState(() => _searchType = 'keyword');
                        _performSearch();
                      },
                    ),
                    const SizedBox(width: 8),
                    _SearchTypeChip(
                      label: 'Username',
                      isSelected: _searchType == 'username',
                      onTap: () {
                        setState(() => _searchType = 'username');
                        _performSearch();
                      },
                    ),
                    const SizedBox(width: 8),
                    _SearchTypeChip(
                      label: 'Name',
                      isSelected: _searchType == 'name',
                      onTap: () {
                        setState(() => _searchType = 'name');
                        _performSearch();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: searchResults.when(
        data: (results) {
          if (results.isEmpty && _searchController.text.isNotEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off, size: 64),
                  SizedBox(height: 16),
                  Text('No users found'),
                ],
              ),
            );
          }
          return ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              return SearchResultCard(result: results[index]);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
      ),
    );
  }
}

class _SearchTypeChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  
  const _SearchTypeChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(),
    );
  }
}