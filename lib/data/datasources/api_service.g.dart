// MANUALLY IMPLEMENTED - build_runner not available in this environment
part of 'api_service.dart';

class _ApiService implements ApiService {
  _ApiService(this._dio, {this.baseUrl}) {
    baseUrl ??= 'http://localhost:8080';
  }

  final Dio _dio;
  String? baseUrl;

  // ── helpers ──────────────────────────────────────────────────────────────

  Options _opts(String method) => Options(method: method,
    responseType: ResponseType.json);

  String _base() => baseUrl ?? 'http://localhost:8080';

  // ── USER ─────────────────────────────────────────────────────────────────

  @override
  Future<LoginResponse> login(LoginRequest request) async {
    final r = await _dio.request<Map<String, dynamic>>(
      '${_base()}/api/users/login',
      data: request.toJson(),
      options: _opts('POST'),
    );
    return LoginResponse.fromJson(r.data!);
  }

  @override
  Future<RegisterResponse> register(RegisterRequest request) async {
    final r = await _dio.request<Map<String, dynamic>>(
      '${_base()}/api/users/register',
      data: request.toJson(),
      options: _opts('POST'),
    );
    return RegisterResponse.fromJson(r.data!);
  }

  @override
  Future<User> getCurrentUser() async {
    final r = await _dio.request<Map<String, dynamic>>(
      '${_base()}/api/users/me',
      options: _opts('GET'),
    );
    return User.fromJson(r.data!);
  }

  // ── PROFILE ──────────────────────────────────────────────────────────────

  @override
  Future<Profile> getMyProfile() async {
    final r = await _dio.request<Map<String, dynamic>>(
      '${_base()}/api/profiles/me',
      options: _opts('GET'),
    );
    return Profile.fromJson(r.data!);
  }

  @override
  Future<Profile> createOrUpdateProfile(ProfileRequest request) async {
    final r = await _dio.request<Map<String, dynamic>>(
      '${_base()}/api/profiles/me',
      data: request.toJson(),
      options: _opts('POST'),
    );
    return Profile.fromJson(r.data!);
  }

  @override
  Future<Map<String, dynamic>> deleteMyProfile() async {
    final r = await _dio.request<Map<String, dynamic>>(
      '${_base()}/api/profiles/me',
      options: _opts('DELETE'),
    );
    return r.data ?? {};
  }

  @override
  Future<Profile> getProfileByUsername(String username) async {
    final r = await _dio.request<Map<String, dynamic>>(
      '${_base()}/api/profiles/username/$username',
      options: _opts('GET'),
    );
    return Profile.fromJson(r.data!);
  }

  @override
  Future<Profile> getProfileByUserId(int userId) async {
    final r = await _dio.request<Map<String, dynamic>>(
      '${_base()}/api/profiles/user/$userId',
      options: _opts('GET'),
    );
    return Profile.fromJson(r.data!);
  }

  @override
  Future<Map<String, dynamic>> getAllProfiles() async {
    final r = await _dio.request<Map<String, dynamic>>(
      '${_base()}/api/profiles/all',
      options: _opts('GET'),
    );
    return r.data ?? {};
  }

  // ── PROJECTS ─────────────────────────────────────────────────────────────

  @override
  Future<Map<String, dynamic>> getMyProjects() async {
    final r = await _dio.request<Map<String, dynamic>>(
      '${_base()}/api/projects/me',
      options: _opts('GET'),
    );
    return r.data ?? {};
  }

  @override
  Future<Map<String, dynamic>> getProjectsByUsername(String username) async {
    final r = await _dio.request<Map<String, dynamic>>(
      '${_base()}/api/projects/username/$username',
      options: _opts('GET'),
    );
    return r.data ?? {};
  }

  @override
  Future<Map<String, dynamic>> getProjectsByUserId(int userId) async {
    final r = await _dio.request<Map<String, dynamic>>(
      '${_base()}/api/projects/user/$userId',
      options: _opts('GET'),
    );
    return r.data ?? {};
  }

  @override
  Future<Project> getProjectById(int projectId) async {
    final r = await _dio.request<Map<String, dynamic>>(
      '${_base()}/api/projects/$projectId',
      options: _opts('GET'),
    );
    return Project.fromJson(r.data!);
  }

  @override
  Future<Project> createProject(ProjectRequest request) async {
    final r = await _dio.request<Map<String, dynamic>>(
      '${_base()}/api/projects',
      data: request.toJson(),
      options: _opts('POST'),
    );
    return Project.fromJson(r.data!);
  }

