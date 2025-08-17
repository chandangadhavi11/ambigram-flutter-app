/// Firebase Crashlytics service for error reporting.
///
/// This file provides a service for interacting with Firebase Crashlytics.
/// It includes methods for logging errors, setting custom keys, and logging messages.
import 'firebase_crashlytics_stub.dart';
import 'package:flutter/foundation.dart';

/// Service for interacting with Firebase Crashlytics
class CrashlyticsService {
  /// Firebase Crashlytics instance
  final FirebaseCrashlytics _crashlytics;
  
  /// Creates a new [CrashlyticsService] with the given FirebaseCrashlytics instance
  CrashlyticsService(this._crashlytics);
  
  /// Initialize the Crashlytics service
  Future<void> initialize() async {
    // Only enable Crashlytics in non-debug mode
    await _crashlytics.setCrashlyticsCollectionEnabled(!kDebugMode);
  }
  
  /// Records a non-fatal error with the associated stack trace
  Future<void> recordError(dynamic error, StackTrace stackTrace, {
    String? reason,
    bool fatal = false,
  }) async {
    await _crashlytics.recordError(
      error,
      stackTrace,
      reason: reason,
      fatal: fatal,
    );
  }
  
  /// Records a Flutter error with the associated Flutter error details
  Future<void> recordFlutterError(FlutterErrorDetails flutterErrorDetails) async {
    await _crashlytics.recordFlutterError(flutterErrorDetails);
  }
  
  /// Sets a custom key and value that is associated with crash reports
  Future<void> setCustomKey(String key, dynamic value) async {
    await _crashlytics.setCustomKey(key, value);
  }
  
  /// Sets multiple custom keys at once
  Future<void> setCustomKeys(Map<String, dynamic> keys) async {
    for (final entry in keys.entries) {
      await _crashlytics.setCustomKey(entry.key, entry.value);
    }
  }
  
  /// Sets the user identifier for crash reports
  Future<void> setUserIdentifier(String identifier) async {
    await _crashlytics.setUserIdentifier(identifier);
  }
  
  /// Logs a message that will be included in the next crash report
  Future<void> log(String message) async {
    await _crashlytics.log(message);
  }
  
  /// Forces a crash (for testing Crashlytics in debug mode)
  void forceCrash() {
    if (kDebugMode) {
      _crashlytics.crash();
    }
  }
}
