/// Interstitial ad service stub implementation.
///
/// This file provides a stub implementation for the interstitial ad service
/// when the ads package is disabled.
import 'package:flutter/foundation.dart';
import '../services/analytics_service.dart';

/// A service for loading and showing interstitial ads (stub version)
class InterstitialAdService {
  /// Whether the ad is loaded and ready to be shown
  bool _isAdLoaded = true; // Always return true in stub

  /// The ad unit ID for the interstitial ad
  final String _adUnitId;

  /// Creates a new [InterstitialAdService] with the given ad unit ID
  InterstitialAdService({
    required String adUnitId,
    required AnalyticsService analyticsService, // Kept for API compatibility
  }) : _adUnitId = adUnitId {
    debugPrint('Using stub InterstitialAdService - Ads are disabled');
  }

  /// Whether the ad is loaded and ready to be shown
  bool get isAdLoaded => _isAdLoaded;

  /// Load the interstitial ad (stub implementation)
  Future<void> loadAd() async {
    _isAdLoaded = true;
  }

  /// Show the interstitial ad if it's loaded (stub implementation)
  Future<bool> showAd() async {
    // Simulate ad shown event
    AnalyticsService.logAdViewed(
      adType: 'interstitial',
      adUnitId: _adUnitId,
    );
    return true;
  }

  /// Dispose of the ad resources (stub implementation)
  void dispose() {
    // No-op
  }
}
