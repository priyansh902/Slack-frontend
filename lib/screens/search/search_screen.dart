import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/search_provider.dart';
import '../../providers/profile_provider.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/common/error_widget.dart';
import '../../widgets/navigation/bottom_nav_bar.dart';
import '../../widgets/navigation/app_drawer.dart';
import 'widgets/search_bar.dart';
import 'widgets/user_tile.dart';
import '../../core/utils/validators.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  int _currentIndex = 4;
  final _searchController = TextEditingController();
  String _searchType = 'username'; // username, name, keyword

  @override
  void initState() {
    super.initState();
    _loadRecentUsers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadRecentUsers() async {
    final searchProvider = Provider.of<SearchProvider>(context, listen: false);
    await searchProvider.loadRecentUsers();
  }

  Future<void> _performSearch() async {
    final query = _searchController.text.trim();
    if (query.isEmpty || query.length < 2) return;

    final searchProvider = Provider.of<SearchProvider>(context, listen: false);
    
    switch (_searchType) {
      case 'username':
        await searchProvider.searchByUsername(query);
        break;
      case 'name':
        await searchProvider.searchByName(query);
        break;
      case 'keyword':
        await searchProvider.searchByKeyword(query);
        break;
    }
  }

  void _onSearchChanged(String query) {
    if (query.length >= 2) {
      final searchProvider = Provider.of<SearchProvider>(context, listen: false);
      searchProvider.getSuggestions(query);
    }
  }

  void _selectSuggestion(Map<String, dynamic> suggestion) {
    setState(() {
      _searchController.text = suggestion['username'];
      _performSearch();
    });
  }

  @override
  Widget build(BuildContext context) {
    final searchProvider = Provider.of<SearchProvider>(context);
    final profileProvider = Provider.of<ProfileProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Developers'),
      ),
      drawer: const AppDrawer(),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                SearchBarWidget(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                  onSubmitted: (_) => _performSearch(),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildSearchTypeChip('Username', 'username'),
                    _buildSearchTypeChip('Name', 'name'),
                    _buildSearchTypeChip('Keyword', 'keyword'),
                  ],
                ),
              ],
            ),
          ),

          // Suggestions
          if (searchProvider.suggestions.isNotEmpty && _searchController.text.isNotEmpty)
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                border: Border(
                  bottom: BorderSide(color: Colors.grey.shade300),
                ),
              ),
              child: ListView.builder(
                itemCount: searchProvider.suggestions.length,
                itemBuilder: (ctx, index) {
                  final suggestion = searchProvider.suggestions[index];
                  return ListTile(
                    leading: CircleAvatar(
                      radius: 16,
                      child: Text(
                        suggestion['username'][0].toUpperCase(),
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                    title: Text(suggestion['username']),
                    subtitle: Text(suggestion['name']),
                    trailing: suggestion['hasProfile']
                        ? const Icon(Icons.check_circle, color: Colors.green, size: 16)
                        : null,
                    onTap: () => _selectSuggestion(suggestion),
                  );
                },
              ),
            ),

          // Results
          Expanded(
            child: searchProvider.isLoading
                ? const LoadingIndicator()
                : searchProvider.error != null
                    ? CustomErrorWidget(
                        message: searchProvider.error!,
                        onRetry: _performSearch,
                      )
                    : searchProvider.results.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.search_off,
                                  size: 64,
                                  color: Colors.grey.shade400,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  _searchController.text.isEmpty
                                      ? 'Search for developers'
                                      : 'No results found',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: searchProvider.results.length,
                            itemBuilder: (ctx, index) {
                              final result = searchProvider.results[index];
                              return UserTile(
                                result: result,
                                onTap: () {
                                  profileProvider.clearProfile();
                                  Navigator.pushNamed(
                                    context,
                                    '/profile',
                                    arguments: result.username,
                                  );
                                },
                              );
                            },
                          ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          if (index == 4) return;
          _handleNavigation(index);
        },
      ),
    );
  }

  Widget _buildSearchTypeChip(String label, String value) {
    return FilterChip(
      label: Text(label),
      selected: _searchType == value,
      onSelected: (selected) {
        setState(() {
          _searchType = value;
        });
      },
    );
  }

  void _handleNavigation(int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/profile');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/projects');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/resume');
        break;
    }
  }
}