import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionUtils {
  static Future<bool> requestStoragePermission() async {
    if (await Permission.storage.isGranted) {
      return true;
    }
    
    final status = await Permission.storage.request();
    return status.isGranted;
  }
  
  static Future<bool> requestCameraPermission() async {
    if (await Permission.camera.isGranted) {
      return true;
    }
    
    final status = await Permission.camera.request();
    return status.isGranted;
  }
  
  static Future<bool> requestGalleryPermission() async {
    if (await Permission.photos.isGranted) {
      return true;
    }
    
    final status = await Permission.photos.request();
    return status.isGranted;
  }
  
  static Future<void> showPermissionDeniedDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permission Required'),
        content: const Text('Please grant the required permission in settings to use this feature.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }
}