  @override
  Future<Project> updateProject(int projectId, ProjectRequest request) async {
    final r = await _dio.request<Map<String, dynamic>>(
      '${_base()}/api/projects/$projectId',
      data: request.toJson(),
      options: _opts('PUT'),
    );
    return Project.fromJson(r.data!);
  }

  @override
  Future<Map<String, dynamic>> deleteProject(int projectId) async {
    final r = await _dio.request<Map<String, dynamic>>(
      '${_base()}/api/projects/$projectId',
      options: _opts('DELETE'),
    );
    return r.data ?? {};
  }

  @override
  Future<Map<String, dynamic>> searchProjectsByTitle(String query) async {
    final r = await _dio.request<Map<String, dynamic>>(
      '${_base()}/api/projects/search/title',
      queryParameters: {'query': query},
      options: _opts('GET'),
    );
    return r.data ?? {};
  }

  @override
  Future<Map<String, dynamic>> searchProjectsByTech(String tech) async {
    final r = await _dio.request<Map<String, dynamic>>(
      '${_base()}/api/projects/search/tech',
      queryParameters: {'tech': tech},
      options: _opts('GET'),
    );
    return r.data ?? {};
  }

  @override
  Future<Map<String, dynamic>> getRecentProjects() async {
    final r = await _dio.request<Map<String, dynamic>>(
      '${_base()}/api/projects/recent',
      options: _opts('GET'),
    );
    return r.data ?? {};
  }

  // ── RESUME ───────────────────────────────────────────────────────────────

  @override
  Future<Map<String, dynamic>> uploadResume(MultipartFile file) async {
    final formData = FormData.fromMap({'file': file});
    final r = await _dio.request<Map<String, dynamic>>(
      '${_base()}/api/resumes/upload',
      data: formData,
      options: _opts('POST'),
    );
    return r.data ?? {};
  }

  @override
  Future<Map<String, dynamic>> getMyResume() async {
    final r = await _dio.request<Map<String, dynamic>>(
      '${_base()}/api/resumes/me',
      options: _opts('GET'),
    );
    return r.data ?? {};
  }

  @override
  Future<Map<String, dynamic>> deleteMyResume() async {
    final r = await _dio.request<Map<String, dynamic>>(
      '${_base()}/api/resumes/me',
      options: _opts('DELETE'),
    );
    return r.data ?? {};
  }

  @override
  Future<Map<String, dynamic>> getResumeByUsername(String username) async {
    final r = await _dio.request<Map<String, dynamic>>(
      '${_base()}/api/resumes/username/$username',
      options: _opts('GET'),
    );
    return r.data ?? {};
  }

  @override
  Future<Map<String, dynamic>> getResumeByUserId(int userId) async {
    final r = await _dio.request<Map<String, dynamic>>(
      '${_base()}/api/resumes/user/$userId',
      options: _opts('GET'),
    );
    return r.data ?? {};
  }

  // ── SEARCH ───────────────────────────────────────────────────────────────

  @override
  Future<Map<String, dynamic>> searchByUsername(String query) async {
    final r = await _dio.request<Map<String, dynamic>>(
      '${_base()}/api/search/username',
      queryParameters: {'query': query},
      options: _opts('GET'),
    );
    return r.data ?? {};
  }

  @override
  Future<Map<String, dynamic>> searchByName(String query) async {
    final r = await _dio.request<Map<String, dynamic>>(
      '${_base()}/api/search/name',
      queryParameters: {'query': query},
      options: _opts('GET'),
    );
    return r.data ?? {};
  }

  @override
  Future<Map<String, dynamic>> searchByKeyword(String keyword) async {
    final r = await _dio.request<Map<String, dynamic>>(
      '${_base()}/api/search/keyword',
      queryParameters: {'keyword': keyword},
      options: _opts('GET'),
    );
    return r.data ?? {};
  }

  @override
  Future<Map<String, dynamic>> getSuggestions(String query) async {
    final r = await _dio.request<Map<String, dynamic>>(
      '${_base()}/api/search/suggestions',
      queryParameters: {'query': query},
      options: _opts('GET'),
    );
    return r.data ?? {};
  }

  @override
  Future<Map<String, dynamic>> getRecentUsers(int limit) async {
    final r = await _dio.request<Map<String, dynamic>>(
      '${_base()}/api/search/recent',
      queryParameters: {'limit': limit},
      options: _opts('GET'),
    );
    return r.data ?? {};
  }

