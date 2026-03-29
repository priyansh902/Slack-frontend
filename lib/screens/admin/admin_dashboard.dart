import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phoenix_slack/core/themes/app_theme.dart';
import 'package:phoenix_slack/data/model/user/user.dart';
import 'package:phoenix_slack/providers/auth_provider.dart';

// ── Providers for admin data ────────────────────────────────────────────────

final adminUsersProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  return ref.read(apiServiceProvider).getAllUsersAdmin();
});

final adminProjectsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  return ref.read(apiServiceProvider).getAllProjectsAdmin();
});

// ── Main dashboard ───────────────────────────────────────────────────────────

class AdminDashboard extends ConsumerStatefulWidget {
  const AdminDashboard({super.key});
  @override ConsumerState<AdminDashboard> createState() => _S();
}
class _S extends ConsumerState<AdminDashboard> {
  int _tab = 0; // 0=overview 1=users 2=projects

  @override
  Widget build(BuildContext context) {
    final user   = ref.watch(authStateProvider).user;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (user == null || !user.isAdmin) {
      return Scaffold(
        appBar: AppBar(title: const Text('Admin')),
        body: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.lock_outline_rounded, size: 48, color: AppColors.error),
          const SizedBox(height: 12),
          Text('Access Denied', style: GoogleFonts.spaceGrotesk(
            fontSize: 18, fontWeight: FontWeight.w600,
            color: isDark ? AppColors.textPri : AppColors.lTextPri)),
          const SizedBox(height: 6),
          Text('Admin privileges required.',
            style: Theme.of(context).textTheme.bodyMedium),
        ])),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: _TabBar(selected: _tab, onTap: (i) => setState(() => _tab = i)),
        ),
      ),
      body: IndexedStack(index: _tab, children: [
        _OverviewTab(user: user, isDark: isDark),
        _UsersTab(isDark: isDark, ref: ref),
        _ProjectsTab(isDark: isDark, ref: ref),
      ]),
    );
  }
}

// ── Tab bar ──────────────────────────────────────────────────────────────────

class _TabBar extends StatelessWidget {
  final int selected; final ValueChanged<int> onTap;
  const _TabBar({required this.selected, required this.onTap});
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tabs = ['Overview', 'Users', 'Projects'];
    return Container(
      color: isDark ? AppColors.bg : AppColors.lBg,
      child: Row(children: tabs.asMap().entries.map((e) {
        final sel = e.key == selected;
        return Expanded(child: GestureDetector(
          onTap: () => onTap(e.key),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(
                color: sel ? AppColors.accent : Colors.transparent, width: 2))),
            child: Text(e.value, textAlign: TextAlign.center,
              style: GoogleFonts.spaceGrotesk(
                fontSize: 13, fontWeight: sel ? FontWeight.w600 : FontWeight.w400,
                color: sel ? AppColors.accent
                  : (isDark ? AppColors.textSec : AppColors.lTextSec))),
          ),
        ));
      }).toList()),
    );
  }
}

// ── Overview tab ──────────────────────────────────────────────────────────────

class _OverviewTab extends ConsumerWidget {
  final User user; final bool isDark;
  const _OverviewTab({required this.user, required this.isDark});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(adminUsersProvider);
    final projAsync  = ref.watch(adminProjectsProvider);

