/// Custom exceptions for the application.
///
/// This file defines all the custom exceptions that can be thrown within the application.
/// Centralizing exceptions helps with error handling and provides clear error messages.

/// Base exception for all app-specific exceptions.
class AppException implements Exception {
  /// A message describing the error
  final String message;
  
  /// Optional error code
  final String? code;
  
  /// Creates a new [AppException] with the given message and optional code.
  const AppException(this.message, {this.code});
  
  @override
  String toString() => code != null 
    ? 'AppException[$code]: $message' 
    : 'AppException: $message';
}

/// Exception thrown when a network request fails.
class NetworkException extends AppException {
  /// Creates a new [NetworkException] with the given message and optional code.
  const NetworkException(String message, {String? code}) 
    : super(message, code: code);
}

/// Exception thrown when a server returns an error response.
class ServerException extends AppException {
  /// HTTP status code
  final int? statusCode;
  
  /// Creates a new [ServerException] with the given message, optional code, and status code.
  const ServerException(String message, {String? code, this.statusCode}) 
    : super(message, code: code);
    
  @override
  String toString() => statusCode != null 
    ? 'ServerException[$code]($statusCode): $message' 
    : super.toString();
}

/// Exception thrown when cached data is not available.
class CacheException extends AppException {
  /// Creates a new [CacheException] with the given message and optional code.
  const CacheException(String message, {String? code}) 
    : super(message, code: code);
}

/// Exception thrown when authentication fails.
class AuthException extends AppException {
  /// Creates a new [AuthException] with the given message and optional code.
  const AuthException(String message, {String? code}) 
    : super(message, code: code);
}

/// Exception thrown when validation fails.
class ValidationException extends AppException {
  /// Field that failed validation
  final String? field;
  
  /// Creates a new [ValidationException] with the given message, optional code, and field.
  const ValidationException(String message, {String? code, this.field}) 
    : super(message, code: code);
    
  @override
  String toString() => field != null 
    ? 'ValidationException[$code]($field): $message' 
    : super.toString();
}

/// Exception thrown when permissions are not granted.
class PermissionException extends AppException {
  /// Permission that was denied
  final String? permission;
  
  /// Creates a new [PermissionException] with the given message, optional code, and permission.
  const PermissionException(String message, {String? code, this.permission}) 
    : super(message, code: code);
    
  @override
  String toString() => permission != null 
    ? 'PermissionException[$code]($permission): $message' 
    : super.toString();
}

/// Exception thrown when a feature is not available.
class FeatureUnavailableException extends AppException {
  /// Creates a new [FeatureUnavailableException] with the given message and optional code.
  const FeatureUnavailableException(String message, {String? code}) 
    : super(message, code: code);
}

/// Exception thrown when a remote config value is missing or invalid.
class RemoteConfigException extends AppException {
  /// Key of the missing or invalid config
  final String? key;
  
  /// Creates a new [RemoteConfigException] with the given message, optional code, and key.
  const RemoteConfigException(String message, {String? code, this.key}) 
    : super(message, code: code);
    
  @override
  String toString() => key != null 
    ? 'RemoteConfigException[$code]($key): $message' 
    : super.toString();
}

/// Exception thrown when an ad fails to load.
class AdException extends AppException {
  /// Creates a new [AdException] with the given message and optional code.
  const AdException(String message, {String? code}) 
    : super(message, code: code);
}
