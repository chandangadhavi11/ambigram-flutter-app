/// Firebase Crashlytics stub implementation.
///
/// This file provides a stub implementation for Firebase Crashlytics
/// when Firebase is temporarily disabled.
import 'package:flutter/foundation.dart';

/// Stub implementation for Firebase Crashlytics
class FirebaseCrashlytics {
  static final FirebaseCrashlytics _instance = FirebaseCrashlytics._internal();
  
  /// Singleton instance
  static FirebaseCrashlytics get instance => _instance;
  
  FirebaseCrashlytics._internal();
  
  /// Initialize - stub implementation
  Future<void> initialize() async {
    debugPrint('Using stub Crashlytics implementation');
  }
  
  /// Set collection enabled - stub implementation
  Future<void> setCrashlyticsCollectionEnabled(bool enabled) async {
    debugPrint('Crashlytics stub: setCrashlyticsCollectionEnabled($enabled)');
  }
  
  /// Record error - stub implementation
  Future<void> recordError(
    dynamic exception,
    StackTrace? stack, {
    dynamic reason,
    Iterable<DiagnosticsNode> information = const [],
    bool? printDetails,
    bool fatal = false,
  }) async {
    debugPrint('Crashlytics stub: recordError($exception)');
    debugPrint('Stack trace: $stack');
  }
  
  /// Record Flutter error - stub implementation
  Future<void> recordFlutterError(FlutterErrorDetails flutterErrorDetails) async {
    debugPrint('Crashlytics stub: recordFlutterError(${flutterErrorDetails.exception})');
    debugPrint('Stack trace: ${flutterErrorDetails.stack}');
  }
  
  /// Log - stub implementation
  Future<void> log(String message) async {
    debugPrint('Crashlytics stub log: $message');
  }
  
  /// Set user ID - stub implementation
  Future<void> setUserIdentifier(String identifier) async {
    debugPrint('Crashlytics stub: setUserIdentifier($identifier)');
  }
  
  /// Set custom key - stub implementation
  Future<void> setCustomKey(String key, dynamic value) async {
    debugPrint('Crashlytics stub: setCustomKey($key, $value)');
  }
  
  /// Simulate crash - stub implementation
  void crash() {
    debugPrint('Crashlytics stub: crash() - not actually crashing');
  }
}
