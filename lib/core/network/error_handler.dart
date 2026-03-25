import 'package:dio/dio.dart';

class ErrorHandler {
  static String getErrorMessage(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timeout. Please check your internet connection';
        
      case DioExceptionType.badResponse:
        return _handleBadResponse(error.response);
        
      case DioExceptionType.cancel:
        return 'Request cancelled';
        
      case DioExceptionType.connectionError:
        return 'No internet connection. Please check your network';
        
      default:
        return 'Something went wrong. Please try again';
    }
  }
  
  static String _handleBadResponse(Response? response) {
    if (response == null) return 'Unknown error occurred';
    
    switch (response.statusCode) {
      case 400:
        return _extractErrorMessage(response.data) ?? 'Bad request';
      case 401:
        return 'Invalid credentials or session expired';
      case 403:
        return 'You don\'t have permission to perform this action';
      case 404:
        return 'Resource not found';
      case 409:
        return 'Resource already exists';
      case 422:
        return _extractErrorMessage(response.data) ?? 'Validation failed';
      case 500:
        return 'Server error. Please try again later';
      default:
        return _extractErrorMessage(response.data) ?? 'Server error';
    }
  }
  
  static String? _extractErrorMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      if (data.containsKey('error')) return data['error'] as String?;
      if (data.containsKey('message')) return data['message'] as String?;
    }
    return null;
  }
}