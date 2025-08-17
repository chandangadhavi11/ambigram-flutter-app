/// Firebase Remote Config stub implementation.
///
/// This file provides a stub implementation for Firebase Remote Config
/// when Firebase is temporarily disabled.
import 'package:flutter/foundation.dart';

/// Settings for Remote Config - stub implementation
class RemoteConfigSettings {
  /// Timeout for fetch operations
  final Duration fetchTimeout;

  /// Minimum interval between fetches
  final Duration minimumFetchInterval;

  /// Constructor
  const RemoteConfigSettings({
    required this.fetchTimeout,
    required this.minimumFetchInterval,
  });
}

/// Stub implementation for Firebase Remote Config
class FirebaseRemoteConfig {
  static final FirebaseRemoteConfig _instance =
      FirebaseRemoteConfig._internal();

  /// Default values for remote config parameters
  final Map<String, dynamic> _defaults = {};

  /// Singleton instance
  static FirebaseRemoteConfig get instance => _instance;

  FirebaseRemoteConfig._internal();

  /// Set configuration settings - stub implementation
  Future<void> setConfigSettings(RemoteConfigSettings settings) async {
    debugPrint('Using stub Remote Config implementation');
  }

  /// Set default values - stub implementation
  Future<void> setDefaults(Map<String, dynamic> defaults) async {
    _defaults.addAll(defaults);
  }

  /// Fetch and activate config values - stub implementation
  Future<bool> fetchAndActivate() async {
    return true;
  }

  /// Get a string value - stub implementation
  String getString(String key) {
    return _defaults[key]?.toString() ?? '';
  }

  /// Get an int value - stub implementation
  int getInt(String key) {
    return _defaults[key] as int? ?? 0;
  }

  /// Get a double value - stub implementation
  double getDouble(String key) {
    return _defaults[key] as double? ?? 0.0;
  }

  /// Get a bool value - stub implementation
  bool getBool(String key) {
    return _defaults[key] as bool? ?? false;
  }
}
