import 'package:flutter/material.dart';

/// App color system based on design specifications
class AppColors {
  // Prevent instantiation
  AppColors._();

  // ==================== Text Colors ====================
  /// text1 - Pure white, 100% opacity
  static const Color text1 = Color(0xFFFFFFFF);

  /// text2 - White with 72% opacity
  static const Color text2 = Color(0xB8FFFFFF);

  /// text3 - White with 48% opacity
  static const Color text3 = Color(0x7AFFFFFF);

  /// text4 - White with 24% opacity
  static const Color text4 = Color(0x3DFFFFFF);

  /// text5 - White with 24% opacity (duplicate of text4)
  static const Color text5 = Color(0x3DFFFFFF);

  // ==================== Base Colors ====================
  /// base1 - Black (#101010)
  static const Color base1 = Color(0xFF101010);

  /// base2 - Very dark gray (#151515)
  static const Color base2 = Color(0xFF151515);

  // ==================== Surface Colors ====================
  /// surfaceWhite1 - White with 2% opacity
  static const Color surfaceWhite1 = Color(0x05FFFFFF);

  /// surfaceWhite2 - White with 5% opacity
  static const Color surfaceWhite2 = Color(0x0DFFFFFF);

  /// surfaceBlack1 - Black (#101010) with 90% opacity
  static const Color surfaceBlack1 = Color(0xE6101010);

  /// surfaceBlack2 - Black (#101010) with 70% opacity
  static const Color surfaceBlack2 = Color(0xB3101010);

  /// surfaceBlack3 - Black (#101010) with 50% opacity
  static const Color surfaceBlack3 = Color(0x80101010);

  // ==================== Accent Colors ====================
  /// primaryAccent - Light blue/lavender (#9196FF)
  static const Color primaryAccent = Color(0xFF9196FF);

  /// secondaryAccent - Bright blue (#5961FF)
  static const Color secondaryAccent = Color(0xFF5961FF);

  // ==================== Semantic Colors ====================
  /// positive - Green (Note: Hex shows #FE5BDB but visually appears green)
  /// Using the visual green color instead of the hex code
  static const Color positive = Color(0xFF4CAF50); // Standard green

  /// negative - Red (#C22743)
  static const Color negative = Color(0xFFC22743);

  // ==================== Border Colors ====================
  /// border1 - White with 8% opacity
  static const Color border1 = Color(0x14FFFFFF);

  /// border2 - White with 16% opacity
  static const Color border2 = Color(0x29FFFFFF);

  /// border3 - White with 24% opacity
  static const Color border3 = Color(0x3DFFFFFF);

  // ==================== Gradient Border ====================
  /// Gradient border - Used for special border effects
  static const LinearGradient borderGradient = LinearGradient(
    colors: [
      Color(0x3DFFFFFF),
      Color(0x14FFFFFF),
    ],
  );

  // ==================== Background Blur Values ====================
  /// Background blur effect values
  static const double bgBlur12 = 12.0;
  static const double bgBlur40 = 40.0;
  static const double bgBlur80 = 80.0;

  // ==================== Helper Methods ====================
  /// Get text color by index (1-5)
  static Color getTextColor(int index) {
    switch (index) {
      case 1:
        return text1;
      case 2:
        return text2;
      case 3:
        return text3;
      case 4:
        return text4;
      case 5:
        return text5;
      default:
        return text1;
    }
  }

  /// Get surface color by name
  static Color getSurfaceColor(String name) {
    switch (name.toLowerCase()) {
      case 'white1':
        return surfaceWhite1;
      case 'white2':
        return surfaceWhite2;
      case 'black1':
        return surfaceBlack1;
      case 'black2':
        return surfaceBlack2;
      case 'black3':
        return surfaceBlack3;
      default:
        return surfaceBlack1;
    }
  }

  /// Get border color by index (1-3)
  static Color getBorderColor(int index) {
    switch (index) {
      case 1:
        return border1;
      case 2:
        return border2;
      case 3:
        return border3;
      default:
        return border1;
    }
  }
}

