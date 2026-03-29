class ApiConstants {
  // ── Change to 10.0.2.2:8080 for Android emulator, or your LAN IP for real device ──
  static const String baseUrl = 'http://localhost:8080';

  static const String login            = '/api/users/login';
  static const String register         = '/api/users/register';
  static const String getCurrentUser   = '/api/users/me';

  static const String getMyProfile          = '/api/profiles/me';
  static const String createUpdateProfile   = '/api/profiles/me';
  static const String deleteMyProfile       = '/api/profiles/me';
  static const String getProfileByUsername  = '/api/profiles/username';
  static const String getProfileByUserId    = '/api/profiles/user';
  static const String getAllProfiles        = '/api/profiles/all';
  static const String getAllProfilesAdmin   = '/api/profiles/admin/all';
  static const String adminDeleteProfile   = '/api/profiles/admin';

  static const String createProject         = '/api/projects';
  static const String getProjectById        = '/api/projects';
  static const String updateProject         = '/api/projects';
  static const String deleteProject         = '/api/projects';
  static const String getMyProjects         = '/api/projects/me';
  static const String getProjectsByUsername = '/api/projects/username';
  static const String getProjectsByUserId   = '/api/projects/user';
  static const String searchProjectsByTitle = '/api/projects/search/title';
  static const String searchProjectsByTech  = '/api/projects/search/tech';
  static const String getRecentProjects     = '/api/projects/recent';
  static const String getAllProjectsAdmin   = '/api/projects/admin/all';
  static const String adminDeleteProject   = '/api/projects/admin';

  static const String uploadResume       = '/api/resumes/upload';
  static const String getMyResume        = '/api/resumes/me';
  static const String deleteMyResume     = '/api/resumes/me';
  static const String getResumeByUserId  = '/api/resumes/user';
  static const String getResumeByUsername= '/api/resumes/username';
  static const String getAllResumesAdmin  = '/api/resumes/admin/all';
  static const String adminDeleteResume  = '/api/resumes/admin';

  static const String searchByUsername      = '/api/search/username';
  static const String searchByName          = '/api/search/name';
  static const String searchByKeyword       = '/api/search/keyword';
  static const String getSuggestions        = '/api/search/suggestions';
  static const String getRecentUsers        = '/api/search/recent';
  static const String getUserById           = '/api/search/user/id';
  static const String getUserByExactUsername= '/api/search/user/username';
  static const String getUserStats          = '/api/search/stats';

  static const String getPortfolio          = '/api/portfolio';
  static const String checkPortfolioExists  = '/api/portfolio/exists';
  static const String portfolioHealth       = '/api/portfolio/health';

  static const String makeAdmin             = '/api/admin/users';
  static const String removeAdmin           = '/api/admin/users';
  static const String getAllUsersAdmin       = '/api/admin/users';

  static const String authorization  = 'Authorization';
  static const String contentType    = 'Content-Type';
  static const String applicationJson= 'application/json';
}
