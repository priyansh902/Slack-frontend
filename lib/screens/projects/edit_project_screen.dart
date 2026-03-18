import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/project_provider.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_textfield.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../core/utils/validators.dart';
import '../../core/utils/helpers.dart';

class EditProjectScreen extends StatefulWidget {
  final int projectId;

  const EditProjectScreen({super.key, required this.projectId});

  @override
  State<EditProjectScreen> createState() => _EditProjectScreenState();
}

class _EditProjectScreenState extends State<EditProjectScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _techStackController = TextEditingController();
  final _githubController = TextEditingController();
  final _liveController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProject();
  }

  Future<void> _loadProject() async {
    final projectProvider = Provider.of<ProjectProvider>(context, listen: false);
    await projectProvider.loadProjectById(widget.projectId);
    
    final project = projectProvider.currentProject;
    if (project != null) {
      _titleController.text = project.title;
      _descriptionController.text = project.description;
      _techStackController.text = project.techStack;
      _githubController.text = project.githubLink ?? '';
      _liveController.text = project.liveLink ?? '';
    }
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
    if (_formKey.currentState!.validate()) {
      final projectProvider = Provider.of<ProjectProvider>(context, listen: false);
      
      final success = await projectProvider.updateProject(
        projectId: widget.projectId,
        title: _titleController.text.trim(),
        description: _descriptionController.text.isEmpty 
            ? null 
            : _descriptionController.text.trim(),
        techStack: _techStackController.text.isEmpty 
            ? null 
            : _techStackController.text.trim(),
        githubLink: _githubController.text.isEmpty 
            ? null 
            : _githubController.text.trim(),
        liveLink: _liveController.text.isEmpty 
            ? null 
            : _liveController.text.trim(),
      );

      if (success && mounted) {
        Helpers.showSnackBar(context, 'Project updated successfully');
        Navigator.pop(context);
      }
    }
  }

  Future<void> _handleDelete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Project'),
        content: const Text('Are you sure you want to delete this project?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final projectProvider = Provider.of<ProjectProvider>(context, listen: false);
      final success = await projectProvider.deleteProject(widget.projectId);
      
      if (success && mounted) {
        Helpers.showSnackBar(context, 'Project deleted successfully');
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final projectProvider = Provider.of<ProjectProvider>(context);
    final project = projectProvider.currentProject;

    if (projectProvider.isLoading && project == null) {
      return const LoadingIndicator();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Project'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: _handleDelete,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Edit Project Details',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                
                const Text('Project Title *'),
                const SizedBox(height: 8),
                CustomTextField(
                  controller: _titleController,
                  hintText: 'e.g., E-Commerce Platform',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Title is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                const Text('Description'),
                const SizedBox(height: 8),
                CustomTextField(
                  controller: _descriptionController,
                  hintText: 'Describe your project...',
                  maxLines: 4,
                ),
                const SizedBox(height: 16),
                
                const Text('Tech Stack'),
                const SizedBox(height: 8),
                CustomTextField(
                  controller: _techStackController,
                  hintText: 'e.g., React, Spring Boot, MySQL',
                ),
                const SizedBox(height: 16),
                
                const Text('GitHub Repository URL'),
                const SizedBox(height: 8),
                CustomTextField(
                  controller: _githubController,
                  hintText: 'https://github.com/username/repo',
                  keyboardType: TextInputType.url,
                  validator: Validators.validateUrl,
                ),
                const SizedBox(height: 16),
                
                const Text('Live Demo URL'),
                const SizedBox(height: 8),
                CustomTextField(
                  controller: _liveController,
                  hintText: 'https://your-project.com',
                  keyboardType: TextInputType.url,
                  validator: Validators.validateUrl,
                ),
                const SizedBox(height: 24),
                
                if (projectProvider.error != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      projectProvider.error!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                
                CustomButton(
                  text: 'Update Project',
                  onPressed: _handleUpdate,
                  isLoading: projectProvider.isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}