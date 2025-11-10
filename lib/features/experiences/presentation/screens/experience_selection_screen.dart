import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/assets/icon_paths.dart';
import '../../../../core/assets/image_paths.dart';
import '../../../../core/routes/route_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/widgets.dart';
import '../blocs/experiences/experiences_bloc.dart';
import '../blocs/experiences/experiences_event.dart';
import '../blocs/experiences/experiences_state.dart';
import '../widgets/experience_selection_app_bar.dart';
import '../widgets/experience_stamp.dart';

/// Screen for selecting experiences
class ExperienceSelectionScreen extends StatefulWidget {
  const ExperienceSelectionScreen({super.key});

  @override
  State<ExperienceSelectionScreen> createState() =>
      _ExperienceSelectionScreenState();
}

class _ExperienceSelectionScreenState extends State<ExperienceSelectionScreen> {
  final TextEditingController _noteController = TextEditingController();

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ExperiencesBloc>(
      create: (context) {
        final bloc = GetIt.instance<ExperiencesBloc>();
        // Fetch experiences on init
        bloc.add(FetchExperiences());
        return bloc;
      },
      child: Scaffold(
        backgroundColor: AppColors.base1,
        resizeToAvoidBottomInset: true,
        appBar: const ExperienceSelectionAppBar(),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(ImagePaths.experienceSelectionScreenBg),
              fit: BoxFit.cover,
            ),
          ),
          child: BlocBuilder<ExperiencesBloc, ExperiencesState>(
            builder: (context, state) {
              if (state is ExperiencesLoading) {
                return _buildLoadingState();
              }

              if (state is ExperiencesError) {
                return _buildErrorState(context, state.message);
              }

              if (state is ExperiencesLoaded) {
                return _buildLoadedState(context, state);
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  /// Loading state widget
  Widget _buildLoadingState() {
    return const Center(child: AppLoadingIndicator());
  }

  /// Error state widget
  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Error: $message',
            style: const TextStyle(color: AppColors.negative),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.read<ExperiencesBloc>().add(FetchExperiences());
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  /// Build Next button with active/inactive states
  Widget _buildNextButton({
    required BuildContext context,
    required bool isEnabled,
    required VoidCallback onPressed,
    VoidCallback? onDisabledTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isEnabled ? onPressed : (onDisabledTap ?? () {}),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            // Active: gradient background, inactive: very dark gray (almost black)
            gradient: isEnabled
                ? const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF2A2A2A), // Lighter gray at top
                      Color(0xFF1A1A1A), // Darker gray at bottom
                    ],
                  )
                : null,
            color: isEnabled
                ? null
                : const Color(
                    0xFF0F0F0F,
                  ), // Very dark gray, almost black for inactive
            borderRadius: BorderRadius.circular(12),
            // Active: bright white border, inactive: subtle dark gray border
            border: Border.all(
              color: isEnabled
                  ? AppColors
                        .text1 // Bright white border
                  : const Color(
                      0xFF2A2A2A,
                    ), // Subtle dark gray border (lighter than background)
              width: 1,
            ),
            // Add subtle top highlight for recessed/debossed effect when inactive
            boxShadow: isEnabled
                ? null
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      offset: const Offset(0, 1),
                      blurRadius: 2,
                      spreadRadius: 0,
                    ),
                    // Subtle top highlight
                    BoxShadow(
                      color: const Color(0xFF1A1A1A).withValues(alpha: 0.5),
                      offset: const Offset(0, -0.5),
                      blurRadius: 1,
                      spreadRadius: 0,
                    ),
                  ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Next',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isEnabled
                      ? AppColors
                            .text1 // Bright white text
                      : const Color(0xFF6A6A6A), // Muted medium gray text
                ),
              ),
              const HorizontalSpace.sm(),
              SvgPicture.asset(
                IconPaths.nextButtonArrow,
                width: 20,
                height: 20,
                colorFilter: ColorFilter.mode(
                  isEnabled
                      ? AppColors
                            .text1 // Bright white icon
                      : const Color(0xFF6A6A6A), // Muted medium gray icon
                  BlendMode.srcIn,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Loaded state widget - main content
  Widget _buildLoadedState(BuildContext context, ExperiencesLoaded state) {
    return SafeArea(
      child: MediaQuery(
        data: MediaQuery.of(context),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

            return SingleChildScrollView(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                bottom: keyboardHeight > 0 ? keyboardHeight + 20 : 20,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Step number
                    const Text(
                      '01',
                      style: TextStyle(
                        color: AppColors.text3,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const VerticalSpace.md(),
                    // Question
                    const Text(
                      'What kind of hotspots do you want to host?',
                      style: TextStyle(
                        color: AppColors.text1,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                    ),
                    const VerticalSpace.md(),
                    // Experience stamps
                    SizedBox(
                      height: 140,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        itemCount: state.experiences.length,
                        itemBuilder: (context, index) {
                          final experience = state.experiences[index];
                          final isSelected = state.selectedIds.contains(
                            experience.id,
                          );
                          // Disable if 3 are already selected and this one is not selected
                          final isDisabled =
                              state.selectedIds.length >= 3 && !isSelected;
                          // Alternate rotation: even indices counter-clockwise, odd indices clockwise
                          // Using slight variations for a more natural look
                          final rotation = index % 2 == 0
                              ? -3.0 -
                                    (index % 3) *
                                        0.5 // Counter-clockwise: -3 to -4.5 degrees
                              : 2.5 +
                                    (index % 3) *
                                        0.5; // Clockwise: 2.5 to 4 degrees
                          return ExperienceStamp(
                            experience: experience,
                            isSelected: isSelected,
                            isDisabled: isDisabled,
                            rotation: rotation,
                            onTap: () {
                              context.read<ExperiencesBloc>().add(
                                ToggleExperienceSelection(experience.id),
                              );
                            },
                          );
                        },
                      ),
                    ),
                    const VerticalSpace.md(),
                    // Description input
                    AdaptiveTextField(
                      controller: _noteController,
                      hintText: '/ Describe your perfect hotspot',
                      maxLength: 250,
                      minLines: 5,
                      maxLines: 10,
                      onChanged: (value) {
                        context.read<ExperiencesBloc>().add(
                          UpdateExperienceNote(value),
                        );
                      },
                    ),
                    const VerticalSpace(20),
                    // Next button
                    SizedBox(
                      width: double.infinity,
                      child: _buildNextButton(
                        context: context,
                        isEnabled:
                            state.selectedIds.length == 3 &&
                            state.note.trim().isNotEmpty,
                        onPressed: () {
                          // Validate before submitting
                          if (state.selectedIds.length != 3) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Please select exactly 3 hotspots to proceed.',
                                ),
                                backgroundColor: AppColors.negative,
                                duration: Duration(seconds: 3),
                              ),
                            );
                            return;
                          }
                          
                          if (state.note.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Please add a note describing your perfect hotspot.',
                                ),
                                backgroundColor: AppColors.negative,
                                duration: Duration(seconds: 3),
                              ),
                            );
                            return;
                          }

                          context.read<ExperiencesBloc>().add(
                            SubmitExperiences(
                              selectedIds: state.selectedIds.toList(),
                              note: state.note,
                            ),
                          );
                          context.push(RoutePaths.onboardingQuestion);
                        },
                        onDisabledTap: () {
                          // Show validation error when button is disabled
                          if (state.selectedIds.length != 3) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Please select exactly 3 hotspots to proceed.',
                                ),
                                backgroundColor: AppColors.negative,
                                duration: Duration(seconds: 3),
                              ),
                            );
                          } else if (state.note.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Please add a note describing your perfect hotspot.',
                                ),
                                backgroundColor: AppColors.negative,
                                duration: Duration(seconds: 3),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                    // Add extra space at bottom when keyboard is visible
                    SizedBox(height: keyboardHeight > 0 ? 0 : 40),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
