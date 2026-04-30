import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';
import '../services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  User? _user;
  bool _isAuthenticated = false;

  User? get user => _user;
  bool get isAuthenticated => _isAuthenticated;
  bool get isVerifiedBusiness => _user?.isVerifiedBusiness ?? false;
  bool get canAccessMedicines => _user?.canAccessMedicines ?? false;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token != null) {
      _apiService.token = token;
      try {
        final response = await _apiService.get('/me');
        _user = User.fromJson(response['user']);
        _isAuthenticated = true;
      } catch (e) {
        await logout();
      }
    }
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    final response = await _apiService.post('/login', {
      'email': email,
      'password': password,
    });

    _apiService.token = response['token'];
    _user = User.fromJson(response['user']);
    _isAuthenticated = true;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', response['token']);

    notifyListeners();
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String role,
    String? phone,
    String? businessName,
    String? businessType,
  }) async {
    final response = await _apiService.post('/register', {
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': passwordConfirmation,
      'role': role,
      if (phone != null) 'phone': phone,
      if (businessName != null) 'business_name': businessName,
      if (businessType != null) 'business_type': businessType,
    });

    _apiService.token = response['token'];
    _user = User.fromJson(response['user']);
    _isAuthenticated = true;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', response['token']);

    notifyListeners();
  }

  Future<void> logout() async {
    try {
      await _apiService.post('/logout', {});
    } catch (e) {
      // Ignore logout errors
    }

    _user = null;
    _isAuthenticated = false;
    _apiService.token = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');

    notifyListeners();
  }

  Future<void> refreshUser() async {
    if (_isAuthenticated) {
      final response = await _apiService.get('/me');
      _user = User.fromJson(response['user']);
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> forgotPassword(String email) async {
    final response = await _apiService.post('/forgot-password', {
      'email': email,
    });
    return response;
  }
}
