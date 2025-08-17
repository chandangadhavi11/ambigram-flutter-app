/// Network information service to check connectivity status.
///
/// This file provides a service to check if the device is connected to the internet.
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

/// Abstract class defining the network info interface
abstract class NetworkInfo {
  /// Returns true if the device is connected to the internet
  Future<bool> get isConnected;

  /// Stream of connectivity status changes
  Stream<ConnectivityResult> get onConnectivityChanged;

  /// Current connectivity status
  Future<ConnectivityResult> get connectivityResult;
}

/// Implementation of [NetworkInfo] using the connectivity_plus package
class NetworkInfoImpl implements NetworkInfo {
  /// The connectivity service
  final Connectivity _connectivity;

  /// Creates a new [NetworkInfoImpl] with the given connectivity service
  NetworkInfoImpl(this._connectivity);

  @override
  Future<bool> get isConnected async {
    if (kIsWeb) {
      // For web, we can't reliably check connectivity, so assume connected
      return true;
    }

    final result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }

  @override
  Stream<ConnectivityResult> get onConnectivityChanged =>
      _connectivity.onConnectivityChanged;

  @override
  Future<ConnectivityResult> get connectivityResult =>
      _connectivity.checkConnectivity();
}
