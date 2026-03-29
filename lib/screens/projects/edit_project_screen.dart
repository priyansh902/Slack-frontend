import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phoenix_slack/core/themes/app_theme.dart';
import 'package:phoenix_slack/data/model/project/project.dart';
import 'package:phoenix_slack/providers/project_provider.dart';
import 'package:phoenix_slack/widgets/common/app_button.dart';
import 'package:phoenix_slack/widgets/common/app_field.dart';

class EditProjectScreen extends ConsumerStatefulWidget {
  final Project project;
  const EditProjectScreen({super.key, required this.project});
  @override ConsumerState<EditProjectScreen> createState() => _S();
}
class _S extends ConsumerState<EditProjectScreen> {
  late final TextEditingController _title,_desc,_tech,_gh,_live;
  final _form = GlobalKey<FormState>();
  bool _loading = false;

  @override void initState() {
    super.initState();
    _title = TextEditingController(text: widget.project.title);
    _desc  = TextEditingController(text: widget.project.description);
    _tech  = TextEditingController(text: widget.project.techStack ?? '');
    _gh    = TextEditingController(text: widget.project.githubLink ?? '');
    _live  = TextEditingController(text: widget.project.liveLink ?? '');
  }
  @override void dispose() {
    for (final c in [_title,_desc,_tech,_gh,_live]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _update() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _loading = true);
    final ok = await ref.read(myProjectsNotifierProvider.notifier).update(
      widget.project.id,
      ProjectRequest(title: _title.text.trim(), description: _desc.text.trim(),
        techStack: _tech.text.trim().isEmpty ? null : _tech.text.trim(),
        githubLink: _gh.text.trim().isEmpty ? null : _gh.text.trim(),
        liveLink: _live.text.trim().isEmpty ? null : _live.text.trim()),
    );
    setState(() => _loading = false);
    if (!mounted) return;
    if (ok) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Project updated!')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Update failed'), backgroundColor: AppColors.error));
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Edit Project')),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(key: _form, child: Column(children: [
        AppField(controller: _title, label: 'Title *', icon: Icons.title_rounded,
          validator: (v) => (v == null || v.isEmpty) ? 'Title is required' : null),
        const SizedBox(height: 14),
        AppField(controller: _desc, label: 'Description', maxLines: 4, maxLength: 1000,
          icon: Icons.description_outlined),
        const SizedBox(height: 14),
        AppField(controller: _tech, label: 'Tech Stack',
          hint: 'Flutter, Dart, Spring Boot', icon: Icons.layers_outlined),
        const SizedBox(height: 14),
        AppField(controller: _gh, label: 'GitHub URL',
          icon: Icons.code_rounded, keyboard: TextInputType.url),
        const SizedBox(height: 14),
        AppField(controller: _live, label: 'Live Demo URL',
          icon: Icons.open_in_new_rounded, keyboard: TextInputType.url),
        const SizedBox(height: 28),
        AppButton(text: 'Update Project', onPressed: _update, isLoading: _loading),
      ])),
    ),
  );
}
