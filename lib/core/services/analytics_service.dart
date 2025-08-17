/// Firebase Analytics service for tracking user events.
///
/// This file provides a service for interacting with Firebase Analytics.
/// It includes methods for logging events and setting user properties.
import 'firebase_analytics_stub.dart';

/// Service for tracking analytics events
class AnalyticsService {
  /// Firebase Analytics instance
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  /// Private constructor to prevent instantiation
  AnalyticsService._();

  /// Log when the app is opened
  static Future<void> logAppOpen() async {
    await _analytics.logAppOpen();
  }

  /// Log a custom event
  static Future<void> logEvent({
    required String name,
    Map<String, dynamic>? parameters,
  }) async {
    await _analytics.logEvent(
      name: name,
      parameters: parameters,
    );
  }

  /// Log a screen view event
  static Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  }) async {
    await _analytics.logEvent(
      name: 'screen_view',
      parameters: {
        'screen_name': screenName,
        'screen_class': screenClass,
      },
    );
  }

  /// Log when a user creates an ambigram
  static Future<void> logAmbigramGenerated({
    required String primaryWord,
    String? secondaryWord,
    required String styleId,
    required String backgroundColor,
  }) async {
    await logEvent(
      name: 'ambigram_generated',
      parameters: {
        'primary_word': primaryWord,
        'has_secondary_word': secondaryWord != null,
        'style_id': styleId,
        'background_color': backgroundColor,
      },
    );
  }

  /// Log when a user downloads or shares an ambigram
  static Future<void> logAmbigramShared({
    required String action, // 'download', 'save', or 'share'
    required String primaryWord,
    String? secondaryWord,
    required String styleId,
  }) async {
    await logEvent(
      name: 'ambigram_shared',
      parameters: {
        'action': action,
        'primary_word': primaryWord,
        'has_secondary_word': secondaryWord != null,
        'style_id': styleId,
      },
    );
  }

  /// Log when a user earns credits
  static Future<void> logCreditsEarned({
    required String source, // 'ad_reward', 'purchase', etc.
    required int amount,
  }) async {
    await logEvent(
      name: 'credits_earned',
      parameters: {
        'source': source,
        'amount': amount,
      },
    );
  }

  /// Log when a user spends credits
  static Future<void> logCreditsSpent({
    required String action, // 'generate_ambigram', etc.
    required int amount,
  }) async {
    await logEvent(
      name: 'credits_spent',
      parameters: {
        'action': action,
        'amount': amount,
      },
    );
  }

  /// Log when a user encounters an error
  static Future<void> logError({
    required String errorType,
    String? errorMessage,
    String? errorCode,
  }) async {
    await logEvent(
      name: 'app_error',
      parameters: {
        'error_type': errorType,
        'error_message': errorMessage,
        'error_code': errorCode,
      },
    );
  }

  /// Log when a user views an ad
  static Future<void> logAdViewed({
    required String adType, // 'banner', 'interstitial', 'rewarded'
    String? adUnitId,
  }) async {
    await logEvent(
      name: 'ad_viewed',
      parameters: {
        'ad_type': adType,
        'ad_unit_id': adUnitId,
      },
    );
  }

  /// Log when a forced update is shown to the user
  static Future<void> logForcedUpdateShown({
    required int currentBuild,
    required int minBuild,
  }) async {
    await logEvent(
      name: 'forced_update_shown',
      parameters: {
        'current_build': currentBuild,
        'min_build': minBuild,
      },
    );
  }

  /// Set the user ID for analytics
  static Future<void> setUserId(String userId) async {
    await _analytics.setUserId(id: userId);
  }

  /// Set a user property
  static Future<void> setUserProperty({
    required String name,
    required String? value,
  }) async {
    await _analytics.setUserProperty(name: name, value: value);
  }
}
