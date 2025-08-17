/// Text styles for the application.
///
/// This file defines the text styles used throughout the application.
import 'package:flutter/material.dart';

import '../../core/constants/fonts.dart';

/// A utility class that holds all the text style constants for the app.
class TextStyles {
  /// Private constructor to prevent instantiation
  const TextStyles._();

  /// Creates text styles for the light theme
  static TextTheme light() {
    return const TextTheme(
      displayLarge: AppFonts.displayLarge,
      displayMedium: AppFonts.displayMedium,
      displaySmall: AppFonts.displaySmall,
      headlineLarge: AppFonts.headlineLarge,
      headlineMedium: AppFonts.headlineMedium,
      headlineSmall: AppFonts.headlineSmall,
      titleLarge: AppFonts.titleLarge,
      titleMedium: AppFonts.titleMedium,
      titleSmall: AppFonts.titleSmall,
      bodyLarge: AppFonts.bodyLarge,
      bodyMedium: AppFonts.bodyMedium,
      bodySmall: AppFonts.bodySmall,
      labelLarge: AppFonts.labelLarge,
      labelMedium: AppFonts.labelMedium,
      labelSmall: AppFonts.labelSmall,
    );
  }

  /// Creates text styles for the dark theme
  static TextTheme dark() {
    return TextTheme(
      displayLarge: AppFonts.displayLarge.copyWith(color: Colors.white),
      displayMedium: AppFonts.displayMedium.copyWith(color: Colors.white),
      displaySmall: AppFonts.displaySmall.copyWith(color: Colors.white),
      headlineLarge: AppFonts.headlineLarge.copyWith(color: Colors.white),
      headlineMedium: AppFonts.headlineMedium.copyWith(color: Colors.white),
      headlineSmall: AppFonts.headlineSmall.copyWith(color: Colors.white),
      titleLarge: AppFonts.titleLarge.copyWith(color: Colors.white),
      titleMedium: AppFonts.titleMedium.copyWith(color: Colors.white),
      titleSmall: AppFonts.titleSmall.copyWith(color: Colors.white),
      bodyLarge: AppFonts.bodyLarge.copyWith(color: Colors.white),
      bodyMedium: AppFonts.bodyMedium.copyWith(color: Colors.white),
      bodySmall: AppFonts.bodySmall.copyWith(color: Colors.white),
      labelLarge: AppFonts.labelLarge.copyWith(color: Colors.white),
      labelMedium: AppFonts.labelMedium.copyWith(color: Colors.white),
      labelSmall: AppFonts.labelSmall.copyWith(color: Colors.white),
    );
  }
}
