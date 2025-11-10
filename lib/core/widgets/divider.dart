import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Custom divider widgets with consistent styling

/// Horizontal divider with app theme colors
class AppDivider extends StatelessWidget {
  final double? height;
  final double? thickness;
  final Color? color;
  final double? indent;
  final double? endIndent;

  const AppDivider({
    super.key,
    this.height,
    this.thickness,
    this.color,
    this.indent,
    this.endIndent,
  });

  /// Light divider (subtle)
  const AppDivider.light({
    super.key,
    this.height,
    this.thickness = 1,
    this.color = AppColors.border1,
    this.indent,
    this.endIndent,
  });

  /// Medium divider
  const AppDivider.medium({
    super.key,
    this.height,
    this.thickness = 1,
    this.color = AppColors.border2,
    this.indent,
    this.endIndent,
  });

  /// Strong divider (more visible)
  const AppDivider.strong({
    super.key,
    this.height,
    this.thickness = 1,
    this.color = AppColors.border3,
    this.indent,
    this.endIndent,
  });

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: height,
      thickness: thickness,
      color: color,
      indent: indent,
      endIndent: endIndent,
    );
  }
}

