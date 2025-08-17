/// Helper utilities for the application.
///
/// This file provides general utility functions used throughout the application.
import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// A utility class that holds helper methods for the app.
class Helpers {
  /// Private constructor to prevent instantiation
  const Helpers._();
  
  /// Converts a hex color string to a Color object
  static Color hexToColor(String hexString) {
    final buffer = StringBuffer();
    
    if (hexString.length == 6 || hexString.length == 7) {
      buffer.write('ff');
    }
    
    buffer.write(hexString.replaceFirst('#', ''));
    
    return Color(int.parse(buffer.toString(), radix: 16));
  }
  
  /// Converts a Color object to a hex color string
  static String colorToHex(Color color) {
    return '#${color.value.toRadixString(16).substring(2)}';
  }
  
  /// Returns a darker variant of the given color
  static Color darken(Color color, [double amount = .1]) {
    assert(amount >= 0 && amount <= 1);
    
    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    
    return hslDark.toColor();
  }
  
  /// Returns a lighter variant of the given color
  static Color lighten(Color color, [double amount = .1]) {
    assert(amount >= 0 && amount <= 1);
    
    final hsl = HSLColor.fromColor(color);
    final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));
    
    return hslLight.toColor();
  }
  
  /// Calculates contrast ratio between two colors
  static double getContrastRatio(Color foreground, Color background) {
    // Calculate luminance values
    final double foregroundLuminance = foreground.computeLuminance();
    final double backgroundLuminance = background.computeLuminance();
    
    // Calculate contrast ratio
    return (math.max(foregroundLuminance, backgroundLuminance) + 0.05) /
      (math.min(foregroundLuminance, backgroundLuminance) + 0.05);
  }
  
  /// Determines whether white or black text would have better contrast on a given background color
  static Color getTextColorForBackground(Color backgroundColor) {
    return backgroundColor.computeLuminance() > 0.5 ? Colors.black : Colors.white;
  }
  
  /// Format a date to a string in the format "MMM dd, yyyy"
  static String formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
  
  /// Capitalizes the first letter of each word in a string
  static String capitalizeWords(String text) {
    if (text.isEmpty) return text;
    
    return text.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1);
    }).join(' ');
  }
  
  /// Returns a Platform-aware adaptive value (Material for Android, Cupertino for iOS)
  static T adaptiveValue<T>({required T android, required T ios}) {
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        return ios;
      default:
        return android;
    }
  }
  
  /// Get device screen type (small, medium, large, xlarge)
  static String getScreenType(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    
    if (width < 360) {
      return 'small';
    } else if (width < 600) {
      return 'medium';
    } else if (width < 900) {
      return 'large';
    } else {
      return 'xlarge';
    }
  }
  
  /// Get readable file size
  static String getReadableFileSize(int size) {
    const suffixes = ['B', 'KB', 'MB', 'GB', 'TB'];
    var i = 0;
    double fileSize = size.toDouble();
    
    while (fileSize > 1024 && i < suffixes.length - 1) {
      fileSize /= 1024;
      i++;
    }
    
    return '${fileSize.toStringAsFixed(2)} ${suffixes[i]}';
  }
}
