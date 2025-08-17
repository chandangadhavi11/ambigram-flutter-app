/// This file provides stub implementations for Google Mobile Ads
/// to allow the app to work when the ads package is temporarily disabled

/// A stub class that mimics the MobileAds class in google_mobile_ads
class MobileAds {
  /// Singleton instance
  static final MobileAds _instance = MobileAds._internal();

  /// Getter for the instance
  static MobileAds get instance => _instance;

  /// Private constructor
  MobileAds._internal();

  /// Initialize mobile ads (stub implementation)
  Future<void> initialize() async {
    // No-op implementation since ads are disabled
    print('Using stub MobileAds implementation - Ads are disabled');
    return;
  }
}
