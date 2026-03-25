// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_service.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _ApiService implements ApiService {
  _ApiService(this._dio, {this.baseUrl}) {
    baseUrl ??= 'http://localhost:8080';
  }

  final Dio _dio;
  String? baseUrl;

  @override
  Future<LoginResponse> login(LoginRequest request) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(request.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(_setStreamType<LoginResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    ).compose(_dio.options, '/api/users/login',
        queryParameters: queryParameters, data: _data)));
    final value = LoginResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<RegisterResponse> register(RegisterRequest request) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(request.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(_setStreamType<RegisterResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    ).compose(_dio.options, '/api/users/register',
        queryParameters: queryParameters, data: _data)));
    final value = RegisterResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<User> getCurrentUser() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(_setStreamType<User>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    ).compose(_dio.options, '/api/users/me',
        queryParameters: queryParameters, data: _data)));
    final value = User.fromJson(_result.data!);
    return value;
  }
  
  @override
  Future<Map<String, dynamic>> adminDeleteProfile(int profileId) {
    // TODO: implement adminDeleteProfile
    throw UnimplementedError();
  }
  
  @override
  Future<Map<String, dynamic>> adminDeleteProject(int projectId) {
    // TODO: implement adminDeleteProject
    throw UnimplementedError();
  }
  
  @override
  Future<Map<String, dynamic>> adminDeleteResume(int resumeId) {
    // TODO: implement adminDeleteResume
    throw UnimplementedError();
  }
  
  @override
  Future<Map<String, dynamic>> checkPortfolioExists(String username) {
    // TODO: implement checkPortfolioExists
    throw UnimplementedError();
  }
  
  @override
  Future<Profile> createOrUpdateProfile(ProfileRequest request) {
    // TODO: implement createOrUpdateProfile
    throw UnimplementedError();
  }
  
  @override
  Future<Project> createProject(ProjectRequest request) {
    // TODO: implement createProject
    throw UnimplementedError();
  }
  
  @override
  Future<Map<String, dynamic>> deleteMyProfile() {
    // TODO: implement deleteMyProfile
    throw UnimplementedError();
  }
  
  @override
  Future<Map<String, dynamic>> deleteMyResume() {
    // TODO: implement deleteMyResume
    throw UnimplementedError();
  }
  
  @override
  Future<Map<String, dynamic>> deleteProject(int projectId) {
    // TODO: implement deleteProject
    throw UnimplementedError();
  }
  
  @override
  Future<Map<String, dynamic>> getAllProfiles() {
    // TODO: implement getAllProfiles
    throw UnimplementedError();
  }
  
  @override
  Future<Map<String, dynamic>> getAllProfilesAdmin() {
    // TODO: implement getAllProfilesAdmin
    throw UnimplementedError();
  }
  
  @override
  Future<Map<String, dynamic>> getAllProjectsAdmin() {
    // TODO: implement getAllProjectsAdmin
    throw UnimplementedError();
  }
  
  @override
  Future<List<Map<String, dynamic>>> getAllUsersAdmin() {
    // TODO: implement getAllUsersAdmin
    throw UnimplementedError();
  }
  
  @override
  Future<Profile> getMyProfile() {
    // TODO: implement getMyProfile
    throw UnimplementedError();
  }
  
  @override
  Future<Map<String, dynamic>> getMyProjects() {
    // TODO: implement getMyProjects
    throw UnimplementedError();
  }
  
  @override
  Future<Map<String, dynamic>> getMyResume() {
    // TODO: implement getMyResume
    throw UnimplementedError();
  }
  
  @override
  Future<Map<String, dynamic>> getPortfolio(String username) {
    // TODO: implement getPortfolio
    throw UnimplementedError();
  }
  
  @override
  Future<Profile> getProfileByUserId(int userId) {
    // TODO: implement getProfileByUserId
    throw UnimplementedError();
  }
  
  @override
  Future<Profile> getProfileByUsername(String username) {
    // TODO: implement getProfileByUsername
    throw UnimplementedError();
  }
  
  @override
  Future<Project> getProjectById(int projectId) {
    // TODO: implement getProjectById
    throw UnimplementedError();
  }
  
  @override
  Future<Map<String, dynamic>> getProjectsByUserId(int userId) {
    // TODO: implement getProjectsByUserId
    throw UnimplementedError();
  }
  
  @override
  Future<Map<String, dynamic>> getProjectsByUsername(String username) {
    // TODO: implement getProjectsByUsername
    throw UnimplementedError();
  }
  
  @override
  Future<Map<String, dynamic>> getRecentProjects() {
    // TODO: implement getRecentProjects
    throw UnimplementedError();
  }
  
  @override
  Future<Map<String, dynamic>> getRecentUsers(int limit) {
    // TODO: implement getRecentUsers
    throw UnimplementedError();
  }
  
  @override
  Future<Map<String, dynamic>> getResumeByUserId(int userId) {
    // TODO: implement getResumeByUserId
    throw UnimplementedError();
  }
  
  @override
  Future<Map<String, dynamic>> getResumeByUsername(String username) {
    // TODO: implement getResumeByUsername
    throw UnimplementedError();
  }
  
  @override
  Future<Map<String, dynamic>> getSuggestions(String query) {
    // TODO: implement getSuggestions
    throw UnimplementedError();
  }
  
  @override
  Future<Map<String, dynamic>> getUserByExactUsername(String username) {
    // TODO: implement getUserByExactUsername
    throw UnimplementedError();
  }
  
  @override
  Future<Map<String, dynamic>> getUserById(int userId) {
    // TODO: implement getUserById
    throw UnimplementedError();
  }
  
  @override
  Future<Map<String, dynamic>> getUserStats(int userId) {
    // TODO: implement getUserStats
    throw UnimplementedError();
  }
  
  @override
  Future<Map<String, dynamic>> makeAdmin(int userId) {
    // TODO: implement makeAdmin
    throw UnimplementedError();
  }
  
  @override
  Future<Map<String, dynamic>> portfolioHealth() {
    // TODO: implement portfolioHealth
    throw UnimplementedError();
  }
  
  @override
  Future<Map<String, dynamic>> removeAdmin(int userId) {
    // TODO: implement removeAdmin
    throw UnimplementedError();
  }
  
  @override
  Future<Map<String, dynamic>> searchByKeyword(String keyword) {
    // TODO: implement searchByKeyword
    throw UnimplementedError();
  }
  
  @override
  Future<Map<String, dynamic>> searchByName(String query) {
    // TODO: implement searchByName
    throw UnimplementedError();
  }
  
  @override
  Future<Map<String, dynamic>> searchByUsername(String query) {
    // TODO: implement searchByUsername
    throw UnimplementedError();
  }
  
  @override
  Future<Map<String, dynamic>> searchProjectsByTech(String tech) {
    // TODO: implement searchProjectsByTech
    throw UnimplementedError();
  }
  
  @override
  Future<Map<String, dynamic>> searchProjectsByTitle(String query) {
    // TODO: implement searchProjectsByTitle
    throw UnimplementedError();
  }
  
  @override
  Future<Project> updateProject(int projectId, ProjectRequest request) {
    // TODO: implement updateProject
    throw UnimplementedError();
  }
  
  @override
  Future<Map<String, dynamic>> uploadResume(MultipartFile file) {
    // TODO: implement uploadResume
    throw UnimplementedError();
  }

  // Add other methods as needed...
}

RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
  if (T != dynamic && !(requestOptions.responseType == ResponseType.bytes ||
      requestOptions.responseType == ResponseType.stream)) {
    if (T == String) {
      requestOptions.responseType = ResponseType.plain;
    } else {
      requestOptions.responseType = ResponseType.json;
    }
  }
  return requestOptions;
}