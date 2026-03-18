import 'package:flutter/material.dart';

class ResumeButton extends StatelessWidget {
  final String resumeUrl;
  final VoidCallback onPressed;

  const ResumeButton({
    super.key,
    required this.resumeUrl,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.picture_as_pdf),
        label: const Text(
          'Download Resume',
          style: TextStyle(fontSize: 16),
        ),
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}