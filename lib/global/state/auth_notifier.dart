import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Auth state notifier for the application
class AuthNotifier extends ChangeNotifier {
  bool _isInitialized = false;
  bool _isLoggedIn = false;
  bool _requireLogin = true;
  int _credits = 0;
  
  /// Whether auth state has been initialized
  bool get isInitialized => _isInitialized;
  
  /// Whether the user is logged in
  bool get isLoggedIn => _isLoggedIn;
  
  /// Whether login is required
  bool get requireLogin => _requireLogin;
  
  /// Number of credits the user has
  int get credits => _credits;

  /// Initialize the auth state
  Future<void> initialize() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isLoggedIn = prefs.getBool('is_logged_in') ?? false;
      _requireLogin = prefs.getBool('require_login') ?? true;
      _credits = prefs.getInt('credits') ?? 0;
    } catch (e) {
      _isLoggedIn = false;
      _requireLogin = true;
      _credits = 0;
    } finally {
      _isInitialized = true;
      notifyListeners();
    }
  }

  /// Login the user
  Future<void> login({required String email, required String password}) async {
    try {
      // TODO: Implement actual login logic with Firebase Auth
      await Future.delayed(const Duration(seconds: 1));
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_logged_in', true);
      await prefs.setInt('credits', 5); // Give new users 5 credits
      
      _isLoggedIn = true;
      _credits = 5;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  /// Register a new user
  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      // TODO: Implement actual registration logic with Firebase Auth
      await Future.delayed(const Duration(seconds: 1));
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_logged_in', true);
      await prefs.setInt('credits', 5); // Give new users 5 credits
      
      _isLoggedIn = true;
      _credits = 5;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  /// Logout the user
  Future<void> logout() async {
    try {
      // TODO: Implement actual logout logic with Firebase Auth
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_logged_in', false);
      
      _isLoggedIn = false;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  /// Update the user's credits
  Future<void> updateCredits(int amount) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      int currentCredits = prefs.getInt('credits') ?? 0;
      int newCredits = currentCredits + amount;
      
      await prefs.setInt('credits', newCredits);
      _credits = newCredits;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  /// Use credits
  Future<bool> useCredit() async {
    if (_credits <= 0) {
      return false;
    }
    
    try {
      final prefs = await SharedPreferences.getInstance();
      int newCredits = _credits - 1;
      await prefs.setInt('credits', newCredits);
      _credits = newCredits;
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Set whether login is required
  Future<void> setRequireLogin(bool value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('require_login', value);
      _requireLogin = value;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}
