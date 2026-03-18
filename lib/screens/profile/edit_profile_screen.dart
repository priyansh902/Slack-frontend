import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/profile_provider.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_textfield.dart';
import '../../core/utils/validators.dart';
import '../../core/utils/helpers.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _bioController = TextEditingController();
  final _skillsController = TextEditingController();
  final _githubController = TextEditingController();
  final _linkedinController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadExistingProfile();
  }

  void _loadExistingProfile() {
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    final profile = profileProvider.profile;
    
    if (profile != null) {
      _bioController.text = profile.bio ?? '';
      _skillsController.text = profile.skills.join(', ');
      _githubController.text = profile.githubUrl ?? '';
      _linkedinController.text = profile.linkedinUrl ?? '';
    }
  }

  @override
  void dispose() {
    _bioController.dispose();
    _skillsController.dispose();
    _githubController.dispose();
    _linkedinController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
      
      final success = await profileProvider.createOrUpdateProfile(
        bio: _bioController.text.isEmpty ? null : _bioController.text,
        skills: _skillsController.text.isEmpty ? null : _skillsController.text,
        githubUrl: _githubController.text.isEmpty ? null : _githubController.text,
        linkedinUrl: _linkedinController.text.isEmpty ? null : _linkedinController.text,
      );

      if (success && mounted) {
        Helpers.showSnackBar(context, 'Profile saved successfully');
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(profileProvider.hasProfile ? 'Edit Profile' : 'Create Profile'),
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
                  'Tell us about yourself',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'This information will be displayed on your public portfolio.',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 24),
                
                const Text('Bio'),
                const SizedBox(height: 8),
                CustomTextField(
                  controller: _bioController,
                  hintText: 'e.g., Full-stack developer passionate about building cool stuff...',
                  maxLines: 4,
                ),
                const SizedBox(height: 16),
                
                const Text('Skills (comma separated)'),
                const SizedBox(height: 8),
                CustomTextField(
                  controller: _skillsController,
                  hintText: 'e.g., Java, Spring Boot, React, Flutter',
                ),
                const SizedBox(height: 16),
                
                const Text('GitHub URL'),
                const SizedBox(height: 8),
                CustomTextField(
                  controller: _githubController,
                  hintText: 'https://github.com/username',
                  keyboardType: TextInputType.url,
                  validator: Validators.validateUrl,
                ),
                const SizedBox(height: 16),
                
                const Text('LinkedIn URL'),
                const SizedBox(height: 8),
                CustomTextField(
                  controller: _linkedinController,
                  hintText: 'https://linkedin.com/in/username',
                  keyboardType: TextInputType.url,
                  validator: Validators.validateUrl,
                ),
                const SizedBox(height: 24),
                
                if (profileProvider.error != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      profileProvider.error!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                
                CustomButton(
                  text: profileProvider.hasProfile ? 'Update Profile' : 'Create Profile',
                  onPressed: _handleSubmit,
                  isLoading: profileProvider.isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}