    return ListView(padding: const EdgeInsets.all(16), children: [
      // Admin banner
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            AppColors.accent.withOpacity(isDark ? 0.22 : 0.1),
            AppColors.cyan.withOpacity(isDark ? 0.1 : 0.04)],
            begin: Alignment.topLeft, end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.accent.withOpacity(0.25))),
        child: Row(children: [
          Container(width: 44, height: 44,
            decoration: BoxDecoration(color: AppColors.accentLo,
              borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.shield_rounded, color: AppColors.accent, size: 22)),
          const SizedBox(width: 14),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Admin Panel', style: GoogleFonts.spaceGrotesk(
              fontSize: 15, fontWeight: FontWeight.w600,
              color: isDark ? AppColors.textPri : AppColors.lTextPri)),
            Text('Logged in as ${user.name}',
              style: GoogleFonts.inter(fontSize: 12, color: isDark ? AppColors.textSec : AppColors.lTextSec)),
          ]),
        ]),
      ).animate().fadeIn(duration: 350.ms),
      const SizedBox(height: 16),
      // Stats row
      Row(children: [
        Expanded(child: _StatCard(
          label: 'Total Users',
          value: usersAsync.maybeWhen(data: (u) => '${u.length}', orElse: () => '…'),
          icon: Icons.people_alt_outlined, color: AppColors.accent, isDark: isDark)),
        const SizedBox(width: 12),
        Expanded(child: _StatCard(
          label: 'Projects',
          value: projAsync.maybeWhen(
            data: (r) => '${(r['projects'] as List? ?? []).length}', orElse: () => '…'),
          icon: Icons.code_rounded, color: AppColors.cyan, isDark: isDark)),
      ]).animate().fadeIn(delay: 100.ms),
      const SizedBox(height: 16),
      // Quick actions
      Text('Quick Actions',
        style: GoogleFonts.spaceGrotesk(fontSize: 14, fontWeight: FontWeight.w600,
          color: isDark ? AppColors.textSec : AppColors.lTextSec)),
      const SizedBox(height: 10),
      ...[ 
        _QuickAction(label: 'Manage Users', icon: Icons.people_alt_outlined,
          color: const Color(0xFF6C63FF), onTap: () {}),
        _QuickAction(label: 'Manage Projects', icon: Icons.code_rounded,
          color: const Color(0xFF00CFFF), onTap: () {}),
        _QuickAction(label: 'Manage Profiles', icon: Icons.person_outline_rounded,
          color: const Color(0xFF22C55E), onTap: () {}),
        _QuickAction(label: 'Manage Resumes', icon: Icons.description_outlined,
          color: const Color(0xFFF59E0B), onTap: () {}),
      ].asMap().entries.map((e) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: e.value.animate().fadeIn(delay: (150 + e.key * 60).ms).slideX(begin: 0.04, end: 0),
      )),
    ]);
  }
}

// ── Users tab ─────────────────────────────────────────────────────────────────

class _UsersTab extends ConsumerWidget {
  final bool isDark; final WidgetRef ref;
  const _UsersTab({required this.isDark, required this.ref});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(adminUsersProvider);
    return usersAsync.when(
      data: (users) => RefreshIndicator(
        color: AppColors.accent,
        onRefresh: () async => ref.invalidate(adminUsersProvider),
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: users.length,
          itemBuilder: (_, i) => _UserRow(user: users[i], isDark: isDark, ref: ref)
            .animate().fadeIn(delay: (i * 40).ms),
        )),
      loading: () => const Center(child: CircularProgressIndicator(color: AppColors.accent)),
      error: (e, _) => _ErrorRetry(error: e.toString(),
        onRetry: () => ref.invalidate(adminUsersProvider)),
    );
  }
}

