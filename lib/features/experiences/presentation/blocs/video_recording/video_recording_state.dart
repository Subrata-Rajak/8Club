import 'package:camera/camera.dart';

/// Base class for video recording states
abstract class VideoRecordingState {
  final String? videoPath;
  final Duration videoDuration;
  final bool isRecording;
  final bool isPlaying;
  final CameraController? cameraController;

  const VideoRecordingState({
    this.videoPath,
    this.videoDuration = Duration.zero,
    this.isRecording = false,
    this.isPlaying = false,
    this.cameraController,
  });
}

/// Initial state
class VideoRecordingInitial extends VideoRecordingState {
  const VideoRecordingInitial();
}

/// Camera initialized state
class VideoCameraInitialized extends VideoRecordingState {
  const VideoCameraInitialized({
    required super.cameraController,
  });
}

/// Recording state
class VideoRecordingInProgress extends VideoRecordingState {
  const VideoRecordingInProgress({
    required super.videoDuration,
    required super.cameraController,
  }) : super(isRecording: true);
}

/// Recording completed state
class VideoRecordingCompleted extends VideoRecordingState {
  const VideoRecordingCompleted({
    required super.videoPath,
    required super.videoDuration,
  });
}

/// Video playing state
class VideoPlaying extends VideoRecordingState {
  const VideoPlaying({
    required super.videoPath,
    required super.videoDuration,
  }) : super(isPlaying: true);
}

/// Video paused state
class VideoPaused extends VideoRecordingState {
  const VideoPaused({
    required super.videoPath,
    required super.videoDuration,
  });
}

/// Error state
class VideoRecordingError extends VideoRecordingState {
  final String message;

  const VideoRecordingError({
    required this.message,
    super.videoPath,
    super.videoDuration = Duration.zero,
    super.cameraController,
  });
}

