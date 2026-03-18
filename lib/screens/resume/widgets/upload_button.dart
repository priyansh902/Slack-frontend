import 'package:flutter/material.dart';
import '../../../widgets/common/custom_button.dart';

class UploadButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;

  const UploadButton({
    super.key,
    required this.onPressed,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: 'Upload Resume',
      onPressed: onPressed,
      isLoading: isLoading,
      icon: Icons.cloud_upload,
    );
  }
}