class AppConstants {
  static const String appName = 'DevConnect';
  static const String appVersion = '1.0.0';
  static const int defaultPageSize = 20;
  static const int maxBioLength = 500;
  static const int maxSkillLength = 500;
  static const int maxProjectTitleLength = 100;
  static const int maxProjectDescriptionLength = 1000;
  static const int maxTechStackLength = 500;
  
  // File upload limits
  static const int maxResumeSize = 5 * 1024 * 1024; // 5MB
  static const List<String> allowedResumeTypes = ['application/pdf'];
  static const List<String> allowedResumeExtensions = ['pdf'];
  
  // Cache keys
  static const String cacheKeyRecentProjects = 'recent_projects';
  static const String cacheKeyMyProfile = 'my_profile';
  static const String cacheKeyMyProjects = 'my_projects';
  static const String cacheKeyMyResume = 'my_resume';
  
  // Animation durations
  static const Duration fadeInDuration = Duration(milliseconds: 300);
  static const Duration slideDuration = Duration(milliseconds: 250);
  
  // Error messages
  static const String networkError = 'Network connection failed';
  static const String serverError = 'Server error occurred';
  static const String unauthorizedError = 'Session expired. Please login again';
  static const String notFoundError = 'Resource not found';
  static const String validationError = 'Please check your input';
}