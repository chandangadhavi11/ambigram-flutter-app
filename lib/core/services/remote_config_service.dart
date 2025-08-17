/// Firebase Remote Config service for fetching remote configuration values.
///
/// This file provides a service for interacting with Firebase Remote Config.
/// It includes methods for fetching and activating remote config values,
/// and strongly-typed getters for specific config values.
import 'dart:async';
import 'dart:convert';

import 'firebase_remote_config_stub.dart';
import 'package:flutter/foundation.dart';

import '../error/exceptions.dart';

/// Service for accessing Firebase Remote Config values
class RemoteConfigService {
  /// Firebase Remote Config instance
  final FirebaseRemoteConfig _remoteConfig;

  /// Stream controller for config updates
  final _configUpdatesController = StreamController<void>.broadcast();

  /// Stream of config updates
  Stream<void> get configUpdates => _configUpdatesController.stream;

  /// Creates a new [RemoteConfigService] with the given FirebaseRemoteConfig instance
  RemoteConfigService(this._remoteConfig);

  /// Initialize the remote config service with default values and fetch remote values
  Future<void> initialize() async {
    try {
      // Set default values
      await _remoteConfig.setDefaults(_defaultValues);

      // Set fetch parameters
      await _remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: kDebugMode
            ? const Duration(minutes: 0) // Allow frequent fetches in debug mode
            : const Duration(hours: 12), // Limit fetches in production
      ));

      // Fetch and activate
      await fetchAndActivate();
    } catch (e) {
      debugPrint('Failed to initialize remote config: $e');
      // Continue without remote config
    }
  }

  /// Fetch and activate remote config values
  Future<bool> fetchAndActivate() async {
    try {
      final activated = await _remoteConfig.fetchAndActivate();
      if (activated) {
        _configUpdatesController.add(null);
      }
      return activated;
    } catch (e) {
      debugPrint('Failed to fetch remote config: $e');
      return false;
    }
  }

  /// Minimum app version required (build number)
  int get minBuildVersion => _remoteConfig.getInt('min_build_version');

  /// Default credits given to new users
  int get defaultCredits => _remoteConfig.getInt('default_credits');

  /// Number of credits awarded for watching a rewarded ad
  int get rewardedAdCredits => _remoteConfig.getInt('rewarded_ad_credits');

  /// Number of actions before showing an interstitial ad
  int get interstitialAdFrequency =>
      _remoteConfig.getInt('interstitial_ad_frequency');

  /// Whether to show banner ads
  bool get showBannerAds => _remoteConfig.getBool('show_banner_ads');

  /// Base URL for SVG ambigram templates
  String get svgBaseUrl => _remoteConfig.getString('svg_base_url');

  /// Google Play Store URL
  String get playStoreUrl => _remoteConfig.getString('play_store_url');

  /// App Store URL
  String get appStoreUrl => _remoteConfig.getString('app_store_url');

  /// Ad unit ID for banner ads
  String get bannerAdUnitId => _getPlatformSpecificAdUnitId('banner');

  /// Ad unit ID for interstitial ads
  String get interstitialAdUnitId =>
      _getPlatformSpecificAdUnitId('interstitial');

  /// Ad unit ID for rewarded ads
  String get rewardedAdUnitId => _getPlatformSpecificAdUnitId('rewarded');

  /// Gets the ad unit ID for the specified ad type based on the current platform
  String _getPlatformSpecificAdUnitId(String adType) {
    try {
      final adUnits = json.decode(_remoteConfig.getString('ad_units'))
          as Map<String, dynamic>;

      if (defaultTargetPlatform == TargetPlatform.android) {
        return adUnits['android'][adType] as String;
      } else if (defaultTargetPlatform == TargetPlatform.iOS) {
        return adUnits['ios'][adType] as String;
      } else {
        return 'test-ad-unit';
      }
    } catch (e) {
      throw RemoteConfigException(
        'Failed to parse ad units from remote config',
        key: 'ad_units',
      );
    }
  }

  /// Get available ambigram styles from remote config
  List<Map<String, dynamic>> get ambigramStyles {
    try {
      final stylesJson = _remoteConfig.getString('ambigram_styles');
      if (stylesJson.isEmpty) {
        return _defaultStyles;
      }

      final List<dynamic> stylesList = json.decode(stylesJson) as List<dynamic>;
      return stylesList.map((style) => style as Map<String, dynamic>).toList();
    } catch (e) {
      debugPrint('Failed to parse ambigram styles: $e');
      return _defaultStyles;
    }
  }

  /// Get available background colors from remote config
  List<String> get backgroundColors {
    try {
      final colorsJson = _remoteConfig.getString('background_colors');
      if (colorsJson.isEmpty) {
        return _defaultColors;
      }

      final List<dynamic> colorsList = json.decode(colorsJson) as List<dynamic>;
      return colorsList.map((color) => color as String).toList();
    } catch (e) {
      debugPrint('Failed to parse background colors: $e');
      return _defaultColors;
    }
  }

  /// Default values for remote config
  static const Map<String, dynamic> _defaultValues = {
    'min_build_version': 1,
    'default_credits': 10,
    'rewarded_ad_credits': 5,
    'interstitial_ad_frequency': 2,
    'show_banner_ads': true,
    'svg_base_url': 'https://example.com/ambigram/svg/',
    'play_store_url':
        'https://play.google.com/store/apps/details?id=com.cuberix.ambigram',
    'app_store_url':
        'https://apps.apple.com/app/ambigram-generator/id123456789',
    'ad_units':
        '{"android":{"banner":"ca-app-pub-3940256099942544/6300978111","interstitial":"ca-app-pub-3940256099942544/1033173712","rewarded":"ca-app-pub-3940256099942544/5224354917"},"ios":{"banner":"ca-app-pub-3940256099942544/2934735716","interstitial":"ca-app-pub-3940256099942544/4411468910","rewarded":"ca-app-pub-3940256099942544/1712485313"}}',
    'ambigram_styles':
        '[{"id":"classic","name":"Classic","description":"Traditional ambigram style"},{"id":"gothic","name":"Gothic","description":"Gothic inspired ambigram style"},{"id":"modern","name":"Modern","description":"Clean modern ambigram style"}]',
    'background_colors':
        '["#FFFFFF","#F5F5F5","#EEEEEE","#E0F7FA","#F3E5F5","#FFF3E0","#FFEBEE"]',
  };

  /// Default ambigram styles if remote config fails
  static final List<Map<String, dynamic>> _defaultStyles = [
    {
      'id': 'classic',
      'name': 'Classic',
      'description': 'Traditional ambigram style'
    },
    {
      'id': 'gothic',
      'name': 'Gothic',
      'description': 'Gothic inspired ambigram style'
    },
    {
      'id': 'modern',
      'name': 'Modern',
      'description': 'Clean modern ambigram style'
    },
  ];

  /// Default background colors if remote config fails
  static final List<String> _defaultColors = [
    '#FFFFFF', // White
    '#F5F5F5', // Off-white
    '#EEEEEE', // Light grey
    '#E0F7FA', // Light cyan
    '#F3E5F5', // Light purple
    '#FFF3E0', // Light orange
    '#FFEBEE', // Light red
  ];

  /// Dispose of resources
  void dispose() {
    _configUpdatesController.close();
  }
}
