import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// App text styles following the design system
class AppTextStyles {
  // Font family
  static const String fontFamily = 'Space Grotesk';

  // Helper method to get Space Grotesk text style
  static TextStyle _spaceGrotesk({
    required double fontSize,
    required double lineHeight,
    required FontWeight fontWeight,
    required double letterSpacing,
  }) {
    return GoogleFonts.spaceGrotesk(
      fontSize: fontSize,
      height: lineHeight / fontSize, // Convert line height to height multiplier
      fontWeight: fontWeight,
      letterSpacing: letterSpacing,
    );
  }

  // Heading Styles
  static TextStyle get h1Bold => _spaceGrotesk(
        fontSize: 32,
        lineHeight: 40,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.03 * 32, // -3% of font size
      );

  static TextStyle get h1Regular => _spaceGrotesk(
        fontSize: 32,
        lineHeight: 40,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.03 * 32, // -3% of font size
      );

  static TextStyle get h2Bold => _spaceGrotesk(
        fontSize: 24,
        lineHeight: 32,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.02 * 24, // -2% of font size
      );

  static TextStyle get h2Regular => _spaceGrotesk(
        fontSize: 24,
        lineHeight: 32,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.02 * 24, // -2% of font size
      );

  static TextStyle get h3Bold => _spaceGrotesk(
        fontSize: 20,
        lineHeight: 28,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.01 * 20, // -1% of font size
      );

  static TextStyle get h3Regular => _spaceGrotesk(
        fontSize: 20,
        lineHeight: 28,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.01 * 20, // -1% of font size
      );

  // Body Styles
  static TextStyle get b1Bold => _spaceGrotesk(
        fontSize: 18,
        lineHeight: 26,
        fontWeight: FontWeight.w800,
        letterSpacing: 0,
      );

  static TextStyle get b1Regular => _spaceGrotesk(
        fontSize: 18,
        lineHeight: 26,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
      );

  static TextStyle get b2Bold => _spaceGrotesk(
        fontSize: 16,
        lineHeight: 24,
        fontWeight: FontWeight.w800,
        letterSpacing: 0,
      );

  static TextStyle get b2Regular => _spaceGrotesk(
        fontSize: 16,
        lineHeight: 24,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
      );

  static TextStyle get b3Bold => _spaceGrotesk(
        fontSize: 14,
        lineHeight: 22,
        fontWeight: FontWeight.w800,
        letterSpacing: 0,
      );

  static TextStyle get b3Regular => _spaceGrotesk(
        fontSize: 14,
        lineHeight: 22,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
      );

  // Small Styles
  static TextStyle get s1Bold => _spaceGrotesk(
        fontSize: 12,
        lineHeight: 18,
        fontWeight: FontWeight.w800,
        letterSpacing: 0,
      );

  static TextStyle get s1Regular => _spaceGrotesk(
        fontSize: 12,
        lineHeight: 18,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
      );

  static TextStyle get s2Bold => _spaceGrotesk(
        fontSize: 10,
        lineHeight: 16,
        fontWeight: FontWeight.w800,
        letterSpacing: 0,
      );

  static TextStyle get s2Regular => _spaceGrotesk(
        fontSize: 10,
        lineHeight: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
      );

  static TextStyle get s3Bold => _spaceGrotesk(
        fontSize: 8,
        lineHeight: 14,
        fontWeight: FontWeight.w800,
        letterSpacing: 0,
      );

  static TextStyle get s3Regular => _spaceGrotesk(
        fontSize: 8,
        lineHeight: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
      );

  /// Get complete text theme with all styles mapped
  static TextTheme get textTheme {
    return GoogleFonts.spaceGroteskTextTheme().copyWith(
      // Heading styles
      displayLarge: h1Bold,
      displayMedium: h1Regular,
      displaySmall: h2Bold,
      headlineMedium: h2Regular,
      headlineSmall: h3Bold,
      titleLarge: h3Regular,
      // Body styles
      titleMedium: b1Bold,
      titleSmall: b1Regular,
      bodyLarge: b2Bold,
      bodyMedium: b2Regular,
      bodySmall: b3Bold,
      labelLarge: b3Regular,
      // Small styles
      labelMedium: s1Bold,
      labelSmall: s1Regular,
    );
  }

  // Prevent instantiation
  AppTextStyles._();
}

