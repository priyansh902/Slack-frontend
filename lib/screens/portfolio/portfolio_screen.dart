import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phoenix_slack/core/themes/app_theme.dart';
import 'package:phoenix_slack/providers/auth_provider.dart';
import 'package:phoenix_slack/screens/projects/widgets/project_card.dart';
import 'package:phoenix_slack/data/model/project/project.dart';
import 'package:url_launcher/url_launcher.dart';

// Public portfolio provider — uses /api/portfolio/{username} (no auth required)
final publicPortfolioProvider = FutureProvider.family<Map<String, dynamic>, String>(
  (ref, username) async {
    return ref.read(apiServiceProvider).getPortfolio(username);
  });

class PortfolioScreen extends ConsumerWidget {
  final String username;
  const PortfolioScreen({super.key, required this.username});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pAsync = ref.watch(publicPortfolioProvider(username));
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: RefreshIndicator(
        color: AppColors.accent,
        onRefresh: () async => ref.invalidate(publicPortfolioProvider(username)),
        child: pAsync.when(
          data: (data) => _PortfolioBody(data: data, username: username, isDark: isDark),
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.accent)),
          error: (e, _) => Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.person_off_outlined, size: 48, color: AppColors.error),
            const SizedBox(height: 12),
            Text('Portfolio not found', style: GoogleFonts.spaceGrotesk(
              fontWeight: FontWeight.w600, fontSize: 16)),
            const SizedBox(height: 6),
            Text('@$username', style: GoogleFonts.inter(color: AppColors.textSec)),
          ])),
        ),
      ),
    );
  }
}

