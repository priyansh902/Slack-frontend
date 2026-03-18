import 'package:flutter/material.dart';
import '../data/models/public_portfolio.dart';
import '../data/repositories/portfolio_repository.dart';

class PortfolioProvider extends ChangeNotifier {
  final PortfolioRepository _repository = PortfolioRepository();
  
  PublicPortfolio? _portfolio;
  bool _isLoading = false;
  String? _error;
  bool _exists = false;

  // Getters
  PublicPortfolio? get portfolio => _portfolio;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get exists => _exists;

  Future<bool> loadPortfolio(String username) async {
    _setLoading(true);
    _clearError();

    try {
      _portfolio = await _repository.getPortfolio(username);
      _exists = true;
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setLoading(false);
      _exists = false;
      _portfolio = null;
      if (!e.toString().contains('not found')) {
        _error = e.toString();
      }
      notifyListeners();
      return false;
    }
  }

  Future<bool> checkPortfolioExists(String username) async {
    try {
      _exists = await _repository.checkPortfolioExists(username);
      notifyListeners();
      return _exists;
    } catch (e) {
      _exists = false;
      notifyListeners();
      return false;
    }
  }

  Future<Map<String, dynamic>> healthCheck() async {
    return await _repository.healthCheck();
  }

  void clearPortfolio() {
    _portfolio = null;
    _exists = false;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }
}