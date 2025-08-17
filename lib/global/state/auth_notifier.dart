import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Simplified user state notifier for the application (authentication removed)
class AuthNotifier extends ChangeNotifier {
  bool _isInitialized = false;
  bool _isLoggedIn = true; // Always logged in
  bool _requireLogin = false; // Never require login
  int _credits = 10; // Start with 10 credits

  /// Whether auth state has been initialized
  bool get isInitialized => _isInitialized;

  /// Whether the user is logged in
  bool get isLoggedIn => _isLoggedIn;

  /// Whether login is required
  bool get requireLogin => _requireLogin;

  /// Number of credits the user has
  int get credits => _credits;

  /// Initialize the user state
  Future<void> initialize() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _credits = prefs.getInt('credits') ?? 10; // Default to 10 credits
    } catch (e) {
      _credits = 10; // Default to 10 credits on error
    } finally {
      _isInitialized = true;
      notifyListeners();
    }
  }

  // Authentication methods removed - users are always logged in

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

  // Login requirement methods removed - authentication is never required
}
