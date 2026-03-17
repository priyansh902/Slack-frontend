class ApiEndpoints {
  static const String baseUrl = 'http://localhost:8080/api';
  
  // Auth
  static const String register = '/users/register';
  static const String login = '/users/login';
  static const String me = '/users/me';
  
  // Profile
  static const String profile = '/profiles/me';
  static const String profileByUsername = '/profiles/username';
  static const String profileByUserId = '/profiles/user';
  static const String allProfiles = '/profiles/all';
  static const String adminProfiles = '/profiles/admin/all';
  
  // Projects
  static const String projects = '/projects';
  static const String myProjects = '/projects/me';
  static const String projectsByUser = '/projects/user';
  static const String projectsByUsername = '/projects/username';
  static const String searchProjectsByTitle = '/projects/search/title';
  static const String searchProjectsByTech = '/projects/search/tech';
  static const String recentProjects = '/projects/recent';
  static const String adminProjects = '/projects/admin/all';
  
  // Resume
  static const String resumeUpload = '/resumes/upload';
  static const String myResume = '/resumes/me';
  static const String resumeByUser = '/resumes/user';
  static const String resumeByUsername = '/resumes/username';
  static const String adminResumes = '/resumes/admin/all';
  
  // Search
  static const String searchByUsername = '/search/username';
  static const String searchByName = '/search/name';
  static const String searchByKeyword = '/search/keyword';
  static const String searchSuggestions = '/search/suggestions';
  static const String recentUsers = '/search/recent';
  
  // Portfolio
  static const String portfolio = '/portfolio';
  static const String portfolioExists = '/portfolio/exists';
  static const String portfolioHealth = '/portfolio/health';
}