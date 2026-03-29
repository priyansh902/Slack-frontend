import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phoenix_slack/core/themes/app_theme.dart';
import 'package:phoenix_slack/providers/project_provider.dart';
import 'package:phoenix_slack/providers/user_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ProjectDetailScreen extends ConsumerWidget {
  final int projectId;
  const ProjectDetailScreen({super.key, required this.projectId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pAsync = ref.watch(projectDetailsProvider(projectId));
    final me = ref.watch(currentUserProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Project'),
        actions: [
          pAsync.maybeWhen(
            data: (p) {
              if (p != null && p.userId == me?.id) {
                return PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert_rounded),
                  onSelected: (v) {
                    if (v == 'edit') Navigator.pushNamed(context, '/projects/edit', arguments: p);
                    if (v == 'delete') _confirmDelete(context, ref);
                  },
                  itemBuilder: (_) => [
                    const PopupMenuItem(value: 'edit', child: Row(children: [
                      Icon(Icons.edit_outlined, size: 18), SizedBox(width: 8), Text('Edit')])),
                    const PopupMenuItem(value: 'delete', child: Row(children: [
                      Icon(Icons.delete_outline, size: 18, color: AppColors.error), SizedBox(width: 8),
                      Text('Delete', style: TextStyle(color: AppColors.error))])),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
            orElse: () => const SizedBox.shrink(),
          ),
        ],
      ),
      body: pAsync.when(
        data: (p) {
          if (p == null) return const Center(child: Text('Project not found'));
          final cols = AppColors.avatarGradient(p.username);
          final techs = p.techStackList;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // Author row
              Row(children: [
                Container(width: 44, height: 44,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(colors: cols, begin: Alignment.topLeft, end: Alignment.bottomRight)),
                  child: Center(child: Text(p.username[0].toUpperCase(),
                    style: GoogleFonts.spaceGrotesk(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 18)))),
                const SizedBox(width: 12),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/profile/user', arguments: {'userId': p.userId, 'name': p.username}),
                    child: Text('@${p.username}', style: GoogleFonts.inter(
                      fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.accent))),
                  Text(_fmt(p.createdAt), style: GoogleFonts.inter(
                    fontSize: 12, color: isDark ? AppColors.textSec : AppColors.lTextSec)),
                ]),
              ]).animate().fadeIn(duration: 300.ms),
              const SizedBox(height: 20),
              Text(p.title, style: GoogleFonts.spaceGrotesk(fontSize: 24, fontWeight: FontWeight.w700,
                color: isDark ? AppColors.textPri : AppColors.lTextPri))
                .animate().fadeIn(delay: 80.ms),
              if (p.description.isNotEmpty) ...[
                const SizedBox(height: 14),
                Container(padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.card : AppColors.lCard,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: isDark ? AppColors.border : AppColors.lBorder)),
                  child: Text(p.description, style: GoogleFonts.inter(fontSize: 14, height: 1.7,
                    color: isDark ? AppColors.textSec : AppColors.lTextSec))),
              ].animate().fadeIn(delay: 150.ms),
              if (techs.isNotEmpty) ...[
                const SizedBox(height: 20),
                Text('Tech Stack', style: GoogleFonts.spaceGrotesk(fontSize: 14, fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.textPri : AppColors.lTextPri)),
                const SizedBox(height: 10),
                Wrap(spacing: 8, runSpacing: 8, children: techs.map((t) => Chip(label: Text(t))).toList()),
              ].animate().fadeIn(delay: 220.ms),
              if (p.githubLink != null || p.liveLink != null) ...[
                const SizedBox(height: 24),
                Text('Links', style: GoogleFonts.spaceGrotesk(fontSize: 14, fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.textPri : AppColors.lTextPri)),
                const SizedBox(height: 12),
                if (p.githubLink != null) _LinkTile(icon: Icons.code_rounded, label: 'GitHub Repository',
                  url: p.githubLink!, isDark: isDark),
                if (p.liveLink != null) _LinkTile(icon: Icons.open_in_new_rounded, label: 'Live Demo',
                  url: p.liveLink!, isDark: isDark),
              ].animate().fadeIn(delay: 280.ms),
            ]),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.accent)),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  String _fmt(DateTime dt) {
    const m = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return '${m[dt.month-1]} ${dt.day}, ${dt.year}';
  }

  void _confirmDelete(BuildContext context, WidgetRef ref) {
    showDialog(context: context, builder: (_) => AlertDialog(
      backgroundColor: AppColors.card,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text('Delete Project', style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w600)),
      content: const Text('This action cannot be undone.'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context),
          child: const Text('Cancel')),
        TextButton(
          onPressed: () async {
            Navigator.pop(context);
            final ok = await ref.read(myProjectsNotifierProvider.notifier).delete(projectId);
            if (ok && context.mounted) {
              ref.invalidate(recentProjectsProvider);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Project deleted')));
            }
          },
          child: const Text('Delete', style: TextStyle(color: AppColors.error))),
      ],
    ));
  }
}

class _LinkTile extends StatelessWidget {
  final IconData icon; final String label, url; final bool isDark;
  const _LinkTile({required this.icon, required this.label, required this.url, required this.isDark});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: GestureDetector(
      onTap: () async {
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) await launchUrl(uri, mode: LaunchMode.externalApplication);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isDark ? AppColors.card : AppColors.lCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isDark ? AppColors.border : AppColors.lBorder)),
        child: Row(children: [
          Icon(icon, size: 18, color: AppColors.accent),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500,
            color: isDark ? AppColors.textPri : AppColors.lTextPri))),
          Icon(Icons.arrow_forward_rounded, size: 16,
            color: isDark ? AppColors.textSec : AppColors.lTextSec),
        ]),
      ),
    ),
  );
}
