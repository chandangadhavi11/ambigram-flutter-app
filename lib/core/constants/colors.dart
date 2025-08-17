/// Color constants for the application.
///
/// This file defines all the colors used throughout the application.
/// Colors are defined as static constants to ensure consistency.
library;

import 'package:flutter/material.dart';

/// A utility class that holds all the color constants for the app.
class AppColors {
  /// Private constructor to prevent instantiation
  const AppColors._();

  /// Primary color of the application
  static const Color primary = Color(0xFF6750A4);

  /// Secondary color of the application
  static const Color secondary = Color(0xFF625B71);

  /// Accent color of the application
  static const Color accent = Color(0xFF7D5260);

  /// Background color for the light theme
  static const Color backgroundLight = Color(0xFFFFFFFF);

  /// Background color for the dark theme
  static const Color backgroundDark = Color(0xFF121212);

  /// Surface color for the light theme
  static const Color surfaceLight = Color(0xFFF7F2FA);

  /// Surface color for the dark theme
  static const Color surfaceDark = Color(0xFF1E1E1E);

  /// Error color
  static const Color error = Color(0xFFB3261E);

  /// Success color
  static const Color success = Color(0xFF4CAF50);

  /// Warning color
  static const Color warning = Color(0xFFFFC107);

  /// Info color
  static const Color info = Color(0xFF2196F3);

  /// Text color for the light theme
  static const Color textLight = Color(0xFF1C1B1F);

  /// Text color for the dark theme
  static const Color textDark = Color(0xFFE6E1E5);

  /// Secondary text color for the light theme
  static const Color textSecondaryLight = Color(0xFF49454F);

  /// Secondary text color for the dark theme
  static const Color textSecondaryDark = Color(0xFFCAC4D0);

  /// Disabled color for the light theme
  static const Color disabledLight = Color(0xFFE0E0E0);

  /// Disabled color for the dark theme
  static const Color disabledDark = Color(0xFF2C2C2C);
}
