/// Interstitial ad service stub implementation.
///
/// This file provides a stub implementation for the interstitial ad service
/// when the ads package is disabled.
import 'package:flutter/foundation.dart';

/// A stub service for interstitial ads
class InterstitialAdService {
  /// Singleton instance
  static final InterstitialAdService _instance = InterstitialAdService._internal();
  
  /// Factory constructor to return the singleton instance
  factory InterstitialAdService() => _instance;
  
  /// Private constructor
  InterstitialAdService._internal();

  /// Initialize the service
  Future<void> initialize() async {
    debugPrint('Using stub InterstitialAdService - Ads are disabled');
  }

  /// Shows an interstitial ad if one is available
  Future<bool> showInterstitialAd() async {
    // Just return true to simulate successful showing of an ad
    return true;
  }
  
  /// Preloads an ad for later display
  Future<void> preloadInterstitialAd() async {
    // No-op since ads are disabled
  }
}
