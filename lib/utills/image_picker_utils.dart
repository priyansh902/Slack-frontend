import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phoenix_slack/utills/permission_utils.dart';

class ImagePickerUtils {
  static final ImagePicker _picker = ImagePicker();
  
  static Future<File?> pickImageFromCamera() async {
    final hasPermission = await PermissionUtils.requestCameraPermission();
    if (!hasPermission) return null;
    
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }
  
  static Future<File?> pickImageFromGallery() async {
    final hasPermission = await PermissionUtils.requestGalleryPermission();
    if (!hasPermission) return null;
    
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }
  
  static Future<File?> pickImage(BuildContext context) async {
    return await showDialog<File>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Image'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () async {
                Navigator.pop(context);
                final file = await pickImageFromCamera();
                if (file != null) {
                  Navigator.pop(context, file);
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () async {
                Navigator.pop(context);
                final file = await pickImageFromGallery();
                if (file != null) {
                  Navigator.pop(context, file);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}