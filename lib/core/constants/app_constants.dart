class AppConstants {
  static const String appName = 'Phoenix-Slack';
  static const String appVersion = '1.0.0';
  
  // Validation
  static const int minPasswordLength = 6;
  static const int minSearchLength = 2;
  static const int maxFileSizeMB = 5;
  static const int maxFileSizeBytes = 5 * 1024 * 1024; // 5MB
  
  // File types
  static const List<String> allowedFileTypes = ['pdf'];
  
  // Cache keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  static const String themeKey = 'theme_mode';
  
  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 50;
  
  // Timeouts
  static const int connectionTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds
}