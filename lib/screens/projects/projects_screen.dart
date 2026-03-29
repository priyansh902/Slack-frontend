import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phoenix_slack/core/themes/app_theme.dart';
import 'package:phoenix_slack/providers/project_provider.dart';
import 'package:phoenix_slack/screens/projects/widgets/project_card.dart';

class ProjectsScreen extends ConsumerStatefulWidget {
  const ProjectsScreen({super.key});
  @override ConsumerState<ProjectsScreen> createState() => _S();
}
class _S extends ConsumerState<ProjectsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        ref.read(myProjectsNotifierProvider.notifier).loadMyProjects());
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final projectsAsync = ref.watch(myProjectsNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Projects'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            tooltip: 'New project',
            onPressed: () async {
              await Navigator.pushNamed(context, '/projects/create');
              if (mounted) {
                ref.read(myProjectsNotifierProvider.notifier).loadMyProjects();
              }
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        color: AppColors.accent,
        onRefresh: () async =>
            ref.read(myProjectsNotifierProvider.notifier).loadMyProjects(),
        child: projectsAsync.when(
          data: (projects) {
            if (projects.isEmpty) return _Empty(isDark: isDark);
            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: projects.length,
              itemBuilder: (_, i) => ProjectCard(project: projects[i])
                  .animate().fadeIn(delay: (i * 50).ms, duration: 300.ms),
            );
          },
          loading: () => const Center(
              child: CircularProgressIndicator(color: AppColors.accent)),
          error: (e, _) => Center(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              const Icon(Icons.error_outline_rounded, size: 40, color: AppColors.error),
              const SizedBox(height: 12),
              Text('Failed to load projects',
                style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w600)),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => ref.read(myProjectsNotifierProvider.notifier).loadMyProjects(),
                icon: const Icon(Icons.refresh_rounded, size: 16),
                label: const Text('Retry'),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  final bool isDark; const _Empty({required this.isDark});
  @override
  Widget build(BuildContext context) => Center(child: Padding(
    padding: const EdgeInsets.all(40),
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      Container(width: 80, height: 80,
        decoration: BoxDecoration(shape: BoxShape.circle,
          color: isDark ? AppColors.card : AppColors.lCard,
          border: Border.all(color: isDark ? AppColors.border : AppColors.lBorder)),
        child: Icon(Icons.code_rounded, size: 36,
          color: AppColors.accent.withOpacity(0.7))),
      const SizedBox(height: 16),
      Text('No projects yet', style: GoogleFonts.spaceGrotesk(
        fontSize: 18, fontWeight: FontWeight.w600,
        color: isDark ? AppColors.textPri : AppColors.lTextPri)),
      const SizedBox(height: 6),
      Text('Create your first project to get started',
        style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center),
      const SizedBox(height: 24),
      SizedBox(width: 180, child: ElevatedButton.icon(
        onPressed: () => Navigator.pushNamed(context, '/projects/create'),
        icon: const Icon(Icons.add_rounded, size: 16),
        label: const Text('Create Project'),
      )),
    ]),
  ));
}
