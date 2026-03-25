import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerDialog extends StatelessWidget {
  final Function(ImageSource) onImageSelected;
  
  const ImagePickerDialog({
    super.key,
    required this.onImageSelected,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Choose Image'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Camera'),
            onTap: () {
              Navigator.pop(context);
              onImageSelected(ImageSource.camera);
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Gallery'),
            onTap: () {
              Navigator.pop(context);
              onImageSelected(ImageSource.gallery);
            },
          ),
        ],
      ),
    );
  }
}