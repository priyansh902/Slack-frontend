import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phoenix_slack/core/themes/app_theme.dart';
import 'package:phoenix_slack/providers/profile_provider.dart';
import 'package:phoenix_slack/screens/projects/widgets/project_card.dart';
import 'package:url_launcher/url_launcher.dart';

class UserProfileScreen extends ConsumerWidget {
  final int userId;      // Use userId — backend getUsername() returns email, not actual username
  final String? displayName; // Optional display name for app bar
  const UserProfileScreen({super.key, required this.userId, this.displayName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pAsync  = ref.watch(profileByIdProvider(userId));
    final prAsync = ref.watch(userProjectsByIdProvider(userId));
    final isDark  = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: RefreshIndicator(
        color: AppColors.accent,
        onRefresh: () async {
          ref.invalidate(profileByIdProvider(userId));
          ref.invalidate(userProjectsByIdProvider(userId));
        },
        child: CustomScrollView(slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: isDark ? AppColors.bg : AppColors.lBg,
            title: Text(displayName != null ? displayName! : 'Profile'),
          ),
          SliverToBoxAdapter(child: pAsync.when(
            data: (p) {
              if (p == null) {
                return Padding(
                padding: const EdgeInsets.all(40),
                child: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.person_off_outlined, size: 48,
                    color: isDark ? AppColors.textSec : AppColors.lTextSec),
                  const SizedBox(height: 12),
                  Text('No profile yet', style: GoogleFonts.spaceGrotesk(
                    fontWeight: FontWeight.w600, fontSize: 16,
                    color: isDark ? AppColors.textPri : AppColors.lTextPri)),
                  const SizedBox(height: 6),
                  Text('This user hasn\'t set up their profile.',
                    style: Theme.of(context).textTheme.bodyMedium),
                ])));
              }
              return _ProfileSection(profile: p, isDark: isDark)
                .animate().fadeIn(duration: 400.ms);
            },
            loading: () => const Padding(padding: EdgeInsets.all(60),
              child: Center(child: CircularProgressIndicator(color: AppColors.accent))),
            error: (e, _) => Padding(
              padding: const EdgeInsets.all(40),
              child: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.person_off_outlined, size: 48,
                  color: isDark ? AppColors.textSec : AppColors.lTextSec),
                const SizedBox(height: 12),
                Text('Profile not found', style: GoogleFonts.spaceGrotesk(
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.textPri : AppColors.lTextPri)),
              ]))),
          )),
          SliverToBoxAdapter(child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 10),
            child: Text('Projects', style: GoogleFonts.spaceGrotesk(
              fontSize: 16, fontWeight: FontWeight.w600,
              color: isDark ? AppColors.textPri : AppColors.lTextPri)),
          )),
          prAsync.when(
            data: (projects) {
              if (projects.isEmpty) {
                return SliverToBoxAdapter(child: Padding(
                padding: const EdgeInsets.all(40),
                child: Center(child: Text('No projects yet',
                  style: Theme.of(context).textTheme.bodyMedium))));
              }
              return SliverList(delegate: SliverChildBuilderDelegate(
                (ctx, i) => ProjectCard(project: projects[i])
                  .animate().fadeIn(delay: (i * 50).ms),
                childCount: projects.length));
            },
            loading: () => const SliverToBoxAdapter(child: Center(child: Padding(
              padding: EdgeInsets.all(32),
              child: CircularProgressIndicator(color: AppColors.accent)))),
            error: (_, __) => const SliverToBoxAdapter(
              child: Center(child: Text('Error loading projects'))),
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 40)),
        ]),
      ),
    );
  }
}

class _ProfileSection extends StatelessWidget {
  final dynamic profile; final bool isDark;
  const _ProfileSection({required this.profile, required this.isDark});
  @override
  Widget build(BuildContext context) {
    final cols  = AppColors.avatarGradient(profile.username ?? '');
    final name  = profile.name ?? '';
    final uname = profile.username ?? '';
    final init  = name.isNotEmpty ? name[0].toUpperCase() : '?';
    final bio   = profile.bio ?? '';
    final skills = profile.skillsList ?? <String>[];

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.card : AppColors.lCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDark ? AppColors.border : AppColors.lBorder)),
      child: Column(children: [
        Row(children: [
          Container(width: 64, height: 64,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(colors: cols,
                begin: Alignment.topLeft, end: Alignment.bottomRight)),
            child: Center(child: Text(init, style: GoogleFonts.spaceGrotesk(
              color: Colors.white, fontSize: 26, fontWeight: FontWeight.w700)))),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(name, style: GoogleFonts.spaceGrotesk(fontSize: 18, fontWeight: FontWeight.w600,
              color: isDark ? AppColors.textPri : AppColors.lTextPri)),
            if (uname.isNotEmpty)
              Text('@$uname', style: GoogleFonts.inter(fontSize: 13,
                color: isDark ? AppColors.textSec : AppColors.lTextSec)),
          ])),
        ]),
        if (bio.isNotEmpty) ...[
          const SizedBox(height: 14),
          Divider(height: 1, color: isDark ? AppColors.border : AppColors.lBorder),
          const SizedBox(height: 14),
          Align(alignment: Alignment.centerLeft, child: Text(bio,
            style: GoogleFonts.inter(fontSize: 14, height: 1.6,
              color: isDark ? AppColors.textSec : AppColors.lTextSec))),
        ],
        if ((skills as List<String>).isNotEmpty) ...[
          const SizedBox(height: 12),
          Align(alignment: Alignment.centerLeft,
            child: Wrap(spacing: 6, runSpacing: 6,
              children: skills.map((s) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surface : AppColors.lBg,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: isDark ? AppColors.border : AppColors.lBorder)),
                child: Text(s, style: GoogleFonts.inter(fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: isDark ? AppColors.textPri : AppColors.lTextPri)),
              )).toList())),
        ],
        if (profile.githubUrl != null || profile.linkedinUrl != null) ...[
          const SizedBox(height: 14),
          Divider(height: 1, color: isDark ? AppColors.border : AppColors.lBorder),
          const SizedBox(height: 12),
          Row(children: [
            if (profile.githubUrl != null)
              _SLink(label: 'GitHub', icon: Icons.code_rounded,
                isDark: isDark, url: profile.githubUrl),
            if (profile.linkedinUrl != null) ...[
              const SizedBox(width: 8),
              _SLink(label: 'LinkedIn', icon: Icons.business_rounded,
                isDark: isDark, url: profile.linkedinUrl),
            ],
          ]),
        ],
      ]),
    );
  }
}

class _SLink extends StatelessWidget {
  final String label, url; final IconData icon; final bool isDark;
  const _SLink({required this.label, required this.url, required this.icon, required this.isDark});
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () async {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) await launchUrl(uri, mode: LaunchMode.externalApplication);
    },
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),
        color: isDark ? AppColors.surface : AppColors.lBg,
        border: Border.all(color: isDark ? AppColors.border : AppColors.lBorder)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 14, color: isDark ? AppColors.textSec : AppColors.lTextSec),
        const SizedBox(width: 5),
        Text(label, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500,
          color: isDark ? AppColors.textSec : AppColors.lTextSec)),
      ])),
  );
}
