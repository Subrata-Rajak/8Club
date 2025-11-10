import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Custom container widgets with common app styles

/// Surface container with app theme styling
class AppContainer extends StatelessWidget {
  final Widget? child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final double? borderRadius;
  final Border? border;
  final List<BoxShadow>? boxShadow;

  const AppContainer({
    super.key,
    this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.color,
    this.borderRadius,
    this.border,
    this.boxShadow,
  });

  /// Surface container with black background
  const AppContainer.surface({
    super.key,
    this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.color = AppColors.surfaceBlack2,
    this.borderRadius = 12,
    this.border,
    this.boxShadow,
  });

  /// Surface container with white background (subtle)
  const AppContainer.surfaceWhite({
    super.key,
    this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.color = AppColors.surfaceWhite2,
    this.borderRadius = 12,
    this.border,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    Widget container = Container(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        color: color,
        borderRadius: borderRadius != null
            ? BorderRadius.circular(borderRadius!)
            : null,
        border: border,
        boxShadow: boxShadow,
      ),
      child: child,
    );

    return container;
  }
}

