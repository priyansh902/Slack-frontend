import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/project_provider.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_textfield.dart';
import '../../core/utils/validators.dart';
import '../../core/utils/helpers.dart';

class AddProjectScreen extends StatefulWidget {
  const AddProjectScreen({super.key});

  @override
  State<AddProjectScreen> createState() => _AddProjectScreenState();
}

class _AddProjectScreenState extends State<AddProjectScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _techStackController = TextEditingController();
  final _githubController = TextEditingController();
  final _liveController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _techStackController.dispose();
    _githubController.dispose();
    _liveController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      final projectProvider = Provider.of<ProjectProvider>(context, listen: false);
      
      final success = await projectProvider.createProject(
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
        Helpers.showSnackBar(context, 'Project created successfully');
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final projectProvider = Provider.of<ProjectProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Project'),
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
                  'Project Details',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Add your project to showcase on your portfolio.',
                  style: TextStyle(color: Colors.grey),
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
                  text: 'Create Project',
                  onPressed: _handleSubmit,
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