  @override
  Future<Map<String, dynamic>> getUserById(int userId) async {
    final r = await _dio.request<Map<String, dynamic>>(
      '${_base()}/api/search/user/id/$userId',
      options: _opts('GET'),
    );
    return r.data ?? {};
  }

  @override
  Future<Map<String, dynamic>> getUserByExactUsername(String username) async {
    final r = await _dio.request<Map<String, dynamic>>(
      '${_base()}/api/search/user/username/$username',
      options: _opts('GET'),
    );
    return r.data ?? {};
  }

  @override
  Future<Map<String, dynamic>> getUserStats(int userId) async {
    final r = await _dio.request<Map<String, dynamic>>(
      '${_base()}/api/search/stats/$userId',
      options: _opts('GET'),
    );
    return r.data ?? {};
  }

  // ── PORTFOLIO ─────────────────────────────────────────────────────────────

  @override
  Future<Map<String, dynamic>> getPortfolio(String username) async {
    final r = await _dio.request<Map<String, dynamic>>(
      '${_base()}/api/portfolio/$username',
      options: _opts('GET'),
    );
    return r.data ?? {};
  }

  @override
  Future<Map<String, dynamic>> checkPortfolioExists(String username) async {
    final r = await _dio.request<Map<String, dynamic>>(
      '${_base()}/api/portfolio/exists/$username',
      options: _opts('GET'),
    );
    return r.data ?? {};
  }

  @override
  Future<Map<String, dynamic>> portfolioHealth() async {
    final r = await _dio.request<Map<String, dynamic>>(
      '${_base()}/api/portfolio/health',
      options: _opts('GET'),
    );
    return r.data ?? {};
  }

  // ── ADMIN ─────────────────────────────────────────────────────────────────

  @override
  Future<List<Map<String, dynamic>>> getAllUsersAdmin() async {
    final r = await _dio.request<List<dynamic>>(
      '${_base()}/api/admin/users',
      options: Options(method: 'GET', responseType: ResponseType.json),
    );
    return (r.data as List).cast<Map<String, dynamic>>();
  }

  @override
  Future<Map<String, dynamic>> makeAdmin(int userId) async {
    final r = await _dio.request<Map<String, dynamic>>(
      '${_base()}/api/admin/users/$userId/make-admin',
      options: _opts('POST'),
    );
    return r.data ?? {};
  }

  @override
  Future<Map<String, dynamic>> removeAdmin(int userId) async {
    final r = await _dio.request<Map<String, dynamic>>(
      '${_base()}/api/admin/users/$userId/remove-admin',
      options: _opts('DELETE'),
    );
    return r.data ?? {};
  }

  @override
  Future<Map<String, dynamic>> getAllProjectsAdmin() async {
    final r = await _dio.request<Map<String, dynamic>>(
      '${_base()}/api/projects/admin/all',
      options: _opts('GET'),
    );
    return r.data ?? {};
  }

  @override
  Future<Map<String, dynamic>> adminDeleteProject(int projectId) async {
    final r = await _dio.request<Map<String, dynamic>>(
      '${_base()}/api/projects/admin/$projectId',
      options: _opts('DELETE'),
    );
    return r.data ?? {};
  }

  @override
  Future<Map<String, dynamic>> adminDeleteResume(int resumeId) async {
    final r = await _dio.request<Map<String, dynamic>>(
      '${_base()}/api/resumes/admin/$resumeId',
      options: _opts('DELETE'),
    );
    return r.data ?? {};
  }

  @override
  Future<Map<String, dynamic>> getAllProfilesAdmin() async {
    final r = await _dio.request<Map<String, dynamic>>(
      '${_base()}/api/profiles/admin/all',
      options: _opts('GET'),
    );
    return r.data ?? {};
  }

  @override
  Future<Map<String, dynamic>> adminDeleteProfile(int profileId) async {
    final r = await _dio.request<Map<String, dynamic>>(
      '${_base()}/api/profiles/admin/$profileId',
      options: _opts('DELETE'),
    );
    return r.data ?? {};
  }
}

RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
  if (T != dynamic &&
      !(requestOptions.responseType == ResponseType.bytes ||
          requestOptions.responseType == ResponseType.stream)) {
    if (T == String) {
      requestOptions.responseType = ResponseType.plain;
    } else {
      requestOptions.responseType = ResponseType.json;
    }
  }
  return requestOptions;
}
