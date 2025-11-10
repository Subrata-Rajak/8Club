import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Custom loading indicator widgets

/// App-themed loading indicator
class AppLoadingIndicator extends StatelessWidget {
  final double? size;
  final Color? color;
  final double? strokeWidth;

  const AppLoadingIndicator({
    super.key,
    this.size,
    this.color = AppColors.text1,
    this.strokeWidth,
  });

  /// Small loading indicator
  const AppLoadingIndicator.small({
    super.key,
    this.size = 20,
    this.color = AppColors.text1,
    this.strokeWidth = 2,
  });

  /// Medium loading indicator
  const AppLoadingIndicator.medium({
    super.key,
    this.size = 32,
    this.color = AppColors.text1,
    this.strokeWidth = 3,
  });

  /// Large loading indicator
  const AppLoadingIndicator.large({
    super.key,
    this.size = 48,
    this.color = AppColors.text1,
    this.strokeWidth = 4,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        color: color,
        strokeWidth: strokeWidth ?? 3,
      ),
    );
  }
}

/// Full screen loading overlay
class AppLoadingOverlay extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? indicatorColor;

  const AppLoadingOverlay({
    super.key,
    required this.child,
    required this.isLoading,
    this.backgroundColor,
    this.indicatorColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: backgroundColor ?? Colors.black.withValues(alpha: 0.5),
            child: Center(
              child: AppLoadingIndicator(
                color: indicatorColor,
              ),
            ),
          ),
      ],
    );
  }
}

