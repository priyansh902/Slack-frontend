import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phoenix_slack/core/themes/app_theme.dart';
import 'package:phoenix_slack/data/model/profile/profile.dart';
import 'package:phoenix_slack/providers/auth_provider.dart';
import 'package:phoenix_slack/providers/profile_provider.dart';
import 'package:phoenix_slack/providers/project_provider.dart';
import 'package:phoenix_slack/screens/projects/widgets/project_card.dart';
import 'package:url_launcher/url_launcher.dart';

class MyProfileScreen extends ConsumerStatefulWidget {
  const MyProfileScreen({super.key});
  @override ConsumerState<MyProfileScreen> createState() => _S();
}

class _S extends ConsumerState<MyProfileScreen> {
  @override void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(myProfileNotifierProvider.notifier).loadProfile();
      ref.read(myProjectsNotifierProvider.notifier).loadMyProjects();
    });
  }

  Future<void> _goEdit() async {
    await Navigator.pushNamed(context, '/profile/edit');
    // Reload after returning from edit
    if (mounted) {
      ref.read(myProfileNotifierProvider.notifier).loadProfile();
    }
  }

  Future<void> _goCreateProject() async {
    await Navigator.pushNamed(context, '/projects/create');
    if (mounted) {
      ref.read(myProjectsNotifierProvider.notifier).loadMyProjects();
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth         = ref.watch(authStateProvider);
    final profileAsync = ref.watch(myProfileNotifierProvider);
    final projectsAsync= ref.watch(myProjectsNotifierProvider);
    final isDark       = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: RefreshIndicator(
        color: AppColors.accent,
        onRefresh: () async {
          await ref.read(myProfileNotifierProvider.notifier).loadProfile();
          await ref.read(myProjectsNotifierProvider.notifier).loadMyProjects();
        },
        child: CustomScrollView(slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: isDark ? AppColors.bg : AppColors.lBg,
            title: const Text('My Profile'),
            actions: [
              IconButton(icon: const Icon(Icons.edit_outlined),
                onPressed: _goEdit, tooltip: 'Edit profile'),
              IconButton(icon: const Icon(Icons.settings_outlined),
                onPressed: () => Navigator.pushNamed(context, '/settings'),
                tooltip: 'Settings'),
            ],
          ),
          // Profile card — null is a valid data state (no profile yet)
          SliverToBoxAdapter(child: profileAsync.when(
            data: (p) => p == null
              ? _NoProfile(isDark: isDark, onTap: _goEdit)
              : _ProfileCard(profile: p, user: auth.user, isDark: isDark, onResume: () =>
                  Navigator.pushNamed(context, '/resume'))
                .animate().fadeIn(duration: 400.ms),
            loading: () => const Padding(padding: EdgeInsets.all(60),
              child: Center(child: CircularProgressIndicator(color: AppColors.accent))),
            error: (e, _) => _NoProfile(isDark: isDark, onTap: _goEdit),
          )),
          // My Projects header
          SliverToBoxAdapter(child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 10),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('My Projects', style: GoogleFonts.spaceGrotesk(fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.textPri : AppColors.lTextPri)),
              TextButton.icon(
                onPressed: _goCreateProject,
                icon: const Icon(Icons.add_rounded, size: 16),
                label: const Text('New'),
                style: TextButton.styleFrom(foregroundColor: AppColors.accent,
                  padding: EdgeInsets.zero, minimumSize: Size.zero),
              ),
            ]),
          )),
          // Projects list
          projectsAsync.when(
            data: (projects) {
              if (projects.isEmpty) {
                return SliverToBoxAdapter(child: _EmptyProjects(isDark: isDark,
                  onTap: _goCreateProject));
              }
              return SliverList(delegate: SliverChildBuilderDelegate(
                (ctx, i) => ProjectCard(project: projects[i])
                  .animate().fadeIn(delay: (i * 50).ms),
                childCount: projects.length,
              ));
            },
            loading: () => const SliverToBoxAdapter(child: Padding(
              padding: EdgeInsets.all(32),
              child: Center(child: CircularProgressIndicator(color: AppColors.accent)))),
            error: (_, __) => const SliverToBoxAdapter(
              child: Center(child: Padding(padding: EdgeInsets.all(32),
                child: Text('Failed to load projects')))),
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 90)),
        ]),
      ),
    );
  }
}

// ── Profile card ───────────────────────────────────────────────────────────

class _ProfileCard extends StatelessWidget {
  final Profile profile;
  final dynamic user;
  final bool isDark;
  final VoidCallback onResume;
  const _ProfileCard({required this.profile, required this.user,
    required this.isDark, required this.onResume});

