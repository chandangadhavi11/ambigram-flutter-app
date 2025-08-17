/// Global error handler for the application.
///
/// This file provides a centralized error handling mechanism for the application.
/// It captures uncaught errors and reports them to Firebase Crashlytics.
import 'dart:async';
import 'dart:isolate';

import '../services/firebase_crashlytics_stub.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// A utility class for handling errors in the application.
class ErrorHandler {
  /// The singleton instance of [ErrorHandler]
  static final ErrorHandler _instance = ErrorHandler._internal();

  /// Private constructor
  ErrorHandler._internal();

  /// Factory constructor that returns the singleton instance
  factory ErrorHandler() => _instance;

  /// Firebase Crashlytics instance
  late final FirebaseCrashlytics _crashlytics;

  /// Initialize error handling for the app
  Future<void> initialize(FirebaseCrashlytics crashlytics) async {
    _crashlytics = crashlytics;

    // Enable Crashlytics data collection in release mode only
    await _crashlytics.setCrashlyticsCollectionEnabled(!kDebugMode);

    // Pass all uncaught errors from the framework to Crashlytics
    FlutterError.onError = _handleFlutterError;

    // Catch errors outside of Flutter context
    PlatformDispatcher.instance.onError = (error, stack) {
      _handleError(error, stack);
      return true;
    };

    // Catch errors in Dart isolates
    Isolate.current.addErrorListener(RawReceivePort((pair) {
      final List<dynamic> errorAndStacktrace = pair;
      final error = errorAndStacktrace[0];
      final StackTrace stackTrace = errorAndStacktrace[1];
      _handleError(error, stackTrace);
    }).sendPort);
  }

  /// Handle Flutter framework errors
  void _handleFlutterError(FlutterErrorDetails details) {
    _handleError(details.exception, details.stack ?? StackTrace.current,
        reason: details.context?.toString());
  }

  /// Handle general errors
  Future<void> _handleError(dynamic exception, StackTrace? stack,
      {String? reason}) async {
    // Log the error locally
    debugPrint('ERROR: $exception');
    if (stack != null) {
      debugPrint('STACK TRACE: $stack');
    }

    // Only report to Crashlytics in non-debug mode
    if (!kDebugMode) {
      await _crashlytics.recordError(
        exception,
        stack,
        reason: reason,
        fatal: true,
      );
    }
  }

  /// Log a non-fatal error to Crashlytics
  Future<void> logError(dynamic exception, [StackTrace? stackTrace]) async {
    await _crashlytics.recordError(
      exception,
      stackTrace ?? StackTrace.current,
      fatal: false,
    );
  }

  /// Set a custom key/value pair for Crashlytics reports
  Future<void> setCustomKey(String key, dynamic value) async {
    await _crashlytics.setCustomKey(key, value);
  }

  /// Log a message to Crashlytics
  Future<void> log(String message) async {
    await _crashlytics.log(message);
  }

  /// Set user identifier for Crashlytics reports
  Future<void> setUserIdentifier(String identifier) async {
    await _crashlytics.setUserIdentifier(identifier);
  }

  /// Test Crashlytics by forcing a crash (Debug mode only)
  void forceCrash() {
    if (kDebugMode) {
      _crashlytics.crash();
    }
  }
}
