import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Helpers {
  static void showSnackBar(BuildContext context, String message,
      {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  static String formatDateTime(DateTime date) {
    return DateFormat('dd MMM yyyy, hh:mm a').format(date);
  }

  static String timeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} years ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} months ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }

  static List<String> parseSkills(String skillsString) {
    if (skillsString.isEmpty) return [];
    return skillsString
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
  }

  static String formatFileSize(int bytes) {
    if (bytes <= 0) return '0 B';
    const suffixes = ['B', 'KB', 'MB', 'GB'];
    var i = (bytes.log(1024) / 1024.log(1024)).floor();
    return '${(bytes / (1024).pow(i)).toStringAsFixed(1)} ${suffixes[i]}';
  }

  static Map<String, dynamic> decodeBase64(String encoded) {
    try {
      final decoded = utf8.decode(base64.decode(encoded));
      return json.decode(decoded);
    } catch (e) {
      return {};
    }
  }
}