class _UserRow extends StatelessWidget {
  final Map<String, dynamic> user; final bool isDark; final WidgetRef ref;
  const _UserRow({required this.user, required this.isDark, required this.ref});
  @override
  Widget build(BuildContext context) {
    final name     = user['name'] as String? ?? '';
    final username = user['username'] as String? ?? '';
    final email    = user['email'] as String? ?? '';
    final role     = (user['role'] as String? ?? '').contains('ADMIN') ? 'Admin' : 'User';
    final isAdmin  = role == 'Admin';
    final userId   = user['id'] as int? ?? 0;
    final cols = AppColors.avatarGradient(username);
    final init = name.isNotEmpty ? name[0].toUpperCase() : '?';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.card : AppColors.lCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isDark ? AppColors.border : AppColors.lBorder)),
      child: Row(children: [
        Container(width: 44, height: 44,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(colors: cols,
              begin: Alignment.topLeft, end: Alignment.bottomRight)),
          child: Center(child: Text(init, style: GoogleFonts.spaceGrotesk(
            color: Colors.white, fontWeight: FontWeight.w700, fontSize: 17)))),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(name, style: GoogleFonts.spaceGrotesk(fontSize: 14, fontWeight: FontWeight.w600,
            color: isDark ? AppColors.textPri : AppColors.lTextPri)),
          Text('@$username · $email', style: GoogleFonts.inter(fontSize: 11,
            color: isDark ? AppColors.textSec : AppColors.lTextSec),
            overflow: TextOverflow.ellipsis),
        ])),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: isAdmin ? AppColors.accentLo : (isDark ? AppColors.surface : AppColors.lBg),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: isAdmin ? AppColors.accent.withOpacity(0.3)
              : (isDark ? AppColors.border : AppColors.lBorder))),
          child: Text(role, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600,
            color: isAdmin ? AppColors.accent : (isDark ? AppColors.textSec : AppColors.lTextSec)))),
        const SizedBox(width: 6),
        PopupMenuButton<String>(
          icon: Icon(Icons.more_vert_rounded, size: 18,
            color: isDark ? AppColors.textSec : AppColors.lTextSec),
          color: isDark ? AppColors.card : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          onSelected: (v) => _handleAction(context, v, userId, username, isAdmin),
          itemBuilder: (_) => [
            if (!isAdmin) PopupMenuItem(value: 'promote',
              child: Row(children: [
                const Icon(Icons.admin_panel_settings_outlined, size: 16, color: AppColors.accent),
                const SizedBox(width: 8),
                Text('Make Admin', style: GoogleFonts.inter(fontSize: 13))])),
            if (isAdmin) PopupMenuItem(value: 'demote',
              child: Row(children: [
                Icon(Icons.person_outline_rounded, size: 16, color: isDark ? AppColors.textSec : AppColors.lTextSec),
                const SizedBox(width: 8),
                Text('Remove Admin', style: GoogleFonts.inter(fontSize: 13))])),
            PopupMenuItem(value: 'profile',
              child: Row(children: [
                const Icon(Icons.visibility_outlined, size: 16),
                const SizedBox(width: 8),
                Text('View Profile', style: GoogleFonts.inter(fontSize: 13))])),
          ],
        ),
      ]),
    );
  }

  void _handleAction(BuildContext ctx, String action, int userId, String username, bool isAdmin) async {
    final api = ref.read(apiServiceProvider);
    switch (action) {
      case 'promote':
        try {
          await api.makeAdmin(userId);
          ref.invalidate(adminUsersProvider);
          if (ctx.mounted) {
            ScaffoldMessenger.of(ctx).showSnackBar(
            SnackBar(content: Text('$username is now an admin')));
          }
        } catch (e) {
          if (ctx.mounted) {
            ScaffoldMessenger.of(ctx).showSnackBar(
            SnackBar(content: Text('Failed: $e'), backgroundColor: AppColors.error));
          }
        }
      case 'demote':
        try {
          await api.removeAdmin(userId);
          ref.invalidate(adminUsersProvider);
          if (ctx.mounted) {
            ScaffoldMessenger.of(ctx).showSnackBar(
            SnackBar(content: Text('Admin removed from $username')));
          }
        } catch (e) {
          if (ctx.mounted) {
            ScaffoldMessenger.of(ctx).showSnackBar(
            SnackBar(content: Text('Failed: $e'), backgroundColor: AppColors.error));
          }
        }
      case 'profile':
        Navigator.pushNamed(ctx, '/profile/user', arguments: {'userId': userId, 'name': username});
    }
  }
}

// ── Projects tab ───────────────────────────────────────────────────────────────

class _ProjectsTab extends ConsumerWidget {
  final bool isDark; final WidgetRef ref;
  const _ProjectsTab({required this.isDark, required this.ref});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projAsync = ref.watch(adminProjectsProvider);
    return projAsync.when(
      data: (data) {
        final projects = (data['projects'] as List? ?? [])
            .cast<Map<String, dynamic>>();
        if (projects.isEmpty) {
          return Center(child: Text('No projects',
          style: Theme.of(context).textTheme.bodyMedium));
        }
        return RefreshIndicator(
          color: AppColors.accent,
          onRefresh: () async => ref.invalidate(adminProjectsProvider),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: projects.length,
            itemBuilder: (_, i) => _ProjectRow(p: projects[i], isDark: isDark, ref: ref)
              .animate().fadeIn(delay: (i * 40).ms),
          ));
      },
      loading: () => const Center(child: CircularProgressIndicator(color: AppColors.accent)),
      error: (e, _) => _ErrorRetry(error: e.toString(),
        onRetry: () => ref.invalidate(adminProjectsProvider)),
    );
  }
}

