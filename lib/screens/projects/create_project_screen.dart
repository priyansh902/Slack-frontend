import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phoenix_slack/data/model/project/project.dart';
import 'package:phoenix_slack/providers/project_provider.dart';
import 'package:phoenix_slack/widgets/common/custom_button.dart';
import 'package:phoenix_slack/widgets/common/custom_text_field.dart';

class CreateProjectScreen extends ConsumerStatefulWidget {
  const CreateProjectScreen({super.key});

  @override
  ConsumerState<CreateProjectScreen> createState() => _CreateProjectScreenState();
}

class _CreateProjectScreenState extends ConsumerState<CreateProjectScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _techStackController = TextEditingController();
  final _githubController = TextEditingController();
  final _liveController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _techStackController.dispose();
    _githubController.dispose();
    _liveController.dispose();
    super.dispose();
  }

  Future<void> _handleCreate() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      
      final success = await ref.read(myProjectsNotifierProvider.notifier).create(
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Project created successfully')),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to create project')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Project'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextField(
                controller: _titleController,
                label: 'Project Title',
                prefixIcon: Icons.title,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Title is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _descriptionController,
                label: 'Description',
                maxLines: 4,
                maxLength: 1000,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _techStackController,
                label: 'Tech Stack (comma separated)',
                hint: 'Flutter, Dart, Firebase',
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _githubController,
                label: 'GitHub Repository URL',
                prefixIcon: Icons.code,
                keyboardType: TextInputType.url,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _liveController,
                label: 'Live Demo URL',
                prefixIcon: Icons.open_in_browser,
                keyboardType: TextInputType.url,
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: 'Create Project',
                onPressed: _handleCreate,
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}