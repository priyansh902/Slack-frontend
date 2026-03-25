import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:phoenix_slack/core/constants/api_constants.dart';
import 'package:phoenix_slack/data/model/profile/profile.dart';
import 'package:phoenix_slack/data/model/project/project.dart';
import 'package:phoenix_slack/data/model/user/user.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;
  
  // ========== USER CONTROLLER ==========
  @POST(ApiConstants.login)
  Future<LoginResponse> login(@Body() LoginRequest request);
  
  @POST(ApiConstants.register)
  Future<RegisterResponse> register(@Body() RegisterRequest request);
  
  @GET(ApiConstants.getCurrentUser)
  Future<User> getCurrentUser();
  
  // ========== PROFILE CONTROLLER ==========
  @GET(ApiConstants.getMyProfile)
  Future<Profile> getMyProfile();
  
  @POST(ApiConstants.createUpdateProfile)
  Future<Profile> createOrUpdateProfile(@Body() ProfileRequest request);
  
  @DELETE(ApiConstants.deleteMyProfile)
  Future<Map<String, dynamic>> deleteMyProfile();
  
  @GET('${ApiConstants.getProfileByUsername}/{username}')
  Future<Profile> getProfileByUsername(@Path('username') String username);
  
  @GET('${ApiConstants.getProfileByUserId}/{userId}')
  Future<Profile> getProfileByUserId(@Path('userId') int userId);
  
  @GET(ApiConstants.getAllProfiles)
  Future<Map<String, dynamic>> getAllProfiles();
  
  // ========== PROJECT CONTROLLER ==========
  @GET(ApiConstants.getMyProjects)
  Future<Map<String, dynamic>> getMyProjects();
  
  @GET('${ApiConstants.getProjectsByUsername}/{username}')
  Future<Map<String, dynamic>> getProjectsByUsername(@Path('username') String username);
  
  @GET('${ApiConstants.getProjectsByUserId}/{userId}')
  Future<Map<String, dynamic>> getProjectsByUserId(@Path('userId') int userId);
  
  @GET('${ApiConstants.getProjectById}/{projectId}')
  Future<Project> getProjectById(@Path('projectId') int projectId);
  
  @POST(ApiConstants.createProject)
  Future<Project> createProject(@Body() ProjectRequest request);
  
  @PUT('${ApiConstants.updateProject}/{projectId}')
  Future<Project> updateProject(
    @Path('projectId') int projectId,
    @Body() ProjectRequest request,
  );
  
  @DELETE('${ApiConstants.deleteProject}/{projectId}')
  Future<Map<String, dynamic>> deleteProject(@Path('projectId') int projectId);
  
  @GET(ApiConstants.searchProjectsByTitle)
  Future<Map<String, dynamic>> searchProjectsByTitle(@Query('query') String query);
  
  @GET(ApiConstants.searchProjectsByTech)
  Future<Map<String, dynamic>> searchProjectsByTech(@Query('tech') String tech);
  
  @GET(ApiConstants.getRecentProjects)
  Future<Map<String, dynamic>> getRecentProjects();
  
  // ========== RESUME CONTROLLER ==========
  @POST(ApiConstants.uploadResume)
  @MultiPart()
  Future<Map<String, dynamic>> uploadResume(@Part() MultipartFile file);
  
  @GET(ApiConstants.getMyResume)
  Future<Map<String, dynamic>> getMyResume();
  
  @DELETE(ApiConstants.deleteMyResume)
  Future<Map<String, dynamic>> deleteMyResume();
  
  @GET('${ApiConstants.getResumeByUsername}/{username}')
  Future<Map<String, dynamic>> getResumeByUsername(@Path('username') String username);
  
  @GET('${ApiConstants.getResumeByUserId}/{userId}')
  Future<Map<String, dynamic>> getResumeByUserId(@Path('userId') int userId);
  
  // ========== SEARCH CONTROLLER ==========
  @GET(ApiConstants.searchByUsername)
  Future<Map<String, dynamic>> searchByUsername(@Query('query') String query);
  
  @GET(ApiConstants.searchByName)
  Future<Map<String, dynamic>> searchByName(@Query('query') String query);
  
  @GET(ApiConstants.searchByKeyword)
  Future<Map<String, dynamic>> searchByKeyword(@Query('keyword') String keyword);
  
  @GET(ApiConstants.getSuggestions)
  Future<Map<String, dynamic>> getSuggestions(@Query('query') String query);
  
  @GET(ApiConstants.getRecentUsers)
  Future<Map<String, dynamic>> getRecentUsers(@Query('limit') int limit);
  
  @GET('${ApiConstants.getUserById}/{userId}')
  Future<Map<String, dynamic>> getUserById(@Path('userId') int userId);
  
  @GET('${ApiConstants.getUserByExactUsername}/{username}')
  Future<Map<String, dynamic>> getUserByExactUsername(@Path('username') String username);

  @GET('${ApiConstants.getUserStats}/{userId}')
  Future<Map<String, dynamic>> getUserStats(@Path('userId') int userId);
  
  // ========== PORTFOLIO CONTROLLER ==========
  @GET('${ApiConstants.getPortfolio}/{username}')
  Future<Map<String, dynamic>> getPortfolio(@Path('username') String username);
  
  @GET('${ApiConstants.checkPortfolioExists}/{username}')
  Future<Map<String, dynamic>> checkPortfolioExists(@Path('username') String username);
  
  @GET(ApiConstants.portfolioHealth)
  Future<Map<String, dynamic>> portfolioHealth();
  
  // ========== ADMIN CONTROLLER ==========
  @GET(ApiConstants.getAllUsersAdmin)
  Future<List<Map<String, dynamic>>> getAllUsersAdmin();
  
  @POST('${ApiConstants.makeAdmin}/{userId}/make-admin')
  Future<Map<String, dynamic>> makeAdmin(@Path('userId') int userId);
  
  @DELETE('${ApiConstants.removeAdmin}/{userId}/remove-admin')
  Future<Map<String, dynamic>> removeAdmin(@Path('userId') int userId);
  
  @GET(ApiConstants.getAllProjectsAdmin)
  Future<Map<String, dynamic>> getAllProjectsAdmin();
  
  @DELETE('${ApiConstants.adminDeleteProject}/{projectId}')
  Future<Map<String, dynamic>> adminDeleteProject(@Path('projectId') int projectId);
  
  @DELETE('${ApiConstants.adminDeleteResume}/{resumeId}')
  Future<Map<String, dynamic>> adminDeleteResume(@Path('resumeId') int resumeId);
  
  @GET(ApiConstants.getAllProfilesAdmin)
  Future<Map<String, dynamic>> getAllProfilesAdmin();
  
  @DELETE('${ApiConstants.adminDeleteProfile}/{profileId}')
  Future<Map<String, dynamic>> adminDeleteProfile(@Path('profileId') int profileId);
}