/// API client for making HTTP requests.
///
/// This file provides a wrapper around the HTTP package with error handling,
/// request transformation, and response parsing.
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../error/exceptions.dart';

/// HTTP methods supported by the API client
enum HttpMethod { get, post, put, delete, patch }

/// API client for making HTTP requests
class ApiClient {
  /// HTTP client
  final http.Client _client;

  /// Base URL for the API
  final String? baseUrl;

  /// Default headers for all requests
  final Map<String, String> defaultHeaders;

  /// Default timeout for requests in seconds
  final int timeoutSeconds;

  /// Creates a new [ApiClient] with the given parameters
  ApiClient({
    http.Client? client,
    this.baseUrl,
    Map<String, String>? defaultHeaders,
    this.timeoutSeconds = 30,
  })  : _client = client ?? http.Client(),
        defaultHeaders = defaultHeaders ??
            {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            };

  /// Makes a GET request to the given [endpoint]
  Future<dynamic> get(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    return _sendRequest(
      HttpMethod.get,
      endpoint,
      headers: headers,
      queryParameters: queryParameters,
    );
  }

  /// Makes a POST request to the given [endpoint]
  Future<dynamic> post(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    dynamic body,
  }) async {
    return _sendRequest(
      HttpMethod.post,
      endpoint,
      headers: headers,
      queryParameters: queryParameters,
      body: body,
    );
  }

  /// Makes a PUT request to the given [endpoint]
  Future<dynamic> put(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    dynamic body,
  }) async {
    return _sendRequest(
      HttpMethod.put,
      endpoint,
      headers: headers,
      queryParameters: queryParameters,
      body: body,
    );
  }

  /// Makes a DELETE request to the given [endpoint]
  Future<dynamic> delete(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    dynamic body,
  }) async {
    return _sendRequest(
      HttpMethod.delete,
      endpoint,
      headers: headers,
      queryParameters: queryParameters,
      body: body,
    );
  }

  /// Makes a PATCH request to the given [endpoint]
  Future<dynamic> patch(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    dynamic body,
  }) async {
    return _sendRequest(
      HttpMethod.patch,
      endpoint,
      headers: headers,
      queryParameters: queryParameters,
      body: body,
    );
  }

  /// Sends an HTTP request with the given parameters
  Future<dynamic> _sendRequest(
    HttpMethod method,
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    dynamic body,
  }) async {
    // Prepare URL
    final uri = _buildUri(endpoint, queryParameters);

    // Prepare headers
    final requestHeaders = {...defaultHeaders};
    if (headers != null) {
      requestHeaders.addAll(headers);
    }

    // Prepare body
    final encodedBody = body != null ? json.encode(body) : null;

    http.Response response;

    try {
      // Send request based on method
      switch (method) {
        case HttpMethod.get:
          response = await _client
              .get(uri, headers: requestHeaders)
              .timeout(Duration(seconds: timeoutSeconds));
          break;
        case HttpMethod.post:
          response = await _client
              .post(
                uri,
                headers: requestHeaders,
                body: encodedBody,
              )
              .timeout(Duration(seconds: timeoutSeconds));
          break;
        case HttpMethod.put:
          response = await _client
              .put(
                uri,
                headers: requestHeaders,
                body: encodedBody,
              )
              .timeout(Duration(seconds: timeoutSeconds));
          break;
        case HttpMethod.delete:
          response = await _client
              .delete(
                uri,
                headers: requestHeaders,
                body: encodedBody,
              )
              .timeout(Duration(seconds: timeoutSeconds));
          break;
        case HttpMethod.patch:
          response = await _client
              .patch(
                uri,
                headers: requestHeaders,
                body: encodedBody,
              )
              .timeout(Duration(seconds: timeoutSeconds));
          break;
      }
    } on SocketException {
      throw const NetworkException('No internet connection');
    } on HttpException {
      throw const NetworkException('Could not find the requested resource');
    } on FormatException {
      throw const NetworkException('Bad response format');
    } catch (e) {
      if (e.toString().contains('timeout')) {
        throw const NetworkException('Request timeout');
      }
      rethrow;
    }

    return _handleResponse(response);
  }

  /// Builds the URI for the request
  Uri _buildUri(String endpoint, Map<String, dynamic>? queryParameters) {
    String path = endpoint;
    if (baseUrl != null) {
      if (!endpoint.startsWith('/') && !baseUrl!.endsWith('/')) {
        path = '/$endpoint';
      }
      path = baseUrl! + path;
    }

    return Uri.parse(path).replace(
      queryParameters: queryParameters?.map(
        (key, value) => MapEntry(key, value.toString()),
      ),
    );
  }

  /// Handles the HTTP response
  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) {
        return null;
      }

      try {
        return json.decode(response.body);
      } on FormatException {
        return response.body;
      }
    } else {
      throw ServerException(
        'Server error',
        statusCode: response.statusCode,
        code: response.statusCode.toString(),
      );
    }
  }

  /// Closes the HTTP client
  void close() {
    _client.close();
  }
}
