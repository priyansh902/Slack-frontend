class Environment {
  static const bool isProduction = bool.fromEnvironment('dart.vm.product');
  
  static String get baseUrl {
    if (isProduction) {
      return 'https://api.devconnect.com'; // Production URL
    } else {
      return 'http://localhost:8080'; // Development URL
    }
  }
  
  static String get appName {
    return 'Phoenix Slack';
  }
  
  static String get appVersion {
    return '1.0.0';
  }
  
  static bool get enableLogging {
    return !isProduction;
  }
  
  static bool get enableAnalytics {
    return isProduction;
  }
}