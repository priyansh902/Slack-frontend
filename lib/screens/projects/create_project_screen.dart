import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phoenix_slack/core/themes/app_theme.dart';
import 'package:phoenix_slack/data/model/project/project.dart';
import 'package:phoenix_slack/providers/project_provider.dart';
import 'package:phoenix_slack/widgets/common/app_button.dart';
import 'package:phoenix_slack/widgets/common/app_field.dart';

class CreateProjectScreen extends ConsumerStatefulWidget {
  const CreateProjectScreen({super.key});
  @override ConsumerState<CreateProjectScreen> createState() => _S();
}
class _S extends ConsumerState<CreateProjectScreen> {
  final _form = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _desc  = TextEditingController();
  final _tech  = TextEditingController();
  final _gh    = TextEditingController();
  final _live  = TextEditingController();
  bool _loading = false;

  @override void dispose() {
    for (final c in [_title,_desc,_tech,_gh,_live]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _create() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _loading = true);
    final ok = await ref.read(myProjectsNotifierProvider.notifier).create(
      ProjectRequest(title: _title.text.trim(), description: _desc.text.trim(),
        techStack: _tech.text.trim().isEmpty ? null : _tech.text.trim(),
        githubLink: _gh.text.trim().isEmpty ? null : _gh.text.trim(),
        liveLink: _live.text.trim().isEmpty ? null : _live.text.trim()),
    );
    setState(() => _loading = false);
    if (!mounted) return;
    if (ok) {
      // Refresh feed too
      ref.invalidate(recentProjectsProvider);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Project created!')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Failed to create project'),
        backgroundColor: AppColors.error));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Project')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(key: _form, child: Column(children: [
          _Section(label: 'Project Details', icon: Icons.info_outline_rounded, children: [
            AppField(controller: _title, label: 'Title *', hint: 'My Awesome Project',
              icon: Icons.title_rounded,
              validator: (v) {
                if (v == null || v.isEmpty) return 'Title is required';
                if (v.length < 3) return 'Minimum 3 characters';
                return null;
              }),
            const SizedBox(height: 14),
            AppField(controller: _desc, label: 'Description', hint: 'What does your project do?',
              maxLines: 4, maxLength: 1000,
              icon: Icons.description_outlined),
          ]).animate().fadeIn(duration: 350.ms),
          const SizedBox(height: 16),
          _Section(label: 'Tech Stack', icon: Icons.code_rounded, children: [
            AppField(controller: _tech, label: 'Technologies',
              hint: 'Flutter, Dart, Spring Boot',
              icon: Icons.layers_outlined),
            const SizedBox(height: 4),
            Text('Separate with commas',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 11)),
          ]).animate().fadeIn(delay: 100.ms, duration: 350.ms),
          const SizedBox(height: 16),
          _Section(label: 'Links', icon: Icons.link_rounded, children: [
            AppField(controller: _gh, label: 'GitHub URL',
              hint: 'https://github.com/username/repo',
              icon: Icons.code_rounded, keyboard: TextInputType.url),
            const SizedBox(height: 14),
            AppField(controller: _live, label: 'Live Demo URL',
              hint: 'https://myapp.example.com',
              icon: Icons.open_in_new_rounded, keyboard: TextInputType.url),
          ]).animate().fadeIn(delay: 200.ms, duration: 350.ms),
          const SizedBox(height: 28),
          AppButton(text: 'Create Project', onPressed: _create, isLoading: _loading,
            icon: Icons.rocket_launch_rounded)
            .animate().fadeIn(delay: 280.ms),
          const SizedBox(height: 20),
        ])),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String label; final IconData icon; final List<Widget> children;
  const _Section({required this.label, required this.icon, required this.children});
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.card : AppColors.lCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? AppColors.border : AppColors.lBorder)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(color: AppColors.accentLo,
              borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, size: 16, color: AppColors.accent)),
          const SizedBox(width: 8),
          Text(label, style: GoogleFonts.spaceGrotesk(
            fontSize: 14, fontWeight: FontWeight.w600,
            color: isDark ? AppColors.textPri : AppColors.lTextPri)),
        ]),
        const SizedBox(height: 14),
        ...children,
      ]),
    );
  }
}
