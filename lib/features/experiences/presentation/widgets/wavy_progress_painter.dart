import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Custom painter for wavy progress indicator
class WavyProgressPainter extends CustomPainter {
  final double progress;
  final Color activeColor;
  final Color inactiveColor;
  final double strokeWidth;

  WavyProgressPainter({
    required this.progress,
    required this.activeColor,
    required this.inactiveColor,
    this.strokeWidth = 3,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final inactivePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..color = inactiveColor;

    final activePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..color = activeColor;

    // Calculate wave parameters for smooth, curvy sine waves
    final waveCount = 12.0; // Number of complete waves (increased for more frequent waves)
    final waveLength = size.width / waveCount;
    final waveHeight = 3.5; // Increased height for more pronounced curves
    final centerY = size.height / 2;

    // Draw complete wavy line (inactive portion) using smooth sine wave
    final fullPath = Path();
    final segments = 100; // More segments for smoother curves
    
    for (int i = 0; i <= segments; i++) {
      final x = (i / segments) * size.width;
      // Use sine function for smooth, curvy waves
      final wavePhase = (x / waveLength) * 2 * math.pi;
      final y = centerY + waveHeight * math.sin(wavePhase);
      
      if (i == 0) {
        fullPath.moveTo(x, y);
      } else {
        fullPath.lineTo(x, y);
      }
    }
    
    // Draw inactive portion (full line)
    canvas.drawPath(fullPath, inactivePaint);

    // Draw active portion (first 1/3) with same curvy pattern
    if (progress > 0) {
      final activePath = Path();
      final activeWidth = size.width * progress;
      final activeSegments = (segments * progress).ceil();
      
      for (int i = 0; i <= activeSegments; i++) {
        final x = (i / activeSegments) * activeWidth;
        if (x > size.width) break;
        
        // Use same sine function for consistent curvy pattern
        final wavePhase = (x / waveLength) * 2 * math.pi;
        final y = centerY + waveHeight * math.sin(wavePhase);
        
        if (i == 0) {
          activePath.moveTo(x, y);
        } else {
          activePath.lineTo(x, y);
        }
      }

      canvas.drawPath(activePath, activePaint);
    }
  }

  @override
  bool shouldRepaint(covariant WavyProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.activeColor != activeColor ||
        oldDelegate.inactiveColor != inactiveColor ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}

