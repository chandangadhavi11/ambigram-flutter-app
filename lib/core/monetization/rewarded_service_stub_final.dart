/// Rewarded ad service stub implementation.
///
/// This file provides a stub implementation for the rewarded ad service
/// when the ads package is disabled.
import 'package:flutter/foundation.dart';
import '../services/analytics_service.dart';

/// Stub implementation of a reward item
class RewardItem {
  /// The amount of the reward
  final int amount = 1;

  /// The type of the reward
  final String type = 'credits';
}

/// Callback for when a reward is earned
typedef OnRewardEarned = void Function(RewardItem reward);

/// A service for loading and showing rewarded ads (stub version)
class RewardedAdService {
  /// Whether the ad is loaded and ready to be shown
  bool _isAdLoaded = true; // Always return true in stub

  /// The ad unit ID for the rewarded ad
  final String _adUnitId;

  /// Creates a new [RewardedAdService] with the given ad unit ID
  RewardedAdService({
    required String adUnitId,
    required AnalyticsService analyticsService, // Kept for API compatibility
  }) : _adUnitId = adUnitId {
    debugPrint('Using stub RewardedAdService - Ads are disabled');
  }

  /// Whether the ad is loaded and ready to be shown
  bool get isAdLoaded => _isAdLoaded;

  /// Load the rewarded ad (stub implementation)
  Future<void> loadAd() async {
    _isAdLoaded = true;
  }

  /// Show the rewarded ad if it's loaded (stub implementation)
  Future<bool> showAd(OnRewardEarned onRewardEarned) async {
    // Simulate ad shown event
    AnalyticsService.logAdViewed(
      adType: 'rewarded',
      adUnitId: _adUnitId,
    );

    // Always give the reward in the stub implementation
    onRewardEarned(RewardItem());

    return true;
  }

  /// Dispose of the ad resources (stub implementation)
  void dispose() {
    // No-op
  }
}
