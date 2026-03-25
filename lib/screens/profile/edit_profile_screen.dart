import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phoenix_slack/data/model/profile/profile.dart';
import 'package:phoenix_slack/providers/profile_provider.dart';
import 'package:phoenix_slack/widgets/common/custom_button.dart';
import 'package:phoenix_slack/widgets/common/custom_text_field.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _bioController = TextEditingController();
  final _skillsController = TextEditingController();
  final _githubController = TextEditingController();
  final _linkedinController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  void _loadProfile() async {
    final profile = await ref.read(myProfileProvider.future);
    if (profile != null) {
      _bioController.text = profile.bio;
      _skillsController.text = profile.skills;
      _githubController.text = profile.githubUrl ?? '';
      _linkedinController.text = profile.linkedinUrl ?? '';
    }
  }

  Future<void> _handleSave() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      
      final success = await ref.read(myProfileNotifierProvider.notifier).createOrUpdate(
        ProfileRequest(
          bio: _bioController.text.isNotEmpty ? _bioController.text : null,
          skills: _skillsController.text.isNotEmpty ? _skillsController.text : null,
          githubUrl: _githubController.text.isNotEmpty ? _githubController.text : null,
          linkedinUrl: _linkedinController.text.isNotEmpty ? _linkedinController.text : null,
        ),
      );
      
      setState(() => _isLoading = false);
      
      if (success && mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update profile')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextField(
                controller: _bioController,
                label: 'Bio',
                maxLines: 4,
                maxLength: 500,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _skillsController,
                label: 'Skills (comma separated)',
                hint: 'Flutter, Dart, Firebase, etc.',
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _githubController,
                label: 'GitHub URL',
                prefixIcon: Icons.code,
                keyboardType: TextInputType.url,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _linkedinController,
                label: 'LinkedIn URL',
                prefixIcon: Icons.business,
                keyboardType: TextInputType.url,
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: 'Save Profile',
                onPressed: _handleSave,
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}