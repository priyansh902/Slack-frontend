import 'package:url_launcher/url_launcher.dart';

class UrlLauncherUtils {
  static Future<void> launchUrl(String url) async {
    try {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        print('Could not launch $url');
      }
    } catch (e) {
      print('Error launching URL: $e');
    }
  }
  
  static Future<void> launchEmail(String email) async {
    final url = 'mailto:$email';
    if (await canLaunch(url)) {
      await launch(url);
    }
  }
  
  static Future<void> launchPhone(String phone) async {
    final url = 'tel:$phone';
    if (await canLaunch(url)) {
      await launch(url);
    }
  }
  
  static Future<void> launchWebsite(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }
  
  static Future<void> launchGitHub(String username) async {
    final url = 'https://github.com/$username';
    if (await canLaunch(url)) {
      await launch(url);
    }
  }
  
  static Future<void> launchLinkedIn(String username) async {
    final url = 'https://linkedin.com/in/$username';
    if (await canLaunch(url)) {
      await launch(url);
    }
  }
  
  static Future<void> launchTwitter(String username) async {
    final url = 'https://twitter.com/$username';
    if (await canLaunch(url)) {
      await launch(url);
    }
  }
}