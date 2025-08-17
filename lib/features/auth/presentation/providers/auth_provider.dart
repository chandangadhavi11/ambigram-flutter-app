import 'package:flutter/material.dart';

/// Provider for managing auth-related state
class AuthProvider extends ChangeNotifier {
  bool _isAuthenticated = false;
  int _credits = 0;

  /// Whether the user is authenticated
  bool get isAuthenticated => _isAuthenticated;

  /// The number of credits the user has
  int get credits => _credits;

  /// Sets the authentication status
  void setAuthenticated(bool value) {
    _isAuthenticated = value;
    notifyListeners();
  }

  /// Sets the number of credits
  void setCredits(int value) {
    _credits = value;
    notifyListeners();
  }

  /// Increments the number of credits
  void addCredits(int value) {
    _credits += value;
    notifyListeners();
  }

  /// Decrements the number of credits
  void useCredits(int value) {
    if (_credits >= value) {
      _credits -= value;
      notifyListeners();
    }
  }

  /// Refreshes the user's credits from the server
  Future<void> refreshCredits() async {
    // TODO: Implement API call to refresh credits
    notifyListeners();
  }
}
