import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import 'wavy_progress_painter.dart';

/// Wavy progress indicator widget
class WavyProgressIndicator extends StatelessWidget {
  final double progress;
  final Color? activeColor;
  final Color? inactiveColor;
  final double? strokeWidth;

  const WavyProgressIndicator({
    super.key,
    required this.progress,
    this.activeColor,
    this.inactiveColor,
    this.strokeWidth,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(double.infinity, 4),
      painter: WavyProgressPainter(
        progress: progress,
        activeColor: activeColor ?? AppColors.primaryAccent,
        inactiveColor: inactiveColor ?? AppColors.border2,
        strokeWidth: strokeWidth ?? 3,
      ),
    );
  }
}

