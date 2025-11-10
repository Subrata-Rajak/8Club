import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/assets/image_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/widgets.dart';

/// Thank you screen - Shown after user submits onboarding details
class ThankYouScreen extends StatelessWidget {
  const ThankYouScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.base1,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ImagePaths.experienceSelectionScreenBg),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Thank you message
                    const Text(
                      'Thanks for sharing details!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.text1,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                    ),
                    const VerticalSpace.lg(),
                    // Subtitle
                    const Text(
                      'We will get back to you',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.text2,
                        fontSize: 18,
                        height: 1.5,
                      ),
                    ),
                    const VerticalSpace.xxxl(),
                    // Close app button
                    SizedBox(
                      width: double.infinity,
                      child: _buildCloseAppButton(context),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCloseAppButton(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          if (Platform.isAndroid) {
            SystemNavigator.pop();
          } else if (Platform.isIOS) {
            exit(0);
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF2A2A2A), Color(0xFF1A1A1A)],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.text1, width: 1),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Close App',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.text1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
