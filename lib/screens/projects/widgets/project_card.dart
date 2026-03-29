import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phoenix_slack/core/themes/app_theme.dart';
import 'package:phoenix_slack/data/model/project/project.dart';
import 'package:url_launcher/url_launcher.dart';

class ProjectCard extends StatelessWidget {
  final Project project;
  const ProjectCard({super.key, required this.project});

  static const _techMap = {
    'flutter': [Color(0xFF1A3A5C), Color(0xFF54C5F8)],
    'dart':    [Color(0xFF1A3A5C), Color(0xFF54C5F8)],
    'react':   [Color(0xFF1A3540), Color(0xFF61DAFB)],
    'vue':     [Color(0xFF1A3A2A), Color(0xFF41B883)],
    'angular': [Color(0xFF3A1A1A), Color(0xFFDD0031)],
    'python':  [Color(0xFF2A2A1A), Color(0xFFFFD43B)],
    'java':    [Color(0xFF3A1A1A), Color(0xFFFF8C42)],
    'spring':  [Color(0xFF1A3A1A), Color(0xFF6DB33F)],
    'node':    [Color(0xFF1A3A1A), Color(0xFF68A063)],
    'typescript':[Color(0xFF1A2A3A), Color(0xFF3178C6)],
    'kotlin':  [Color(0xFF2A1A3A), Color(0xFF9C4EFF)],
    'swift':   [Color(0xFF3A1A1A), Color(0xFFFF6B2B)],
    'go':      [Color(0xFF1A3A3A), Color(0xFF00ACD7)],
    'rust':    [Color(0xFF2A1A10), Color(0xFFFF6B2B)],
    'next':    [Color(0xFF1E1E1E), Color(0xFFAAAAAA)],
  };

  List<Color> _tc(String t) {
    final k = t.toLowerCase();
    for (final e in _techMap.entries) {
      if (k.contains(e.key)) return e.value;
    }
    return [const Color(0xFF1E2030), AppColors.textSec];
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final techs = project.techStackList;
    final cols = AppColors.avatarGradient(project.username);

    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/project', arguments: project.id),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.card : AppColors.lCard,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: isDark ? AppColors.border : AppColors.lBorder),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Author row
          Row(children: [
            Container(
              width: 36, height: 36,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(colors: cols, begin: Alignment.topLeft, end: Alignment.bottomRight),
              ),
              child: Center(child: Text(
                project.username.isNotEmpty ? project.username[0].toUpperCase() : '?',
                style: GoogleFonts.spaceGrotesk(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14),
              )),
            ),
            const SizedBox(width: 10),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('@${project.username}',
                style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500,
                  color: isDark ? AppColors.textSec : AppColors.lTextSec)),
              Text(_timeAgo(project.createdAt),
                style: GoogleFonts.inter(fontSize: 11,
                  color: isDark ? AppColors.textHint : AppColors.lTextSec.withOpacity(0.7))),
            ]),
            const Spacer(),
            Icon(Icons.arrow_outward_rounded, size: 15,
              color: isDark ? AppColors.textHint : AppColors.lTextSec),
          ]),
          const SizedBox(height: 14),
          // Title
          Text(project.title,
            style: GoogleFonts.spaceGrotesk(fontSize: 15, fontWeight: FontWeight.w600,
              color: isDark ? AppColors.textPri : AppColors.lTextPri),
            maxLines: 2, overflow: TextOverflow.ellipsis),
          if (project.description.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(project.description,
              style: GoogleFonts.inter(fontSize: 13, height: 1.5,
                color: isDark ? AppColors.textSec : AppColors.lTextSec),
              maxLines: 2, overflow: TextOverflow.ellipsis),
          ],
          if (techs.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(spacing: 6, runSpacing: 6,
              children: techs.take(5).map((t) {
                final c = _tc(t);
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                  decoration: BoxDecoration(color: c[0], borderRadius: BorderRadius.circular(6)),
                  child: Text(t,
                    style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: c[1])),
                );
              }).toList()),
          ],
          if (project.githubLink != null || project.liveLink != null) ...[
            const SizedBox(height: 12),
            Divider(height: 1, color: isDark ? AppColors.border : AppColors.lBorder),
            const SizedBox(height: 10),
            Row(children: [
              if (project.githubLink != null)
                _Link(label: 'GitHub', icon: Icons.code_rounded, isDark: isDark,
                  onTap: () => _open(project.githubLink!)),
              if (project.githubLink != null && project.liveLink != null)
                const SizedBox(width: 8),
              if (project.liveLink != null)
                _Link(label: 'Live Demo', icon: Icons.open_in_new_rounded, isDark: isDark,
                  accent: true, onTap: () => _open(project.liveLink!)),
            ]),
          ],
        ]),
      ),
    );
  }

  void _open(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  String _timeAgo(DateTime dt) {
    final d = DateTime.now().difference(dt);
    if (d.inDays > 30) return '${(d.inDays/30).floor()}mo ago';
    if (d.inDays > 0) return '${d.inDays}d ago';
    if (d.inHours > 0) return '${d.inHours}h ago';
    return 'just now';
  }
}

class _Link extends StatelessWidget {
  final String label; final IconData icon;
  final bool isDark, accent; final VoidCallback onTap;
  const _Link({required this.label, required this.icon, required this.isDark,
    this.accent = false, required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: accent ? AppColors.accentLo : (isDark ? AppColors.surface : AppColors.lBg),
        border: Border.all(color: accent ? AppColors.accent.withOpacity(0.35)
          : (isDark ? AppColors.border : AppColors.lBorder)),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 13, color: accent ? AppColors.accent
          : (isDark ? AppColors.textSec : AppColors.lTextSec)),
        const SizedBox(width: 5),
        Text(label, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500,
          color: accent ? AppColors.accent : (isDark ? AppColors.textSec : AppColors.lTextSec))),
      ]),
    ),
  );
}
