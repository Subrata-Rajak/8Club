import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Custom painter for stamp with serrated edges
class StampPainter extends CustomPainter {
  final Color color;
  final Color borderColor;

  StampPainter({
    required this.color,
    this.borderColor = AppColors.text1,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final path = Path();
    final serrationSize = 8.0;
    final serrationCount = 8;

    // Top edge with serrations
    path.moveTo(serrationSize, 0);
    for (int i = 0; i < serrationCount; i++) {
      final x = serrationSize + (i * (size.width - 2 * serrationSize) / serrationCount);
      path.lineTo(x, 0);
      path.lineTo(x + serrationSize / 2, serrationSize);
      path.lineTo(x + serrationSize, 0);
    }
    path.lineTo(size.width - serrationSize, 0);

    // Right edge
    path.lineTo(size.width, serrationSize);
    path.lineTo(size.width, size.height - serrationSize);

    // Bottom edge with serrations
    for (int i = 0; i < serrationCount; i++) {
      final x = size.width - serrationSize - (i * (size.width - 2 * serrationSize) / serrationCount);
      path.lineTo(x, size.height);
      path.lineTo(x - serrationSize / 2, size.height - serrationSize);
      path.lineTo(x - serrationSize, size.height);
    }
    path.lineTo(serrationSize, size.height);

    // Left edge
    path.lineTo(0, size.height - serrationSize);
    path.lineTo(0, serrationSize);
    path.close();

    canvas.drawPath(path, paint);
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

