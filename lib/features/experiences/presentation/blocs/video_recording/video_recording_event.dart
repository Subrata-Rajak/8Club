/// Base class for video recording events
abstract class VideoRecordingEvent {}

/// Event to start recording video
class StartVideoRecording extends VideoRecordingEvent {}

/// Event to stop recording video
class StopVideoRecording extends VideoRecordingEvent {}

/// Event to cancel recording video
class CancelVideoRecording extends VideoRecordingEvent {}

/// Event to delete recorded video
class DeleteVideo extends VideoRecordingEvent {}

/// Event to play/pause video
class ToggleVideoPlayback extends VideoRecordingEvent {}

/// Event to update recording duration (internal event)
class UpdateVideoRecordingDuration extends VideoRecordingEvent {
  final Duration duration;

  UpdateVideoRecordingDuration({required this.duration});
}

/// Event to initialize camera
class InitializeCamera extends VideoRecordingEvent {}

