import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../core/assets/icon_paths.dart';
import '../../../../core/assets/image_paths.dart';
import '../../../../core/injection_container.dart' as di;
import '../../../../core/routes/route_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/widgets.dart';
import '../blocs/audio_recording/audio_recording_bloc.dart';
import '../blocs/audio_recording/audio_recording_event.dart';
import '../blocs/audio_recording/audio_recording_state.dart';
import '../blocs/video_recording/video_recording_bloc.dart';
import '../blocs/video_recording/video_recording_event.dart';
import '../blocs/video_recording/video_recording_state.dart';
import '../widgets/onboarding_question_app_bar.dart';

/// Screen for onboarding questions
class OnboardingQuestionScreen extends StatefulWidget {
  const OnboardingQuestionScreen({super.key});

  @override
  State<OnboardingQuestionScreen> createState() =>
      _OnboardingQuestionScreenState();
}

class _OnboardingQuestionScreenState extends State<OnboardingQuestionScreen> {
  final TextEditingController _questionController = TextEditingController();

  String? _selectedMode; // 'audio' or 'video' or null

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }

  bool _hasInput(BuildContext context) {
    final audioState = context.read<AudioRecordingBloc>().state;
    final videoState = context.read<VideoRecordingBloc>().state;
    // User must type a note AND have at least one recording (audio or video)
    final hasNote = _questionController.text.trim().isNotEmpty;
    final hasAudio = audioState.audioPath != null;
    final hasVideo = videoState.videoPath != null;
    return hasNote && (hasAudio || hasVideo);
  }

  Future<void> _handleStartRecording(BuildContext context) async {
    // Check permission before starting
    PermissionStatus status = await Permission.microphone.status;

    if (!status.isGranted) {
      status = await Permission.microphone.request();

      if (status.isDenied) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Microphone permission was denied. Please grant permission to record audio.',
              ),
              backgroundColor: AppColors.negative,
              duration: Duration(seconds: 3),
            ),
          );
        }
        return;
      }

      if (status.isPermanentlyDenied) {
        if (context.mounted) {
          final shouldOpen = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              backgroundColor: AppColors.base2,
              title: const Text(
                'Microphone Permission Required',
                style: TextStyle(color: AppColors.text1),
              ),
              content: const Text(
                'Microphone permission is permanently denied. Please enable it in Settings to record audio.',
                style: TextStyle(color: AppColors.text2),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: AppColors.text3),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text(
                    'Open Settings',
                    style: TextStyle(color: AppColors.primaryAccent),
                  ),
                ),
              ],
            ),
          );

          if (shouldOpen == true) {
            await openAppSettings();
          }
        }
        return;
      }

      if (!status.isGranted) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Microphone permission is required to record audio',
              ),
              backgroundColor: AppColors.negative,
            ),
          );
        }
        return;
      }
    }

    // Dispatch event to BLoC
    if (!context.mounted) return;
    context.read<AudioRecordingBloc>().add(StartRecording());
  }

  Future<void> _handleStartVideoRecording(BuildContext context) async {
    // Check permissions before starting
    PermissionStatus cameraStatus = await Permission.camera.status;
    PermissionStatus microphoneStatus = await Permission.microphone.status;

    if (!cameraStatus.isGranted) {
      cameraStatus = await Permission.camera.request();
      if (cameraStatus.isDenied) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Camera permission was denied. Please grant permission to record video.',
              ),
              backgroundColor: AppColors.negative,
              duration: Duration(seconds: 3),
            ),
          );
        }
        return;
      }

      if (cameraStatus.isPermanentlyDenied) {
        if (context.mounted) {
          final shouldOpen = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              backgroundColor: AppColors.base2,
              title: const Text(
                'Camera Permission Required',
                style: TextStyle(color: AppColors.text1),
              ),
              content: const Text(
                'Camera permission is permanently denied. Please enable it in Settings to record video.',
                style: TextStyle(color: AppColors.text2),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: AppColors.text3),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text(
                    'Open Settings',
                    style: TextStyle(color: AppColors.primaryAccent),
                  ),
                ),
              ],
            ),
          );

          if (shouldOpen == true) {
            await openAppSettings();
          }
        }
        return;
      }
    }

    if (!microphoneStatus.isGranted) {
      microphoneStatus = await Permission.microphone.request();
      if (microphoneStatus.isDenied) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Microphone permission is required for video recording.',
              ),
              backgroundColor: AppColors.negative,
            ),
          );
        }
        return;
      }
    }

    // Dispatch event to BLoC
    if (!context.mounted) return;
    
    final videoState = context.read<VideoRecordingBloc>().state;
    if (videoState is VideoCameraInitialized) {
      context.read<VideoRecordingBloc>().add(StartVideoRecording());
    } else {
      // Wait for camera to initialize
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Camera is initializing. Please wait...'),
          backgroundColor: AppColors.negative,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AudioRecordingBloc>(
          create: (context) => di.getIt<AudioRecordingBloc>(),
        ),
        BlocProvider<VideoRecordingBloc>(
          create: (context) => di.getIt<VideoRecordingBloc>(),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<AudioRecordingBloc, AudioRecordingState>(
            listener: (context, state) {
              if (state is AudioRecordingError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: AppColors.negative,
                  ),
                );
              }
            },
          ),
          BlocListener<VideoRecordingBloc, VideoRecordingState>(
            listener: (context, state) {
              if (state is VideoRecordingError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: AppColors.negative,
                  ),
                );
              }
            },
          ),
        ],
        child: Scaffold(
          backgroundColor: AppColors.base1,
          resizeToAvoidBottomInset: true,
          appBar: const OnboardingQuestionAppBar(),
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
                  final keyboardHeight = MediaQuery.of(
                    context,
                  ).viewInsets.bottom;

                  return SingleChildScrollView(
                    padding: EdgeInsets.only(
                      left: 20,
                      right: 20,
                      bottom: keyboardHeight > 0 ? keyboardHeight + 20 : 20,
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // Step number
                          const Text(
                            '02',
                            style: TextStyle(
                              color: AppColors.text3,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const VerticalSpace.md(),
                          // Question
                          const Text(
                            'Why do you want to host with us?',
                            style: TextStyle(
                              color: AppColors.text1,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                          ),
                          const VerticalSpace.sm(),
                          // Instruction text
                          const Text(
                            'Tell us about your intent and what motivates you to create experiences.',
                            style: TextStyle(
                              color: AppColors.text3,
                              fontSize: 16,
                              height: 1.4,
                            ),
                          ),
                          const VerticalSpace.md(),
                          // Text input field
                          AdaptiveTextField(
                            controller: _questionController,
                            hintText: '/ Start typing here',
                            maxLength: 600,
                            minLines: 4,
                            maxLines: 10,
                            defaultHeight: 160,
                            keyboardHeight: 100,
                            onChanged: (_) {
                              setState(
                                () {},
                              ); // Rebuild to update Next button state
                            },
                          ),
                          const VerticalSpace.md(),
                          // Audio recording interface and attachment card
                          BlocBuilder<AudioRecordingBloc, AudioRecordingState>(
                            builder: (context, audioState) {
                              if (audioState is AudioRecordingInProgress) {
                                return _buildAudioRecordingInterface(
                                  context,
                                  audioState,
                                );
                              } else if (audioState
                                      is AudioRecordingCompleted ||
                                  audioState is AudioPlaying ||
                                  audioState is AudioPaused) {
                                return _buildAudioAttachmentCard(
                                  context,
                                  audioState,
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                          // Video recording interface and attachment card
                          BlocBuilder<VideoRecordingBloc, VideoRecordingState>(
                            builder: (context, videoState) {
                              if (videoState is VideoRecordingInProgress) {
                                return _buildVideoRecordingInterface(
                                  context,
                                  videoState,
                                );
                              } else if (videoState is VideoRecordingCompleted ||
                                  videoState is VideoPlaying ||
                                  videoState is VideoPaused) {
                                return _buildVideoAttachmentCard(
                                  context,
                                  videoState,
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                          const VerticalSpace(20),
                          // Bottom buttons: mode selection and Next
                          _buildBottomButtons(context),
                          SizedBox(height: keyboardHeight > 0 ? 0 : 40),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAudioRecordingInterface(
    BuildContext context,
    AudioRecordingInProgress state,
  ) {
    return Container(
      height: 150, // Fixed height to prevent resizing
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF202024), // Dark gray background
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: Recording text, timer, and delete button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Timer and delete button
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // "Recording Audio..." text
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Audio Recorded • ',
                          style: TextStyle(
                            color: AppColors.text1,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        // Duration timer
                        Text(
                          _formatDuration(state.audioDuration),
                          style: const TextStyle(
                            color: AppColors.text4,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    // Delete button (purple outline)
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: const Icon(
                        Icons.delete_outline,
                        color: AppColors.primaryAccent,
                        size: 24,
                      ),
                      onPressed: () {
                        context.read<AudioRecordingBloc>().add(CancelRecording());
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Bottom row: Pause button and waveform
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Pause button (circular purple with white pause icon)
              GestureDetector(
                onTap: () {
                  context.read<AudioRecordingBloc>().add(StopRecording());
                },
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.primaryAccent,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.pause,
                    color: AppColors.text1,
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Waveform visualization with fixed height
              Expanded(
                child: SizedBox(
                  height: 50, // Fixed height for waveform area
                  child: _buildWaveform(state.waveformData),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWaveform(List<double> waveformData) {
    // Animated waveform visualization with bars
    return Align(
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(20, (index) {
          final height = waveformData.isNotEmpty
              ? waveformData[index % waveformData.length]
              : 20.0 + (index % 5) * 8.0;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            width: 3,
            height: height.clamp(10.0, 50.0),
            decoration: BoxDecoration(
              color: AppColors.text1,
              borderRadius: BorderRadius.circular(1.5),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildVideoRecordingInterface(
    BuildContext context,
    VideoRecordingInProgress state,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      height: 200,
      decoration: BoxDecoration(
        color: const Color(0xFF202024),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          // Camera preview
          if (state.cameraController != null &&
              state.cameraController!.value.isInitialized)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: CameraPreview(state.cameraController!),
              ),
            ),
          // Overlay with controls
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Duration timer
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _formatDuration(state.videoDuration),
                    style: const TextStyle(
                      color: AppColors.text1,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                // Stop and delete buttons
                Row(
                  children: [
                    // Stop button
                    GestureDetector(
                      onTap: () {
                        context
                            .read<VideoRecordingBloc>()
                            .add(StopVideoRecording());
                      },
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.primaryAccent,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.stop,
                          color: AppColors.text1,
                          size: 24,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Delete button
                    IconButton(
                      icon: const Icon(
                        Icons.delete_outline,
                        color: AppColors.primaryAccent,
                        size: 24,
                      ),
                      onPressed: () {
                        context
                            .read<VideoRecordingBloc>()
                            .add(CancelVideoRecording());
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoAttachmentCard(
    BuildContext context,
    VideoRecordingState state,
  ) {
    final isPlaying = state is VideoPlaying;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF202024),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Video thumbnail with play button
          GestureDetector(
            onTap: () {
              context.read<VideoRecordingBloc>().add(ToggleVideoPlayback());
            },
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.surfaceBlack2,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Play/Pause icon
                  Icon(
                    isPlaying ? Icons.pause : Icons.play_arrow,
                    color: AppColors.text1,
                    size: 32,
                  ),
                ],
              ),
            ),
          ),
          const HorizontalSpace.md(),
          // Video info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Video Recorded',
                  style: TextStyle(
                    color: AppColors.text1,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const VerticalSpace.xs(),
                Text(
                  _formatDuration(state.videoDuration),
                  style: const TextStyle(
                    color: AppColors.text3,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          // Delete button
          IconButton(
            icon: const Icon(
              Icons.delete_outline,
              color: AppColors.primaryAccent,
              size: 24,
            ),
            onPressed: () {
              context.read<VideoRecordingBloc>().add(DeleteVideo());
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAudioAttachmentCard(
    BuildContext context,
    AudioRecordingState state,
  ) {
    final isPlaying = state is AudioPlaying;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF202024), // Dark gray background
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Play/Pause button (circular purple with white play/pause icon)
          GestureDetector(
            onTap: () {
              context.read<AudioRecordingBloc>().add(ToggleAudioPlayback());
            },
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primaryAccent,
                shape: BoxShape.circle,
              ),
              child: Icon(
                isPlaying ? Icons.pause : Icons.play_arrow,
                color: AppColors.text1,
                size: 24,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Text with "Audio Recorded • duration"
          Expanded(
            child: Row(
              children: [
                const Text(
                  'Audio Recorded',
                  style: TextStyle(
                    color: AppColors.text1,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (state.audioDuration.inSeconds > 0) ...[
                  const SizedBox(width: 8),
                  Container(
                    width: 4,
                    height: 4,
                    decoration: const BoxDecoration(
                      color: AppColors.text3,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _formatDuration(state.audioDuration),
                    style: const TextStyle(
                      color: AppColors.text3,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Delete icon (purple outline)
          IconButton(
            icon: const Icon(
              Icons.delete_outline,
              color: AppColors.primaryAccent,
              size: 24,
            ),
            onPressed: () {
              context.read<AudioRecordingBloc>().add(DeleteAudio());
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButtons(BuildContext context) {
    final audioState = context.watch<AudioRecordingBloc>().state;
    final videoState = context.watch<VideoRecordingBloc>().state;
    final isAudioRecording = audioState is AudioRecordingInProgress;
    final isVideoRecording = videoState is VideoRecordingInProgress;
    final hasAudio = audioState.audioPath != null;
    final hasVideo = videoState.videoPath != null;

    return Row(
      children: [
        // Mode selection buttons
        Expanded(
          child: Row(
            children: [
              // Audio button
              Expanded(
                child: _buildModeButton(
                  icon: Icons.mic,
                  isSelected: _selectedMode == 'audio',
                  isDisabled: hasVideo, // Disable if video exists
                  onTap: hasVideo
                      ? () {
                          // Show message to delete video first
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Please delete the video recording before switching to audio mode.',
                              ),
                              backgroundColor: AppColors.negative,
                              duration: Duration(seconds: 3),
                            ),
                          );
                        }
                      : () {
                          if (_selectedMode == 'audio' && !isAudioRecording) {
                            // Start recording if audio mode is already selected
                            _handleStartRecording(context);
                          } else if (_selectedMode != 'audio') {
                            // Select audio mode and start recording
                            setState(() {
                              _selectedMode = 'audio';
                            });
                            _handleStartRecording(context);
                          }
                        },
                ),
              ),
              // Separator
              Container(
                width: 1,
                height: 24,
                color: AppColors.border1,
                margin: const EdgeInsets.symmetric(horizontal: 4),
              ),
              // Video button
              Expanded(
                child: _buildModeButton(
                  icon: Icons.videocam,
                  isSelected: _selectedMode == 'video',
                  isDisabled: hasAudio, // Disable if audio exists
                  onTap: hasAudio
                      ? () {
                          // Show message to delete audio first
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Please delete the audio recording before switching to video mode.',
                              ),
                              backgroundColor: AppColors.negative,
                              duration: Duration(seconds: 3),
                            ),
                          );
                        }
                      : () {
                          if (_selectedMode == 'video' && !isVideoRecording) {
                            // Start recording if video mode is already selected
                            _handleStartVideoRecording(context);
                          } else if (_selectedMode != 'video') {
                            // Select video mode and start recording
                            setState(() {
                              _selectedMode = 'video';
                            });
                            _handleStartVideoRecording(context);
                          }
                        },
                ),
              ),
            ],
          ),
        ),
        const HorizontalSpace.md(),
        // Next button
        Expanded(flex: 2, child: _buildNextButton(context)),
      ],
    );
  }

  Widget _buildModeButton({
    required IconData icon,
    required bool isSelected,
    required VoidCallback? onTap,
    bool isDisabled = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.surfaceWhite2
                : AppColors.surfaceBlack2,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.border2 : AppColors.border1,
              width: 1,
            ),
          ),
          child: Icon(
            icon,
            color: isDisabled ? AppColors.text4 : AppColors.text1,
            size: 24,
          ),
        ),
      ),
    );
  }

  Widget _buildNextButton(BuildContext context) {
    final isEnabled = _hasInput(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isEnabled
            ? () {
                // Validate before submitting
                final audioState = context.read<AudioRecordingBloc>().state;
                final videoState = context.read<VideoRecordingBloc>().state;
                final hasNote = _questionController.text.trim().isNotEmpty;
                final hasAudio = audioState.audioPath != null;
                final hasVideo = videoState.videoPath != null;

                if (!hasNote) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Please type a note before proceeding.',
                      ),
                      backgroundColor: AppColors.negative,
                      duration: Duration(seconds: 3),
                    ),
                  );
                  return;
                }

                if (!hasAudio && !hasVideo) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Please record an audio or video before proceeding.',
                      ),
                      backgroundColor: AppColors.negative,
                      duration: Duration(seconds: 3),
                    ),
                  );
                  return;
                }

                // Navigate to thank you screen
                context.push(RoutePaths.thankYou);
              }
            : () {
                // Show validation error when button is disabled
                final audioState = context.read<AudioRecordingBloc>().state;
                final videoState = context.read<VideoRecordingBloc>().state;
                final hasNote = _questionController.text.trim().isNotEmpty;
                final hasAudio = audioState.audioPath != null;
                final hasVideo = videoState.videoPath != null;

                if (!hasNote) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Please type a note before proceeding.',
                      ),
                      backgroundColor: AppColors.negative,
                      duration: Duration(seconds: 3),
                    ),
                  );
                } else if (!hasAudio && !hasVideo) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Please record an audio or video before proceeding.',
                      ),
                      backgroundColor: AppColors.negative,
                      duration: Duration(seconds: 3),
                    ),
                  );
                }
              },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            gradient: isEnabled
                ? const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF2A2A2A), Color(0xFF1A1A1A)],
                  )
                : null,
            color: isEnabled ? null : const Color(0xFF0F0F0F),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isEnabled ? AppColors.text1 : const Color(0xFF2A2A2A),
              width: 1,
            ),
            boxShadow: isEnabled
                ? null
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      offset: const Offset(0, 1),
                      blurRadius: 2,
                      spreadRadius: 0,
                    ),
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
                  color: isEnabled ? AppColors.text1 : const Color(0xFF6A6A6A),
                ),
              ),
              const HorizontalSpace.sm(),
              SvgPicture.asset(
                IconPaths.nextButtonArrow,
                width: 20,
                height: 20,
                colorFilter: ColorFilter.mode(
                  isEnabled ? AppColors.text1 : const Color(0xFF6A6A6A),
                  BlendMode.srcIn,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}
