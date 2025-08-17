/// Rewarded ad service stub implementation.
///
/// This file provides a stub implementation for the rewarded ad service
/// when the ads package is disabled.
import 'package:flutter/foundation.dart';

/// A stub service for rewarded ads
class RewardedAdService {
  /// Singleton instance
  static final RewardedAdService _instance = RewardedAdService._internal();
  
  /// Factory constructor to return the singleton instance
  factory RewardedAdService() => _instance;
  
  /// Private constructor
  RewardedAdService._internal();

  /// Initialize the service
  Future<void> initialize() async {
    debugPrint('Using stub RewardedAdService - Ads are disabled');
  }

  /// Shows a rewarded ad if one is available
  /// Returns true if the ad was successfully shown and the reward should be given
  Future<bool> showRewardedAd() async {
    // Just return true to simulate successful showing of an ad
    return true;
  }
  
  /// Preloads an ad for later display
  Future<void> preloadRewardedAd() async {
    // No-op since ads are disabled
  }
}
