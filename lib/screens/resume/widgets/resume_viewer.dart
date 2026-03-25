import 'package:flutter/material.dart';
import 'package:phoenix_slack/data/model/resume/resume.dart';
import 'package:phoenix_slack/utills/date_time_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class ResumeViewer extends StatelessWidget {
  final Resume resume;
  
  const ResumeViewer({
    super.key,
    required this.resume,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.description, size: 40),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        resume.fileName,
                        style: Theme.of(context).textTheme.titleMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Uploaded: ${DateTimeUtils.formatDate(resume.uploadedAt)} • ${resume.formattedFileSize}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  final uri = Uri.parse(resume.fileUrl);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri);
                  }
                },
                icon: const Icon(Icons.visibility),
                label: const Text('View Resume'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}