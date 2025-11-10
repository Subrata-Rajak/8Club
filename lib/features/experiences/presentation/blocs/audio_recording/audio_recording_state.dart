/// Base class for audio recording states
abstract class AudioRecordingState {
  final String? audioPath;
  final Duration audioDuration;
  final bool isRecording;
  final bool isPlaying;

  const AudioRecordingState({
    this.audioPath,
    this.audioDuration = Duration.zero,
    this.isRecording = false,
    this.isPlaying = false,
  });
}

/// Initial state
class AudioRecordingInitial extends AudioRecordingState {
  const AudioRecordingInitial();
}

/// Recording state
class AudioRecordingInProgress extends AudioRecordingState {
  final List<double> waveformData;

  const AudioRecordingInProgress({
    required super.audioDuration,
    required this.waveformData,
  }) : super(isRecording: true);
}

/// Recording completed state
class AudioRecordingCompleted extends AudioRecordingState {
  const AudioRecordingCompleted({
    required super.audioPath,
    required super.audioDuration,
  });
}

/// Audio playing state
class AudioPlaying extends AudioRecordingState {
  const AudioPlaying({
    required super.audioPath,
    required super.audioDuration,
  }) : super(isPlaying: true);
}

/// Audio paused state
class AudioPaused extends AudioRecordingState {
  const AudioPaused({
    required super.audioPath,
    required super.audioDuration,
  });
}

/// Error state
class AudioRecordingError extends AudioRecordingState {
  final String message;

  const AudioRecordingError({
    required this.message,
    super.audioPath,
    super.audioDuration,
  });
}

