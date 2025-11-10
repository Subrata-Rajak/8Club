import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/assets/icon_paths.dart';
import '../../../../core/assets/image_paths.dart';
import '../../../../core/routes/route_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/widgets.dart';

/// Get Started screen - Entry point of the app
class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Top spacing - use Expanded instead of Spacer
                    Expanded(
                      child: Container(),
                    ),
                    // App title or welcome message
                    const Text(
                      'Welcome to',
                      style: TextStyle(
                        color: AppColors.text3,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const VerticalSpace.sm(),
                    const Text(
                      '8Club',
                      style: TextStyle(
                        color: AppColors.text1,
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                    ),
                    const VerticalSpace.md(),
                    // Description
                    const Text(
                      'Create and host amazing experiences. Connect with people who share your passions.',
                      style: TextStyle(
                        color: AppColors.text2,
                        fontSize: 18,
                        height: 1.5,
                      ),
                    ),
                    const VerticalSpace.xxxl(),
                    // Get Started button
                    SizedBox(
                      width: double.infinity,
                      child: _buildGetStartedButton(context),
                    ),
                    const VerticalSpace(40),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildGetStartedButton(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          context.push(RoutePaths.experiences);
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF2A2A2A), // Lighter gray at top
                Color(0xFF1A1A1A), // Darker gray at bottom
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.text1, // Bright white border
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Get Started',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.text1, // Bright white text
                ),
              ),
              const HorizontalSpace.sm(),
              SvgPicture.asset(
                IconPaths.nextButtonArrow,
                width: 20,
                height: 20,
                colorFilter: const ColorFilter.mode(
                  AppColors.text1, // Bright white icon
                  BlendMode.srcIn,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

