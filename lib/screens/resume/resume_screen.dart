import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:phoenix_slack/data/model/resume/resume.dart';
import 'package:phoenix_slack/providers/resume_provider.dart';
import 'package:phoenix_slack/widgets/common/custom_button.dart';

import 'package:url_launcher/url_launcher.dart';

class ResumeScreen extends ConsumerStatefulWidget {
  const ResumeScreen({super.key});

  @override
  ConsumerState<ResumeScreen> createState() => _ResumeScreenState();
}

class _ResumeScreenState extends ConsumerState<ResumeScreen> {
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(resumeNotifierProvider.notifier).loadResume();
    });
  }

  Future<void> _pickAndUploadResume() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        setState(() => _isUploading = true);
        
        final file = result.files.first;
        final multipartFile = await MultipartFile.fromFile(
          file.path!,
          filename: file.name,
        );
        
        final success = await ref.read(resumeNotifierProvider.notifier)
            .upload(multipartFile);
        
        setState(() => _isUploading = false);
        
        if (success && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Resume uploaded successfully')),
          );
        } else if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to upload resume')),
          );
        }
      }
    } catch (e) {
      setState(() => _isUploading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _viewResume(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _deleteResume() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Resume'),
        content: const Text('Are you sure you want to delete your resume?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    
    if (confirm == true) {
      final success = await ref.read(resumeNotifierProvider.notifier).delete();
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Resume deleted successfully')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final resumeAsync = ref.watch(resumeNotifierProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Resume'),
      ),
      body: resumeAsync.when(
        data: (resume) {
          if (resume == null) {
            return _buildEmptyState();
          }
          return _buildResumeView(resume);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
      ),
    );
  }
  
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.description_outlined,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            const Text(
              'No Resume Uploaded',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Upload your resume to share with potential employers',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: _isUploading ? 'Uploading...' : 'Upload Resume',
              onPressed: _isUploading ? null : _pickAndUploadResume,
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildResumeView(Resume resume) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Icon(Icons.description, size: 64),
                  const SizedBox(height: 16),
                  Text(
                    resume.fileName,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Uploaded: ${resume.uploadedAt.toString().substring(0, 10)}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Size: ${resume.formattedFileSize}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          text: 'View Resume',
                          onPressed: () => _viewResume(resume.fileUrl),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: _pickAndUploadResume,
                    child: const Text('Update Resume'),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: _deleteResume,
                    child: const Text(
                      'Delete Resume',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}