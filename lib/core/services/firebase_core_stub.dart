/// Firebase core stub implementation.
///
/// This file provides a stub implementation for Firebase core functionality
/// when Firebase is temporarily disabled.
import 'package:flutter/foundation.dart';

/// Stub implementation for Firebase options
class FirebaseOptions {
  /// API key
  final String apiKey;
  /// App ID
  final String appId;
  /// Project ID
  final String projectId;
  /// Messaging sender ID
  final String messagingSenderId;
  
  /// Constructor
  const FirebaseOptions({
    required this.apiKey,
    required this.appId,
    required this.projectId,
    required this.messagingSenderId,
  });
}

/// Stub implementation for Firebase app
class FirebaseApp {
  /// App name
  final String _name;
  
  /// Constructor
  FirebaseApp(this._name);
  
  /// App name
  String get name => _name;
}

/// Stub implementation for Firebase
class Firebase {
  static FirebaseApp? _app;
  
  /// Default app
  static FirebaseApp get app {
    if (_app == null) {
      throw Exception("Firebase has not been initialized. Call Firebase.initializeApp() first.");
    }
    return _app!;
  }
  
  /// Initialize the Firebase app - stub implementation
  static Future<FirebaseApp> initializeApp({
    FirebaseOptions? options,
    String name = '[DEFAULT]',
  }) async {
    debugPrint('Using stub Firebase implementation');
    _app = FirebaseApp(name);
    return _app!;
  }
}
