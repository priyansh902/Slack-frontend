import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phoenix_slack/core/constants/app_constants.dart';
import 'package:phoenix_slack/core/themes/app_theme.dart';
import 'package:phoenix_slack/providers/auth_provider.dart';
import 'package:phoenix_slack/providers/user_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user   = ref.watch(currentUserProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          // Profile summary card
          _UserCard(user: user, isDark: isDark).animate().fadeIn(duration: 350.ms),
          const SizedBox(height: 8),
          _Section(title: 'Account', isDark: isDark, children: [
            _Tile(icon: Icons.person_outline_rounded, label: 'Account Settings',
              onTap: () => Navigator.pushNamed(context, '/settings/account'), isDark: isDark),
            _Tile(icon: Icons.description_outlined, label: 'My Resume',
              onTap: () => Navigator.pushNamed(context, '/resume'), isDark: isDark),
            _Tile(icon: Icons.edit_outlined, label: 'Edit Profile',
              onTap: () => Navigator.pushNamed(context, '/profile/edit'), isDark: isDark),
          ]).animate().fadeIn(delay: 80.ms),
          const SizedBox(height: 8),
          _Section(title: 'Developer', isDark: isDark, children: [
            _Tile(icon: Icons.code_rounded, label: 'My Projects',
              onTap: () => Navigator.pushNamed(context, '/projects'), isDark: isDark),
            _Tile(icon: Icons.public_rounded, label: 'My Portfolio',
              onTap: () {
                if (user?.username != null) {
                  Navigator.pushNamed(context, '/portfolio', arguments: user!.username);
                }
              }, isDark: isDark),
            if (user?.isAdmin == true)
              _Tile(icon: Icons.admin_panel_settings_outlined, label: 'Admin Dashboard',
                accent: true, onTap: () => Navigator.pushNamed(context, '/admin'), isDark: isDark),
          ]).animate().fadeIn(delay: 140.ms),
          const SizedBox(height: 8),
          _Section(title: 'About', isDark: isDark, children: [
            _Tile(icon: Icons.info_outline_rounded, label: 'Version ${AppConstants.appVersion}',
              trailing: const SizedBox.shrink(), isDark: isDark),
          ]).animate().fadeIn(delay: 200.ms),
          const SizedBox(height: 8),
          // Logout tile standalone
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: GestureDetector(
              onTap: () => _logout(context, ref),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.error.withOpacity(0.2))),
                child: Row(children: [
                  const Icon(Icons.logout_rounded, size: 20, color: AppColors.error),
                  const SizedBox(width: 14),
                  Text('Log Out', style: GoogleFonts.spaceGrotesk(
                    fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.error)),
                ]),
              ),
            ),
          ).animate().fadeIn(delay: 260.ms),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  void _logout(BuildContext context, WidgetRef ref) async {
    final ok = await showDialog<bool>(context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text('Log Out', style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w600)),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, true),
            child: const Text('Log Out', style: TextStyle(color: AppColors.error))),
        ]));
    if (ok == true) {
      await ref.read(authStateProvider.notifier).logout();
      if (context.mounted) Navigator.pushReplacementNamed(context, '/login');
    }
  }
}

class _UserCard extends StatelessWidget {
  final dynamic user; final bool isDark;
  const _UserCard({required this.user, required this.isDark});
  @override
  Widget build(BuildContext context) {
    if (user == null) return const SizedBox.shrink();
    final name = user.name ?? '';
    final uname= user.username ?? '';
    final cols = AppColors.avatarGradient(uname);
    final init = name.isNotEmpty ? name[0].toUpperCase() : '?';
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.accent.withOpacity(isDark ? 0.18 : 0.08),
                   AppColors.cyan.withOpacity(isDark ? 0.07 : 0.03)],
          begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.accent.withOpacity(isDark ? 0.25 : 0.15))),
      child: Row(children: [
        Container(width: 50, height: 50,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(14),
            gradient: LinearGradient(colors: cols, begin: Alignment.topLeft, end: Alignment.bottomRight)),
          child: Center(child: Text(init, style: GoogleFonts.spaceGrotesk(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)))),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(name, style: GoogleFonts.spaceGrotesk(fontSize: 15, fontWeight: FontWeight.w600,
            color: isDark ? AppColors.textPri : AppColors.lTextPri)),
          Text('@$uname', style: GoogleFonts.inter(fontSize: 13,
            color: isDark ? AppColors.textSec : AppColors.lTextSec)),
        ])),
        if (user.isAdmin == true)
          Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(color: AppColors.accentLo, borderRadius: BorderRadius.circular(6),
              border: Border.all(color: AppColors.accent.withOpacity(0.3))),
            child: Text('Admin', style: GoogleFonts.inter(
              fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.accent))),
      ]),
    );
  }
}

class _Section extends StatelessWidget {
  final String title; final bool isDark; final List<Widget> children;
  const _Section({required this.title, required this.isDark, required this.children});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(padding: const EdgeInsets.only(left: 4, bottom: 8),
        child: Text(title.toUpperCase(),
          style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.8,
            color: isDark ? AppColors.textHint : AppColors.lTextSec))),
      Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.card : AppColors.lCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: isDark ? AppColors.border : AppColors.lBorder)),
        child: Column(children: children.asMap().entries.map((e) {
          final isLast = e.key == children.length - 1;
          return Column(children: [
            e.value,
            if (!isLast) Divider(height: 1,
              color: isDark ? AppColors.border : AppColors.lBorder,
              indent: 52),
          ]);
        }).toList())),
    ]),
  );
}

class _Tile extends StatelessWidget {
  final IconData icon; final String label;
  final VoidCallback? onTap; final Widget? trailing;
  final bool isDark, accent;
  const _Tile({required this.icon, required this.label,
    this.onTap, this.trailing, required this.isDark, this.accent = false});
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(14),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      child: Row(children: [
        Icon(icon, size: 20,
          color: accent ? AppColors.accent : (isDark ? AppColors.textSec : AppColors.lTextSec)),
        const SizedBox(width: 14),
        Expanded(child: Text(label, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500,
          color: accent ? AppColors.accent : (isDark ? AppColors.textPri : AppColors.lTextPri)))),
        trailing ?? Icon(Icons.chevron_right_rounded, size: 18,
          color: isDark ? AppColors.textHint : AppColors.lTextSec),
      ]),
    ),
  );
}