  @override
  Widget build(BuildContext context) {
    final name   = profile.name.isNotEmpty ? profile.name : (user?.name ?? 'User');
    final uname  = profile.username.isNotEmpty ? profile.username : (user?.username ?? '');
    final bio    = profile.bio;
    final skills = profile.skillsList;
    final init   = name.isNotEmpty ? name[0].toUpperCase() : 'U';
    final cols   = AppColors.avatarGradient(uname);

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.card : AppColors.lCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDark ? AppColors.border : AppColors.lBorder)),
      child: Column(children: [
        Row(children: [
          Container(width: 68, height: 68,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(18),
              gradient: LinearGradient(colors: cols,
                begin: Alignment.topLeft, end: Alignment.bottomRight)),
            child: Center(child: Text(init, style: GoogleFonts.spaceGrotesk(
              color: Colors.white, fontSize: 28, fontWeight: FontWeight.w700)))),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(name, style: GoogleFonts.spaceGrotesk(fontSize: 18, fontWeight: FontWeight.w600,
              color: isDark ? AppColors.textPri : AppColors.lTextPri)),
            const SizedBox(height: 2),
            Text('@$uname', style: GoogleFonts.inter(fontSize: 13,
              color: isDark ? AppColors.textSec : AppColors.lTextSec)),
            if (user?.isAdmin == true) ...[
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.accentLo,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppColors.accent.withOpacity(0.3))),
                child: Text('Admin', style: GoogleFonts.inter(fontSize: 11,
                  fontWeight: FontWeight.w600, color: AppColors.accent))),
            ],
          ])),
        ]),
        if (bio.isNotEmpty) ...[
          const SizedBox(height: 14),
          Divider(height: 1, color: isDark ? AppColors.border : AppColors.lBorder),
          const SizedBox(height: 14),
          Align(alignment: Alignment.centerLeft,
            child: Text(bio, style: GoogleFonts.inter(fontSize: 14, height: 1.6,
              color: isDark ? AppColors.textSec : AppColors.lTextSec))),
        ],
        if (skills.isNotEmpty) ...[
          const SizedBox(height: 12),
          Align(alignment: Alignment.centerLeft,
            child: Wrap(spacing: 6, runSpacing: 6,
              children: skills.map((s) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surface : AppColors.lBg,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: isDark ? AppColors.border : AppColors.lBorder)),
                child: Text(s, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500,
                  color: isDark ? AppColors.textPri : AppColors.lTextPri)),
              )).toList())),
        ],
        const SizedBox(height: 14),
        Divider(height: 1, color: isDark ? AppColors.border : AppColors.lBorder),
        const SizedBox(height: 12),
        Row(children: [
          if (profile.githubUrl != null)
            _SocialBtn(label: 'GitHub', icon: Icons.code_rounded, isDark: isDark,
              onTap: () => _open(profile.githubUrl!)),
          if (profile.githubUrl != null && profile.linkedinUrl != null)
            const SizedBox(width: 8),
          if (profile.linkedinUrl != null)
            _SocialBtn(label: 'LinkedIn', icon: Icons.business_rounded, isDark: isDark,
              onTap: () => _open(profile.linkedinUrl!)),
          const Spacer(),
          TextButton.icon(
            onPressed: onResume,
            icon: const Icon(Icons.description_outlined, size: 15),
            label: const Text('Resume'),
            style: TextButton.styleFrom(foregroundColor: AppColors.accent,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6))),
        ]),
      ]),
    );
  }

  void _open(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

class _SocialBtn extends StatelessWidget {
  final String label; final IconData icon; final bool isDark; final VoidCallback onTap;
  const _SocialBtn({required this.label, required this.icon,
    required this.isDark, required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: isDark ? AppColors.surface : AppColors.lBg,
        border: Border.all(color: isDark ? AppColors.border : AppColors.lBorder)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 14, color: isDark ? AppColors.textSec : AppColors.lTextSec),
        const SizedBox(width: 5),
        Text(label, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500,
          color: isDark ? AppColors.textSec : AppColors.lTextSec)),
      ])));
}

class _NoProfile extends StatelessWidget {
  final bool isDark; final VoidCallback onTap;
  const _NoProfile({required this.isDark, required this.onTap});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(32),
    child: Column(children: [
      Container(width: 72, height: 72,
        decoration: BoxDecoration(shape: BoxShape.circle,
          color: isDark ? AppColors.card : AppColors.lCard,
          border: Border.all(color: isDark ? AppColors.border : AppColors.lBorder)),
        child: Icon(Icons.person_add_outlined, size: 32,
          color: isDark ? AppColors.textSec : AppColors.lTextSec)),
      const SizedBox(height: 14),
      Text('Profile not set up yet', style: GoogleFonts.spaceGrotesk(
        fontWeight: FontWeight.w600, fontSize: 16,
        color: isDark ? AppColors.textPri : AppColors.lTextPri)),
      const SizedBox(height: 6),
      Text('Add a bio, skills, and social links',
        style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center),
      const SizedBox(height: 20),
      SizedBox(width: 170, child: ElevatedButton.icon(
        onPressed: onTap,
        icon: const Icon(Icons.add_rounded, size: 16),
        label: const Text('Create Profile'))),
    ]),
  );
}

class _EmptyProjects extends StatelessWidget {
  final bool isDark; final VoidCallback onTap;
  const _EmptyProjects({required this.isDark, required this.onTap});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 32),
    child: Column(children: [
      Container(width: 72, height: 72,
        decoration: BoxDecoration(shape: BoxShape.circle,
          color: isDark ? AppColors.card : AppColors.lCard,
          border: Border.all(color: isDark ? AppColors.border : AppColors.lBorder)),
        child: Icon(Icons.code_rounded, size: 32, color: AppColors.accent.withOpacity(0.6))),
      const SizedBox(height: 16),
      Text('No projects yet', style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w600,
        fontSize: 16, color: isDark ? AppColors.textPri : AppColors.lTextPri)),
      const SizedBox(height: 4),
      Text('Share what you\'ve built with the world',
        style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center),
      const SizedBox(height: 20),
      SizedBox(width: 170, child: ElevatedButton(
        onPressed: onTap, child: const Text('Create Project'))),
    ]),
  );
}
