import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phoenix_slack/core/themes/app_theme.dart';
import 'package:phoenix_slack/data/model/profile/profile.dart';
import 'package:phoenix_slack/providers/profile_provider.dart';
import 'package:phoenix_slack/widgets/common/app_button.dart';
import 'package:phoenix_slack/widgets/common/app_field.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});
  @override ConsumerState<EditProfileScreen> createState() => _S();
}
class _S extends ConsumerState<EditProfileScreen> {
  final _form = GlobalKey<FormState>();
  final _bio  = TextEditingController();
  final _skills= TextEditingController();
  final _gh   = TextEditingController();
  final _li   = TextEditingController();
  bool _loading = false, _preloaded = false;

  @override void initState() { super.initState(); _prefill(); }
  @override void dispose() {
    for (final c in [_bio,_skills,_gh,_li]) {
      c.dispose();
    }
    super.dispose();
  }

  void _prefill() async {
    final p = await ref.read(myProfileProvider.future);
    if (!mounted) return;
    if (p != null) {
      _bio.text = p.bio; _skills.text = p.skills;
      _gh.text = p.githubUrl ?? ''; _li.text = p.linkedinUrl ?? '';
    }
    setState(() => _preloaded = true);
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _loading = true);
    final ok = await ref.read(myProfileNotifierProvider.notifier).createOrUpdate(
      ProfileRequest(
        bio: _bio.text.isNotEmpty ? _bio.text : null,
        skills: _skills.text.isNotEmpty ? _skills.text : null,
        githubUrl: _gh.text.isNotEmpty ? _gh.text : null,
        linkedinUrl: _li.text.isNotEmpty ? _li.text : null));
    setState(() => _loading = false);
    if (!mounted) return;
    if (ok) {
      // Reload profile in the notifier so MyProfileScreen updates on pop
      ref.read(myProfileNotifierProvider.notifier).loadProfile();
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile saved!')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Failed to save profile'), backgroundColor: AppColors.error));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (!_preloaded) {
      return const Scaffold(
      body: Center(child: CircularProgressIndicator(color: AppColors.accent)));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(key: _form, child: Column(children: [
          _Hint(text: 'Your profile is visible to other logged-in users.', isDark: isDark)
            .animate().fadeIn(duration: 350.ms),
          const SizedBox(height: 20),
          AppField(controller: _bio, label: 'Bio', hint: 'Tell the world about yourself…',
            maxLines: 4, maxLength: 500, icon: Icons.notes_rounded)
            .animate().fadeIn(delay: 80.ms),
          const SizedBox(height: 14),
          AppField(controller: _skills, label: 'Skills',
            hint: 'Flutter, Dart, Spring Boot, PostgreSQL',
            icon: Icons.psychology_outlined)
            .animate().fadeIn(delay: 140.ms),
          const SizedBox(height: 4),
          Align(alignment: Alignment.centerLeft,
            child: Text('Separate skills with commas',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 11))),
          const SizedBox(height: 14),
          AppField(controller: _gh, label: 'GitHub URL',
            hint: 'https://github.com/username',
            icon: Icons.code_rounded, keyboard: TextInputType.url)
            .animate().fadeIn(delay: 200.ms),
          const SizedBox(height: 14),
          AppField(controller: _li, label: 'LinkedIn URL',
            hint: 'https://linkedin.com/in/username',
            icon: Icons.business_rounded, keyboard: TextInputType.url)
            .animate().fadeIn(delay: 260.ms),
          const SizedBox(height: 28),
          AppButton(text: 'Save Profile', onPressed: _save, isLoading: _loading)
            .animate().fadeIn(delay: 320.ms),
        ])),
      ),
    );
  }
}

class _Hint extends StatelessWidget {
  final String text; final bool isDark;
  const _Hint({required this.text, required this.isDark});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    decoration: BoxDecoration(
      color: AppColors.accentLo,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppColors.accent.withOpacity(0.25))),
    child: Row(children: [
      const Icon(Icons.info_outline_rounded, size: 16, color: AppColors.accent),
      const SizedBox(width: 8),
      Expanded(child: Text(text, style: GoogleFonts.inter(
        fontSize: 12, color: AppColors.accent))),
    ]),
  );
}
