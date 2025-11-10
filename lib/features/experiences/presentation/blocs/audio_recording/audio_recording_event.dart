/// Base class for audio recording events
abstract class AudioRecordingEvent {}

/// Event to start recording audio
class StartRecording extends AudioRecordingEvent {}

/// Event to stop recording audio
class StopRecording extends AudioRecordingEvent {}

/// Event to cancel recording audio
class CancelRecording extends AudioRecordingEvent {}

/// Event to delete recorded audio
class DeleteAudio extends AudioRecordingEvent {}

/// Event to toggle audio playback (play/pause)
class ToggleAudioPlayback extends AudioRecordingEvent {}

/// Event to update recording duration (internal event)
class UpdateRecordingDuration extends AudioRecordingEvent {
  final Duration duration;
  final List<double> waveformData;

  UpdateRecordingDuration({
    required this.duration,
    required this.waveformData,
  });
}