class _ProjectRow extends StatelessWidget {
  final Map<String, dynamic> p; final bool isDark; final WidgetRef ref;
  const _ProjectRow({required this.p, required this.isDark, required this.ref});
  @override
  Widget build(BuildContext context) {
    final title    = p['title'] as String? ?? '';
    final username = p['username'] as String? ?? '';
    final id       = p['id'] as int? ?? 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.card : AppColors.lCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isDark ? AppColors.border : AppColors.lBorder)),
      child: Row(children: [
        Container(width: 38, height: 38,
          decoration: BoxDecoration(color: AppColors.accentLo,
            borderRadius: BorderRadius.circular(10)),
          child: const Icon(Icons.code_rounded, size: 18, color: AppColors.accent)),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: GoogleFonts.spaceGrotesk(fontSize: 14, fontWeight: FontWeight.w600,
            color: isDark ? AppColors.textPri : AppColors.lTextPri),
            maxLines: 1, overflow: TextOverflow.ellipsis),
          Text('by @$username', style: GoogleFonts.inter(fontSize: 11,
            color: isDark ? AppColors.textSec : AppColors.lTextSec)),
        ])),
        IconButton(
          icon: const Icon(Icons.delete_outline_rounded, size: 18, color: AppColors.error),
          onPressed: () => _delete(context, id, title),
          tooltip: 'Delete project',
        ),
      ]),
    );
  }

  void _delete(BuildContext ctx, int id, String title) async {
    final ok = await showDialog<bool>(context: ctx,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Delete Project', style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w600)),
        content: Text('Delete "$title"? This cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete', style: TextStyle(color: AppColors.error))),
        ]));
    if (ok != true) return;
    try {
      await ref.read(apiServiceProvider).adminDeleteProject(id);
      ref.invalidate(adminProjectsProvider);
      if (ctx.mounted) {
        ScaffoldMessenger.of(ctx).showSnackBar(
        const SnackBar(content: Text('Project deleted')));
      }
    } catch (e) {
      if (ctx.mounted) {
        ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(content: Text('Failed: $e'), backgroundColor: AppColors.error));
      }
    }
  }
}

// ── Reusable sub-widgets ──────────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  final String label, value; final IconData icon; final Color color; final bool isDark;
  const _StatCard({required this.label, required this.value,
    required this.icon, required this.color, required this.isDark});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: isDark ? AppColors.card : AppColors.lCard,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: isDark ? AppColors.border : AppColors.lBorder)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(width: 36, height: 36,
        decoration: BoxDecoration(color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: color, size: 18)),
      const SizedBox(height: 10),
      Text(value, style: GoogleFonts.spaceGrotesk(fontSize: 22, fontWeight: FontWeight.w700,
        color: isDark ? AppColors.textPri : AppColors.lTextPri)),
      Text(label, style: GoogleFonts.inter(fontSize: 11,
        color: isDark ? AppColors.textSec : AppColors.lTextSec)),
    ]),
  );
}

class _QuickAction extends StatelessWidget {
  final String label; final IconData icon; final Color color; final VoidCallback onTap;
  const _QuickAction({required this.label, required this.icon,
    required this.color, required this.onTap});
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? AppColors.card : AppColors.lCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: isDark ? AppColors.border : AppColors.lBorder)),
        child: Row(children: [
          Container(width: 40, height: 40,
            decoration: BoxDecoration(color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: color, size: 18)),
          const SizedBox(width: 14),
          Expanded(child: Text(label, style: GoogleFonts.spaceGrotesk(
            fontSize: 14, fontWeight: FontWeight.w600,
            color: isDark ? AppColors.textPri : AppColors.lTextPri))),
          Icon(Icons.arrow_forward_ios_rounded, size: 13,
            color: isDark ? AppColors.textHint : AppColors.lTextSec),
        ]),
      ),
    );
  }
}

class _ErrorRetry extends StatelessWidget {
  final String error; final VoidCallback onRetry;
  const _ErrorRetry({required this.error, required this.onRetry});
  @override
  Widget build(BuildContext context) => Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
    const Icon(Icons.error_outline_rounded, size: 40, color: AppColors.error),
    const SizedBox(height: 12),
    Text('Failed to load', style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w600)),
    const SizedBox(height: 6),
    Text(error, style: Theme.of(context).textTheme.bodySmall, textAlign: TextAlign.center),
    const SizedBox(height: 16),
    ElevatedButton.icon(onPressed: onRetry,
      icon: const Icon(Icons.refresh_rounded, size: 16),
      label: const Text('Retry')),
  ]));
}
