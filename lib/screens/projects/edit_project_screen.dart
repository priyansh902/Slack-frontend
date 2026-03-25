import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phoenix_slack/core/extensions/context_extensions.dart';
import 'package:phoenix_slack/data/model/project/project.dart';
import 'package:phoenix_slack/providers/project_provider.dart';
import 'package:phoenix_slack/screens/projects/widgets/project_form.dart';

class EditProjectScreen extends ConsumerStatefulWidget {
  final Project project;
  
  const EditProjectScreen({
    super.key,
    required this.project,
  });

  @override
  ConsumerState<EditProjectScreen> createState() => _EditProjectScreenState();
}

class _EditProjectScreenState extends ConsumerState<EditProjectScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _techStackController;
  late final TextEditingController _githubController;
  late final TextEditingController _liveController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.project.title);
    _descriptionController = TextEditingController(text: widget.project.description);
    _techStackController = TextEditingController(text: widget.project.techStack ?? '');
    _githubController = TextEditingController(text: widget.project.githubLink ?? '');
    _liveController = TextEditingController(text: widget.project.liveLink ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _techStackController.dispose();
    _githubController.dispose();
    _liveController.dispose();
    super.dispose();
  }

  Future<void> _handleUpdate() async {
    setState(() => _isLoading = true);
    
    final success = await ref.read(myProjectsNotifierProvider.notifier).update(
      widget.project.id,
      ProjectRequest(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        techStack: _techStackController.text.trim(),
        githubLink: _githubController.text.trim(),
        liveLink: _liveController.text.trim(),
      ),
    );
    
    setState(() => _isLoading = false);
    
    if (success && mounted) {
      Navigator.pop(context);
      context.showSnackBar('Project updated successfully');
    } else if (mounted) {
      context.showSnackBar('Failed to update project', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Project'),
      ),
      body: ProjectForm(
        titleController: _titleController,
        descriptionController: _descriptionController,
        techStackController: _techStackController,
        githubController: _githubController,
        liveController: _liveController,
        isLoading: _isLoading,
        onSubmit: _handleUpdate,
        submitButtonText: 'Update Project',
      ),
    );
  }
}