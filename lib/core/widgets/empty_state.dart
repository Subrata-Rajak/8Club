import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'spacing.dart';

/// Empty state widget for displaying when there's no content
class EmptyState extends StatelessWidget {
  final String? title;
  final String? message;
  final Widget? icon;
  final Widget? action;

  const EmptyState({
    super.key,
    this.title,
    this.message,
    this.icon,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              icon!,
              const VerticalSpace.lg(),
            ],
            if (title != null)
              Text(
                title!,
                style: const TextStyle(
                  color: AppColors.text1,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            if (title != null && message != null) const VerticalSpace.sm(),
            if (message != null)
              Text(
                message!,
                style: const TextStyle(
                  color: AppColors.text3,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            if (action != null) ...[
              const VerticalSpace.lg(),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}

