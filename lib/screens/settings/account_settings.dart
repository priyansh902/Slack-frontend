import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phoenix_slack/core/themes/app_theme.dart';
import 'package:phoenix_slack/providers/auth_provider.dart';
import 'package:phoenix_slack/providers/profile_provider.dart';

class AccountSettingsScreen extends ConsumerWidget {
  const AccountSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user   = ref.watch(authStateProvider).user;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Account')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Info card
          _InfoCard(user: user, isDark: isDark).animate().fadeIn(duration: 350.ms),
          const SizedBox(height: 16),
          // Danger zone
          _DangerCard(isDark: isDark, onDelete: () => _delete(context, ref))
            .animate().fadeIn(delay: 150.ms),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  void _delete(BuildContext context, WidgetRef ref) async {
    final ok = await showDialog<bool>(context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text('Delete Account', style: GoogleFonts.spaceGrotesk(
          fontWeight: FontWeight.w600, color: AppColors.error)),
        content: const Text(
          'All your data including projects, profile, and resume will be permanently deleted. '
          'This cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: AppColors.error))),
        ]));
    if (ok != true || !context.mounted) return;

    await ref.read(myProfileNotifierProvider.notifier).delete();
    await ref.read(authStateProvider.notifier).logout();
    if (context.mounted) {
      Navigator.pushReplacementNamed(context, '/login');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account deleted')));
    }
  }
}

class _InfoCard extends StatelessWidget {
  final dynamic user; final bool isDark;
  const _InfoCard({required this.user, required this.isDark});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: isDark ? AppColors.card : AppColors.lCard,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: isDark ? AppColors.border : AppColors.lBorder)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Account Info', style: GoogleFonts.spaceGrotesk(
        fontSize: 15, fontWeight: FontWeight.w600,
        color: isDark ? AppColors.textPri : AppColors.lTextPri)),
      const SizedBox(height: 14),
      Divider(height: 1, color: isDark ? AppColors.border : AppColors.lBorder),
      const SizedBox(height: 10),
      _Row(label: 'Name',     value: user?.name ?? '—',     isDark: isDark),
      _Row(label: 'Username', value: '@${user?.username ?? '—'}', isDark: isDark),
      _Row(label: 'Email',    value: user?.email ?? '—',    isDark: isDark),
      _Row(label: 'Role',     value: user?.roleDisplay ?? 'User', isDark: isDark),
      _Row(label: 'Member since',
        value: user?.createdAt != null ? _fmt(user!.createdAt) : '—', isDark: isDark),
    ]),
  );

  String _fmt(DateTime dt) {
    const m = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return '${m[dt.month-1]} ${dt.day}, ${dt.year}';
  }
}

class _Row extends StatelessWidget {
  final String label, value; final bool isDark;
  const _Row({required this.label, required this.value, required this.isDark});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(children: [
      SizedBox(width: 110,
        child: Text(label, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500,
          color: isDark ? AppColors.textSec : AppColors.lTextSec))),
      Expanded(child: Text(value, style: GoogleFonts.inter(fontSize: 13,
        color: isDark ? AppColors.textPri : AppColors.lTextPri))),
    ]),
  );
}

class _DangerCard extends StatelessWidget {
  final bool isDark; final VoidCallback onDelete;
  const _DangerCard({required this.isDark, required this.onDelete});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: AppColors.error.withOpacity(isDark ? 0.07 : 0.04),
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: AppColors.error.withOpacity(0.2))),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        const Icon(Icons.warning_amber_rounded, size: 18, color: AppColors.error),
        const SizedBox(width: 8),
        Text('Danger Zone', style: GoogleFonts.spaceGrotesk(
          fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.error)),
      ]),
      const SizedBox(height: 10),
      Text('Permanently delete your account and all associated data.',
        style: GoogleFonts.inter(fontSize: 13,
          color: isDark ? AppColors.textSec : AppColors.lTextSec)),
      const SizedBox(height: 16),
      SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: onDelete,
          icon: const Icon(Icons.delete_forever_rounded, size: 18),
          label: const Text('Delete My Account'),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.error,
            side: const BorderSide(color: AppColors.error),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
        ),
      ),
    ]),
  );
}