class _PortfolioBody extends StatelessWidget {
  final Map<String, dynamic> data;
  final String username;
  final bool isDark;
  const _PortfolioBody({required this.data, required this.username, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final name      = data['name'] as String? ?? username;
    final bio       = data['bio'] as String? ?? '';
    final skills    = (data['skills'] as List? ?? []).cast<String>();
    final githubUrl = data['githubUrl'] as String?;
    final linkedinUrl = data['linkedinUrl'] as String?;
    final resumeUrl = data['resumeUrl'] as String?;
    final projects  = (data['projects'] as List? ?? [])
        .cast<Map<String, dynamic>>();
    final memberSince = data['memberSince'] as String?;
    final cols = AppColors.avatarGradient(username);
    final init = name.isNotEmpty ? name[0].toUpperCase() : '?';

    return CustomScrollView(slivers: [
      // Hero header
      SliverAppBar(
        expandedHeight: 200,
        pinned: true,
        backgroundColor: isDark ? AppColors.bg : AppColors.lBg,
        flexibleSpace: FlexibleSpaceBar(
          background: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.accent.withOpacity(isDark ? 0.25 : 0.12),
                         AppColors.cyan.withOpacity(isDark ? 0.1 : 0.05)],
                begin: Alignment.topLeft, end: Alignment.bottomRight)),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const SizedBox(height: 40),
              Container(width: 72, height: 72,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(colors: cols,
                    begin: Alignment.topLeft, end: Alignment.bottomRight)),
                child: Center(child: Text(init, style: GoogleFonts.spaceGrotesk(
                  color: Colors.white, fontSize: 30, fontWeight: FontWeight.w700)))),
              const SizedBox(height: 10),
              Text(name, style: GoogleFonts.spaceGrotesk(fontSize: 18,
                fontWeight: FontWeight.w600, color: AppColors.textPri)),
              Text('@$username', style: GoogleFonts.inter(fontSize: 13,
                color: AppColors.textSec)),
            ])),
        ),
        title: Text('@$username'),
      ),

      // Info card
      SliverToBoxAdapter(child: Container(
        margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: isDark ? AppColors.card : AppColors.lCard,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: isDark ? AppColors.border : AppColors.lBorder)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Member since
          if (memberSince != null) Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(children: [
              Icon(Icons.calendar_today_outlined, size: 13,
                color: isDark ? AppColors.textSec : AppColors.lTextSec),
              const SizedBox(width: 6),
              Text('Member since ${_fmtDate(memberSince)}',
                style: GoogleFonts.inter(fontSize: 12,
                  color: isDark ? AppColors.textSec : AppColors.lTextSec)),
            ])),
          if (bio.isNotEmpty) ...[
            Text(bio, style: GoogleFonts.inter(fontSize: 14, height: 1.7,
              color: isDark ? AppColors.textSec : AppColors.lTextSec)),
            const SizedBox(height: 14),
          ],
          if (skills.isNotEmpty) ...[
            Wrap(spacing: 6, runSpacing: 6,
              children: skills.map((s) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surface : AppColors.lBg,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: isDark ? AppColors.border : AppColors.lBorder)),
                child: Text(s, style: GoogleFonts.inter(fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: isDark ? AppColors.textPri : AppColors.lTextPri)),
              )).toList()),
            const SizedBox(height: 14),
          ],
          // Social links + resume
          Wrap(spacing: 8, runSpacing: 8, children: [
            if (githubUrl != null)
              _LinkChip(label: 'GitHub', icon: Icons.code_rounded,
                url: githubUrl, isDark: isDark),
            if (linkedinUrl != null)
              _LinkChip(label: 'LinkedIn', icon: Icons.business_rounded,
                url: linkedinUrl, isDark: isDark),
            if (resumeUrl != null)
              _LinkChip(label: 'Resume', icon: Icons.description_outlined,
                url: resumeUrl, isDark: isDark, accent: true),
          ]),
        ]),
      ).animate().fadeIn(duration: 400.ms)),

      // Projects header
      SliverToBoxAdapter(child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
        child: Text('Projects (${projects.length})',
          style: GoogleFonts.spaceGrotesk(fontSize: 16, fontWeight: FontWeight.w600,
            color: isDark ? AppColors.textPri : AppColors.lTextPri)),
      )),

      // Project cards (using raw map → Project)
      projects.isEmpty
        ? SliverToBoxAdapter(child: Padding(
            padding: const EdgeInsets.all(40),
            child: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
              Icon(Icons.code_off_rounded, size: 40,
                color: isDark ? AppColors.textSec : AppColors.lTextSec),
              const SizedBox(height: 10),
              Text('No projects yet', style: Theme.of(context).textTheme.bodyMedium),
            ]))))
        : SliverList(delegate: SliverChildBuilderDelegate(
            (ctx, i) {
              final raw = projects[i];
              // Convert raw map to Project model
              final proj = Project(
                id: raw['id'] as int? ?? 0,
                userId: raw['userId'] as int? ?? 0,
                username: raw['username'] as String? ?? username,
                title: raw['title'] as String? ?? '',
                description: raw['description'] as String? ?? '',
                techStack: raw['techStack'] as String?,
                githubLink: raw['githubLink'] as String?,
                liveLink: raw['liveLink'] as String?,
                createdAt: raw['createdAt'] != null
                  ? DateTime.tryParse(raw['createdAt'] as String) ?? DateTime.now()
                  : DateTime.now(),
              );
              return ProjectCard(project: proj)
                .animate().fadeIn(delay: (i * 60).ms);
            },
            childCount: projects.length,
          )),
      const SliverPadding(padding: EdgeInsets.only(bottom: 40)),
    ]);
  }

  String _fmtDate(String iso) {
    try {
      final dt = DateTime.parse(iso);
      const m = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
      return '${m[dt.month-1]} ${dt.year}';
    } catch (_) { return iso; }
  }
}

class _LinkChip extends StatelessWidget {
  final String label, url; final IconData icon;
  final bool isDark; final bool accent;
  const _LinkChip({required this.label, required this.url, required this.icon,
    required this.isDark, this.accent = false});
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () async {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) await launchUrl(uri, mode: LaunchMode.externalApplication);
    },
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: accent ? AppColors.accentLo : (isDark ? AppColors.surface : AppColors.lBg),
        border: Border.all(color: accent
          ? AppColors.accent.withOpacity(0.35)
          : (isDark ? AppColors.border : AppColors.lBorder))),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 13, color: accent ? AppColors.accent
          : (isDark ? AppColors.textSec : AppColors.lTextSec)),
        const SizedBox(width: 5),
        Text(label, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500,
          color: accent ? AppColors.accent : (isDark ? AppColors.textSec : AppColors.lTextSec))),
      ])),
  );
}
