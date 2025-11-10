import 'package:flutter/material.dart';

/// Reusable spacing widgets for consistent spacing throughout the app

/// Vertical spacing widget
class VerticalSpace extends StatelessWidget {
  final double height;

  const VerticalSpace(this.height, {super.key});

  /// Common vertical spacing sizes
  const VerticalSpace.xs({super.key}) : height = 4;
  const VerticalSpace.sm({super.key}) : height = 8;
  const VerticalSpace.md({super.key}) : height = 12;
  const VerticalSpace.lg({super.key}) : height = 16;
  const VerticalSpace.xl({super.key}) : height = 24;
  const VerticalSpace.xxl({super.key}) : height = 32;
  const VerticalSpace.xxxl({super.key}) : height = 40;

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height);
  }
}

/// Horizontal spacing widget
class HorizontalSpace extends StatelessWidget {
  final double width;

  const HorizontalSpace(this.width, {super.key});

  /// Common horizontal spacing sizes
  const HorizontalSpace.xs({super.key}) : width = 4;
  const HorizontalSpace.sm({super.key}) : width = 8;
  const HorizontalSpace.md({super.key}) : width = 12;
  const HorizontalSpace.lg({super.key}) : width = 16;
  const HorizontalSpace.xl({super.key}) : width = 24;
  const HorizontalSpace.xxl({super.key}) : width = 32;

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: width);
  }
}

/// Spacing constants for consistent spacing values
class Spacing {
  Spacing._();

  // Extra small
  static const double xs = 4.0;

  // Small
  static const double sm = 8.0;

  // Medium
  static const double md = 12.0;

  // Large
  static const double lg = 16.0;

  // Extra large
  static const double xl = 24.0;

  // 2X Extra large
  static const double xxl = 32.0;

  // 3X Extra large
  static const double xxxl = 40.0;
}

