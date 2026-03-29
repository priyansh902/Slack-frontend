import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phoenix_slack/core/themes/app_theme.dart';
import 'package:phoenix_slack/data/model/resume/resume.dart';
import 'package:phoenix_slack/providers/resume_provider.dart';
import 'package:phoenix_slack/widgets/common/app_button.dart';
import 'package:url_launcher/url_launcher.dart';

class ResumeScreen extends ConsumerStatefulWidget {
  const ResumeScreen({super.key});
  @override ConsumerState<ResumeScreen> createState() => _S();
}
class _S extends ConsumerState<ResumeScreen> {
  bool _uploading = false;

  @override void initState() {
    super.initState();
    Future.microtask(() => ref.read(resumeNotifierProvider.notifier).loadResume());
  }

  Future<void> _pick() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        withData: true, // Always request bytes — works on both web and native
      );
      if (result == null) return;
      setState(() => _uploading = true);

      final file = result.files.first;
      MultipartFile mf;

      if (kIsWeb) {
        // On web: file.path is unavailable — use bytes
        final bytes = file.bytes;
        if (bytes == null) throw Exception('Could not read file bytes');
        mf = MultipartFile.fromBytes(bytes, filename: file.name,
          contentType: DioMediaType('application', 'pdf'));
      } else {
        // On native: use path
        mf = await MultipartFile.fromFile(file.path!, filename: file.name,
          contentType: DioMediaType('application', 'pdf'));
      }

      final ok = await ref.read(resumeNotifierProvider.notifier).upload(mf);
      setState(() => _uploading = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(ok ? 'Resume uploaded!' : 'Upload failed'),
        backgroundColor: ok ? null : AppColors.error));
    } catch (e) {
      setState(() => _uploading = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: $e'), backgroundColor: AppColors.error));
    }
  }

  Future<void> _delete() async {
    final ok = await showDialog<bool>(context: context,
      builder: (_) => const _ConfirmDialog(
        title: 'Delete Resume',
        body: 'Your resume will be permanently removed.',
        confirm: 'Delete', danger: true));
    if (ok != true) return;
    final done = await ref.read(resumeNotifierProvider.notifier).delete();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(done ? 'Resume deleted' : 'Failed to delete'),
      backgroundColor: done ? null : AppColors.error));
    }
  }

  @override
  Widget build(BuildContext context) {
    final resumeAsync = ref.watch(resumeNotifierProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('My Resume')),
      body: resumeAsync.when(
        data: (r) => r == null
          ? _Empty(onUpload: _pick, uploading: _uploading)
          : _ResumeCard(
              resume: r, uploading: _uploading,
              onView: () async {
                final uri = Uri.parse(r.fileUrl);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                }
              },
              onUpdate: _pick, onDelete: _delete),
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.accent)),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  final VoidCallback onUpload; final bool uploading;
  const _Empty({required this.onUpload, required this.uploading});
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Center(child: Padding(
      padding: const EdgeInsets.all(40),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(width: 80, height: 80,
          decoration: BoxDecoration(shape: BoxShape.circle,
            color: isDark ? AppColors.card : AppColors.lCard,
            border: Border.all(color: isDark ? AppColors.border : AppColors.lBorder)),
          child: const Icon(Icons.description_outlined, size: 36, color: AppColors.accent))
          .animate().scale(duration: 400.ms, curve: Curves.elasticOut),
        const SizedBox(height: 20),
        Text('No resume yet', style: GoogleFonts.spaceGrotesk(fontSize: 18,
          fontWeight: FontWeight.w600,
          color: isDark ? AppColors.textPri : AppColors.lTextPri)),
        const SizedBox(height: 6),
        Text('Upload a PDF to showcase your experience',
          style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center),
        const SizedBox(height: 28),
        SizedBox(width: 200,
          child: AppButton(
            text: uploading ? 'Uploading…' : 'Upload PDF',
            onPressed: uploading ? null : onUpload,
            isLoading: uploading, icon: Icons.upload_rounded)),
      ]),
    ));
  }
}

class _ResumeCard extends StatelessWidget {
  final Resume resume; final bool uploading;
  final VoidCallback onView, onUpdate, onDelete;
  const _ResumeCard({required this.resume, required this.uploading,
    required this.onView, required this.onUpdate, required this.onDelete});
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? AppColors.card : AppColors.lCard,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: isDark ? AppColors.border : AppColors.lBorder)),
          child: Column(children: [
            Container(width: 64, height: 64,
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.12),
                borderRadius: BorderRadius.circular(16)),
              child: const Icon(Icons.picture_as_pdf_rounded, size: 32, color: AppColors.error))
              .animate().scale(duration: 350.ms, curve: Curves.elasticOut),
            const SizedBox(height: 14),
            Text(resume.fileName, style: GoogleFonts.spaceGrotesk(fontSize: 16,
              fontWeight: FontWeight.w600, color: isDark ? AppColors.textPri : AppColors.lTextPri),
              textAlign: TextAlign.center),
            const SizedBox(height: 6),
            Text(resume.formattedFileSize, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 4),
            Text('Uploaded ${_fmt(resume.uploadedAt)}', style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 20),
            AppButton(text: 'View Resume', onPressed: onView, icon: Icons.open_in_new_rounded),
            const SizedBox(height: 10),
            AppButton(text: uploading ? 'Uploading…' : 'Replace PDF',
              onPressed: uploading ? null : onUpdate,
              isLoading: uploading, outlined: true, icon: Icons.upload_rounded),
            const SizedBox(height: 10),
            AppButton(text: 'Delete Resume', onPressed: onDelete,
              outlined: true, color: AppColors.error, icon: Icons.delete_outline_rounded),
          ]),
        ).animate().fadeIn(duration: 400.ms),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.accentLo,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.accent.withOpacity(0.25))),
          child: Row(children: [
            const Icon(Icons.lightbulb_outline_rounded, size: 16, color: AppColors.accent),
            const SizedBox(width: 10),
            Expanded(child: Text('Your resume URL is shared on your public portfolio.',
              style: GoogleFonts.inter(fontSize: 12, color: AppColors.accent))),
          ])).animate().fadeIn(delay: 200.ms),
      ]),
    );
  }
  String _fmt(DateTime dt) {
    const m = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return '${m[dt.month-1]} ${dt.day}, ${dt.year}';
  }
}

class _ConfirmDialog extends StatelessWidget {
  final String title, body, confirm; final bool danger;
  const _ConfirmDialog({required this.title, required this.body,
    required this.confirm, this.danger = false});
  @override
  Widget build(BuildContext context) => AlertDialog(
    backgroundColor: AppColors.card,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
    title: Text(title, style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w600)),
    content: Text(body, style: Theme.of(context).textTheme.bodyMedium),
    actions: [
      TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
      TextButton(onPressed: () => Navigator.pop(context, true),
        child: Text(confirm, style: TextStyle(color: danger ? AppColors.error : AppColors.accent))),
    ],
  );
}
