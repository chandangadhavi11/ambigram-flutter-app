/// Firebase Analytics stub implementation.
///
/// This file provides a stub implementation for Firebase Analytics
/// when Firebase is temporarily disabled.
import 'package:flutter/foundation.dart';

/// Stub implementation for Firebase Analytics
class FirebaseAnalytics {
  static final FirebaseAnalytics _instance = FirebaseAnalytics._internal();

  /// Singleton instance
  static FirebaseAnalytics get instance => _instance;

  FirebaseAnalytics._internal();

  /// Log event - stub implementation
  Future<void> logEvent({
    required String name,
    Map<String, Object?>? parameters,
  }) async {
    debugPrint('Analytics stub: logEvent($name, $parameters)');
  }

  /// Set user ID - stub implementation
  Future<void> setUserId({String? id}) async {
    debugPrint('Analytics stub: setUserId($id)');
  }

  /// Set user property - stub implementation
  Future<void> setUserProperty({
    required String name,
    required String? value,
  }) async {
    debugPrint('Analytics stub: setUserProperty($name: $value)');
  }

  /// Log app open event - stub implementation
  Future<void> logAppOpen() async {
    debugPrint('Analytics stub: logAppOpen()');
  }

  /// Set current screen - stub implementation
  Future<void> setCurrentScreen({
    required String screenName,
    String? screenClassOverride,
  }) async {
    debugPrint('Analytics stub: setCurrentScreen($screenName)');
  }
}

/// Stub implementation for Analytics Observer
class FirebaseAnalyticsObserver {
  final FirebaseAnalytics analytics;

  /// Constructor
  FirebaseAnalyticsObserver({required this.analytics});
}
