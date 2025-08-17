/// Banner ad widget for displaying banner ads (STUB VERSION).
///
/// This file provides a stub widget for banner ads when the ads package is disabled.
import 'package:flutter/material.dart';

/// A stub widget that simulates a banner ad when ads are disabled
class BannerAdWidget extends StatelessWidget {
  /// The ad unit ID for the banner ad (unused in stub)
  final String adUnitId;
  
  /// Whether to show a loading indicator (unused in stub)
  final bool showLoadingIndicator;
  
  /// The size of the banner ad (unused in stub)
  final Object? adSize;
  
  /// Creates a new [BannerAdWidget]
  const BannerAdWidget({
    required this.adUnitId,
    this.showLoadingIndicator = true,
    this.adSize,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Return an empty container since ads are disabled
    return const SizedBox();
  }
}
