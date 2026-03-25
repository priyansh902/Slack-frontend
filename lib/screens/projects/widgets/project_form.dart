import 'package:flutter/material.dart';
import 'package:phoenix_slack/widgets/common/custom_button.dart';
import 'package:phoenix_slack/widgets/common/custom_text_field.dart';


class ProjectForm extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final TextEditingController techStackController;
  final TextEditingController githubController;
  final TextEditingController liveController;
  final bool isLoading;
  final VoidCallback onSubmit;
  final String submitButtonText;
  
  const ProjectForm({
    super.key,
    required this.titleController,
    required this.descriptionController,
    required this.techStackController,
    required this.githubController,
    required this.liveController,
    required this.isLoading,
    required this.onSubmit,
    required this.submitButtonText,
  });

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            CustomTextField(
              controller: titleController,
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
              controller: descriptionController,
              label: 'Description',
              maxLines: 4,
              maxLength: 1000,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: techStackController,
              label: 'Tech Stack (comma separated)',
              hint: 'Flutter, Dart, Firebase',
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: githubController,
              label: 'GitHub Repository URL',
              prefixIcon: Icons.code,
              keyboardType: TextInputType.url,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: liveController,
              label: 'Live Demo URL',
              prefixIcon: Icons.open_in_browser,
              keyboardType: TextInputType.url,
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: submitButtonText,
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  onSubmit();
                }
              },
              isLoading: isLoading,
            ),
          ],
        ),
      ),
    );
  }
}