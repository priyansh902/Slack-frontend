import '../models/public_portfolio.dart';
import '../services/api_service.dart';

class PortfolioRepository {
  final ApiService _apiService = ApiService();

  Future<PublicPortfolio> getPortfolio(String username) async {
    try {
      final response = await _apiService.get('/portfolio/$username');
      
      if (response.statusCode == 200) {
        return PublicPortfolio.fromJson(response.data);
      }
      throw Exception('Portfolio not found');
    } catch (e) {
      throw Exception('Failed to load portfolio: $e');
    }
  }

  Future<bool> checkPortfolioExists(String username) async {
    try {
      final response = await _apiService.get('/portfolio/exists/$username');
      
      if (response.statusCode == 200) {
        return response.data['exists'] ?? false;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<Map<String, dynamic>> healthCheck() async {
    try {
      final response = await _apiService.get('/portfolio/health');
      
      if (response.statusCode == 200) {
        return response.data;
      }
      return {'status': 'DOWN'};
    } catch (e) {
      return {'status': 'DOWN', 'error': e.toString()};
    }
  }
}