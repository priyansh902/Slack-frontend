import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import '../../providers/resume_provider.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/common/error_widget.dart';
import '../../widgets/navigation/bottom_nav_bar.dart';
import '../../widgets/navigation/app_drawer.dart';
import 'widgets/upload_button.dart';
import 'widgets/pdf_viewer.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/helpers.dart';

class ResumeScreen extends StatefulWidget {
  const ResumeScreen({super.key});

  @override
  State<ResumeScreen> createState() => _ResumeScreenState();
}

class _ResumeScreenState extends State<ResumeScreen> {
  int _currentIndex = 3;

  @override
  void initState() {
    super.initState();
    _loadResume();
  }

  Future<void> _loadResume() async {
    final resumeProvider = Provider.of<ResumeProvider>(context, listen: false);
    await resumeProvider.loadMyResume();
  }

  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: AppConstants.allowedFileTypes,
        allowMultiple: false,
      );

      if (result != null) {
        final file = File(result.files.single.path!);
        
        // Check file size
        if (await file.length() > AppConstants.maxFileSizeBytes) {
          if (mounted) {
            Helpers.showSnackBar(
              context,
              'File size exceeds ${AppConstants.maxFileSizeMB}MB limit',
              isError: true,
            );
          }
          return;
        }

        // Upload file
        final resumeProvider = Provider.of<ResumeProvider>(context, listen: false);
        final success = await resumeProvider.uploadResume(file);
        
        if (success && mounted) {
          Helpers.showSnackBar(context, 'Resume uploaded successfully');
        }
      }
    } catch (e) {
      if (mounted) {
        Helpers.showSnackBar(context, 'Failed to pick file: $e', isError: true);
      }
    }
  }

  Future<void> _handleDelete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Resume'),
        content: const Text('Are you sure you want to delete your resume?'),
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
      final resumeProvider = Provider.of<ResumeProvider>(context, listen: false);
      final success = await resumeProvider.deleteResume();
      
      if (success && mounted) {
        Helpers.showSnackBar(context, 'Resume deleted successfully');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final resumeProvider = Provider.of<ResumeProvider>(context);
    final resume = resumeProvider.resume;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Resume'),
        actions: [
          if (resume != null)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: _handleDelete,
            ),
        ],
      ),
      drawer: const AppDrawer(),
      body: resumeProvider.isLoading
          ? const LoadingIndicator()
          : resumeProvider.error != null
              ? CustomErrorWidget(
                  message: resumeProvider.error!,
                  onRetry: _loadResume,
                )
              : RefreshIndicator(
                  onRefresh: _loadResume,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (resume == null) ...[
                          const Icon(
                            Icons.upload_file,
                            size: 80,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'No Resume Uploaded',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Upload your resume (PDF only, max 5MB) to make it available for download on your portfolio.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 24),
                          UploadButton(
                            onPressed: _pickFile,
                            isLoading: resumeProvider.isLoading,
                          ),
                        ] else ...[
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  ListTile(
                                    leading: const Icon(
                                      Icons.picture_as_pdf,
                                      size: 48,
                                      color: Colors.red,
                                    ),
                                    title: Text(resume.fileName),
                                    subtitle: Text(
                                      '${resume.formattedFileSize} • Uploaded ${Helpers.timeAgo(resume.uploadedAt)}',
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: ElevatedButton.icon(
                                          onPressed: () {
                                            // Download/View resume
                                          },
                                          icon: const Icon(Icons.visibility),
                                          label: const Text('View'),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: OutlinedButton.icon(
                                          onPressed: () {
                                            // Share resume link
                                          },
                                          icon: const Icon(Icons.share),
                                          label: const Text('Share'),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Resume Preview',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            height: 400,
                            child: PdfViewer(
                              pdfUrl: resume.fileUrl,
                              fileName: resume.fileName,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          if (index == 3) return;
          _handleNavigation(index);
        },
      ),
    );
  }

  void _handleNavigation(int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/profile');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/projects');
        break;
      case 4:
        Navigator.pushReplacementNamed(context, '/search');
        break;
    }
  }
}