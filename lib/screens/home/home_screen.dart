import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phoenix_slack/core/themes/app_theme.dart';
import 'package:phoenix_slack/providers/auth_provider.dart';
import 'package:phoenix_slack/providers/project_provider.dart';
import 'package:phoenix_slack/screens/profile/my_profile_screen.dart';
import 'package:phoenix_slack/screens/projects/projects_screen.dart';
import 'package:phoenix_slack/screens/projects/widgets/project_card.dart';
import 'package:phoenix_slack/screens/search/search_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});
  @override ConsumerState<HomeScreen> createState() => _HS();
}
class _HS extends ConsumerState<HomeScreen> {
  int _idx = 0;
  late final List<Widget> _tabs;
  @override
  void initState() {
    super.initState();
    _tabs = const [_FeedTab(), SearchScreen(), ProjectsScreen(), MyProfileScreen()];
  }
  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authStateProvider);
    if (!auth.isAuthenticated) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => Navigator.pushReplacementNamed(context, '/login'));
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: IndexedStack(index: _idx, children: _tabs),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.surface : Colors.white,
          border: Border(top: BorderSide(
            color: isDark ? AppColors.border : AppColors.lBorder)),
        ),
        child: NavigationBar(
          selectedIndex: _idx,
          onDestinationSelected: (i) => setState(() => _idx = i),
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home_rounded), label: 'Home'),
            NavigationDestination(icon: Icon(Icons.search_outlined),
              selectedIcon: Icon(Icons.search_rounded), label: 'Search'),
            NavigationDestination(icon: Icon(Icons.code_outlined),
              selectedIcon: Icon(Icons.code_rounded), label: 'Projects'),
            NavigationDestination(icon: Icon(Icons.person_outline_rounded),
              selectedIcon: Icon(Icons.person_rounded), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}

class _FeedTab extends ConsumerWidget {
  const _FeedTab();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authStateProvider);
    final recentAsync = ref.watch(recentProjectsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final first = auth.user?.name.split(' ').first ?? 'Dev';

    return Scaffold(
      body: RefreshIndicator(
        color: AppColors.accent,
        onRefresh: () async => ref.invalidate(recentProjectsProvider),
        child: CustomScrollView(slivers: [
          SliverToBoxAdapter(child: Container(
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Hey, $first 👋',
                    style: GoogleFonts.spaceGrotesk(fontSize: 26, fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.textPri : AppColors.lTextPri)),
                  const SizedBox(height: 4),
                  Text('Explore what devs are building',
                    style: Theme.of(context).textTheme.bodyMedium),
                ])),
                _IconBtn(icon: Icons.settings_outlined,
                  onTap: () => Navigator.pushNamed(context, '/settings')),
              ]),
              const SizedBox(height: 18),
              _HeroBanner(isDark: isDark),
            ]),
          ).animate().fadeIn(duration: 400.ms)),
          SliverToBoxAdapter(child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 10),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Recent Projects',
                style: GoogleFonts.spaceGrotesk(fontSize: 16, fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.textPri : AppColors.lTextPri)),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/projects'),
                style: TextButton.styleFrom(foregroundColor: AppColors.accent,
                  padding: EdgeInsets.zero, minimumSize: Size.zero),
                child: Text('See all', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500)),
              ),
            ]),
          )),
          recentAsync.when(
            data: (projects) {
              if (projects.isEmpty) return SliverToBoxAdapter(child: _EmptyFeed(isDark: isDark));
              return SliverList(delegate: SliverChildBuilderDelegate(
                (ctx, i) => ProjectCard(project: projects[i])
                  .animate().fadeIn(delay: (i * 60).ms, duration: 350.ms),
                childCount: projects.length,
              ));
            },
            loading: () => const SliverToBoxAdapter(child: Padding(
              padding: EdgeInsets.all(48),
              child: Center(child: CircularProgressIndicator(color: AppColors.accent)))),
            error: (e, _) => SliverToBoxAdapter(child: _EmptyFeed(isDark: isDark, isError: true)),
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 90)),
        ]),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/projects/create'),
        backgroundColor: AppColors.accent,
        foregroundColor: Colors.white,
        elevation: 0,
        icon: const Icon(Icons.add_rounded),
        label: Text('New Project', style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w600)),
      ),
    );
  }
}

class _HeroBanner extends StatelessWidget {
  final bool isDark;
  const _HeroBanner({required this.isDark});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      gradient: LinearGradient(
        colors: [AppColors.accent.withOpacity(isDark ? 0.2 : 0.1),
                 AppColors.cyan.withOpacity(isDark ? 0.08 : 0.04)],
        begin: Alignment.topLeft, end: Alignment.bottomRight,
      ),
      border: Border.all(color: AppColors.accent.withOpacity(isDark ? 0.25 : 0.15)),
    ),
    child: Row(children: [
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Share your projects', style: GoogleFonts.spaceGrotesk(
          fontSize: 14, fontWeight: FontWeight.w600,
          color: isDark ? AppColors.textPri : AppColors.lTextPri)),
        const SizedBox(height: 4),
        Text('Let the community discover what you\'re building',
          style: GoogleFonts.inter(fontSize: 12, color: isDark ? AppColors.textSec : AppColors.lTextSec)),
      ])),
      Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.accent.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12)),
        child: const Icon(Icons.rocket_launch_outlined, size: 20, color: AppColors.accent),
      ),
    ]),
  );
}

class _IconBtn extends StatelessWidget {
  final IconData icon; final VoidCallback onTap;
  const _IconBtn({required this.icon, required this.onTap});
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42, height: 42,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: isDark ? AppColors.card : AppColors.lCard,
          border: Border.all(color: isDark ? AppColors.border : AppColors.lBorder),
        ),
        child: Icon(icon, size: 19,
          color: isDark ? AppColors.textSec : AppColors.lTextSec),
      ),
    );
  }
}

class _EmptyFeed extends StatelessWidget {
  final bool isDark; final bool isError;
  const _EmptyFeed({required this.isDark, this.isError = false});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 32),
    child: Column(children: [
      Container(width: 72, height: 72,
        decoration: BoxDecoration(shape: BoxShape.circle,
          color: isDark ? AppColors.card : AppColors.lCard),
        child: Icon(isError ? Icons.error_outline : Icons.rocket_launch_outlined,
          size: 32, color: AppColors.accent.withOpacity(0.6))),
      const SizedBox(height: 16),
      Text(isError ? 'Something went wrong' : 'No projects yet',
        style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w600, fontSize: 16,
          color: isDark ? AppColors.textPri : AppColors.lTextPri)),
      const SizedBox(height: 4),
      Text(isError ? 'Pull down to retry' : 'Be the first to share your work!',
        style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center),
    ]),
  );
}
