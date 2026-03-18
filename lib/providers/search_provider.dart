import 'package:flutter/material.dart';
import '../data/models/user_search_result.dart';

class SearchProvider extends ChangeNotifier {
  final SearchRepository _repository = SearchRepository();
  
  List<UserSearchResult> _results = [];
  List<Map<String, dynamic>> _suggestions = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<UserSearchResult> get results => _results;
  List<Map<String, dynamic>> get suggestions => _suggestions;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<bool> searchByUsername(String query) async {
    _setLoading(true);
    _clearError();

    try {
      _results = await _repository.searchByUsername(query);
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setLoading(false);
      _error = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  Future<bool> searchByName(String query) async {
    _setLoading(true);
    _clearError();

    try {
      _results = await _repository.searchByName(query);
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setLoading(false);
      _error = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  Future<bool> searchByKeyword(String keyword) async {
    _setLoading(true);
    _clearError();

    try {
      _results = await _repository.searchByKeyword(keyword);
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setLoading(false);
      _error = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  Future<void> getSuggestions(String query) async {
    if (query.length < 2) {
      _suggestions = [];
      notifyListeners();
      return;
    }

    try {
      _suggestions = await _repository.getSearchSuggestions(query);
      notifyListeners();
    } catch (e) {
      _suggestions = [];
      notifyListeners();
    }
  }

  Future<bool> loadRecentUsers({int limit = 10}) async {
    _setLoading(true);
    _clearError();

    try {
      _results = await _repository.getRecentUsers(limit: limit);
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setLoading(false);
      _error = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  Future<UserSearchResult?> getUserById(int userId) async {
    return await _repository.getUserById(userId);
  }

  Future<UserSearchResult?> getUserByUsername(String username) async {
    return await _repository.getUserByUsername(username);
  }

  void clearResults() {
    _results = [];
    _suggestions = [];
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