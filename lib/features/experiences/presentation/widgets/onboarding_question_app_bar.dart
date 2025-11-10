import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import 'wavy_progress_indicator.dart';

/// Custom app bar for onboarding question screen
class OnboardingQuestionAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const OnboardingQuestionAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: preferredSize,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceWhite1,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Back button
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: AppColors.text1,
                      size: 24,
                    ),
                    onPressed: () => context.pop(),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  // Progress indicator (wavy line) - centered
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: WavyProgressIndicator(
                        progress: 0.67, // 2/3 progress for step 02
                      ),
                    ),
                  ),
                  // Close button
                  IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: AppColors.text1,
                      size: 24,
                    ),
                    onPressed: () => context.pop(),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

