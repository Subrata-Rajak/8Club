import 'dart:async';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'audio_recording_event.dart';
import 'audio_recording_state.dart';

/// BLoC for managing audio recording and playback state
class AudioRecordingBloc extends Bloc<AudioRecordingEvent, AudioRecordingState> {
  final AudioRecorder _audioRecorder = AudioRecorder();
  final AudioPlayer _audioPlayer = AudioPlayer();
  
  Timer? _recordingTimer;
  DateTime? _recordingStartTime;
  List<double> _waveformData = [];
  StreamSubscription? _playerCompleteSubscription;

  AudioRecordingBloc() : super(AudioRecordingInitial()) {
    on<StartRecording>(_onStartRecording);
    on<StopRecording>(_onStopRecording);
    on<CancelRecording>(_onCancelRecording);
    on<DeleteAudio>(_onDeleteAudio);
    on<ToggleAudioPlayback>(_onToggleAudioPlayback);
    on<UpdateRecordingDuration>(_onUpdateRecordingDuration);

    // Setup audio player completion listener
    _playerCompleteSubscription = _audioPlayer.onPlayerComplete.listen((_) {
      if (state is AudioPlaying) {
        add(ToggleAudioPlayback()); // Toggle to pause when complete
      }
    });
  }

  Future<void> _onStartRecording(
    StartRecording event,
    Emitter<AudioRecordingState> emit,
  ) async {
    // Check permission
    PermissionStatus status = await Permission.microphone.status;
    
    if (!status.isGranted) {
      status = await Permission.microphone.request();
      
      if (status.isDenied || !status.isGranted) {
        emit(AudioRecordingError(
          message: 'Microphone permission is required to record audio',
        ));
        return;
      }
    }

    // Double-check with the recorder itself
    if (!await _audioRecorder.hasPermission()) {
      emit(AudioRecordingError(
        message: 'Microphone permission not available. Please check your settings.',
      ));
      return;
    }

    // Stop any playing audio
    if (state.isPlaying) {
      await _audioPlayer.stop();
    }

    try {
      // Get temporary directory for recording
      final directory = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final path = '${directory.path}/audio_recording_$timestamp.m4a';

      await _audioRecorder.start(
        const RecordConfig(
          encoder: AudioEncoder.aacLc,
          bitRate: 128000,
          sampleRate: 44100,
        ),
        path: path,
      );

      _recordingStartTime = DateTime.now();
      _waveformData = List.generate(20, (index) => 20.0 + (index % 5) * 8.0);

      emit(AudioRecordingInProgress(
        audioDuration: Duration.zero,
        waveformData: _waveformData,
      ));

      // Start timer
      _recordingTimer?.cancel();
      _recordingTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
        if (_recordingStartTime != null) {
          final duration = DateTime.now().difference(_recordingStartTime!);
          // Simulate waveform animation
          final updatedWaveform = _waveformData.map((height) {
            final variation = (DateTime.now().millisecondsSinceEpoch % 100) / 100;
            return 15.0 + (height % 30) + (variation * 15);
          }).toList();
          
          add(UpdateRecordingDuration(
            duration: duration,
            waveformData: updatedWaveform,
          ));
        }
      });
    } catch (e) {
      emit(AudioRecordingError(
        message: 'Failed to start recording: $e',
      ));
    }
  }

  void _onUpdateRecordingDuration(
    UpdateRecordingDuration event,
    Emitter<AudioRecordingState> emit,
  ) {
    if (state is AudioRecordingInProgress) {
      _waveformData = event.waveformData;
      emit(AudioRecordingInProgress(
        audioDuration: event.duration,
        waveformData: event.waveformData,
      ));
    }
  }

  Future<void> _onStopRecording(
    StopRecording event,
    Emitter<AudioRecordingState> emit,
  ) async {
    try {
      final path = await _audioRecorder.stop();
      _recordingTimer?.cancel();
      _recordingTimer = null;
      _recordingStartTime = null;

      if (path != null) {
        // Calculate final duration
        final duration = state.audioDuration;
        emit(AudioRecordingCompleted(
          audioPath: path,
          audioDuration: duration,
        ));
      } else {
        emit(AudioRecordingInitial());
      }
    } catch (e) {
      emit(AudioRecordingError(
        message: 'Failed to stop recording: $e',
        audioPath: state.audioPath,
        audioDuration: state.audioDuration,
      ));
    }
  }

  Future<void> _onCancelRecording(
    CancelRecording event,
    Emitter<AudioRecordingState> emit,
  ) async {
    try {
      final path = await _audioRecorder.stop();
      _recordingTimer?.cancel();
      _recordingTimer = null;
      _recordingStartTime = null;

      // Delete the recording file if it was created
      if (path != null) {
        try {
          final file = File(path);
          if (await file.exists()) {
            await file.delete();
          }
        } catch (e) {
          // Ignore deletion errors
        }
      }

      emit(AudioRecordingInitial());
    } catch (e) {
      emit(AudioRecordingError(
        message: 'Failed to cancel recording: $e',
      ));
    }
  }

  Future<void> _onDeleteAudio(
    DeleteAudio event,
    Emitter<AudioRecordingState> emit,
  ) async {
    // Stop playing if audio is playing
    if (state.isPlaying) {
      await _audioPlayer.stop();
    }
    
    if (state.audioPath != null) {
      try {
        final file = File(state.audioPath!);
        if (await file.exists()) {
          await file.delete();
        }
      } catch (e) {
        // Ignore deletion errors
      }
    }
    
    emit(AudioRecordingInitial());
  }

  Future<void> _onToggleAudioPlayback(
    ToggleAudioPlayback event,
    Emitter<AudioRecordingState> emit,
  ) async {
    if (state.audioPath == null) return;

    try {
      if (state.isPlaying) {
        // Pause audio
        await _audioPlayer.pause();
        emit(AudioPaused(
          audioPath: state.audioPath,
          audioDuration: state.audioDuration,
        ));
      } else {
        // Play audio
        await _audioPlayer.play(DeviceFileSource(state.audioPath!));
        emit(AudioPlaying(
          audioPath: state.audioPath,
          audioDuration: state.audioDuration,
        ));
      }
    } catch (e) {
      emit(AudioRecordingError(
        message: 'Failed to play audio: $e',
        audioPath: state.audioPath,
        audioDuration: state.audioDuration,
      ));
    }
  }

  @override
  Future<void> close() {
    _recordingTimer?.cancel();
    _playerCompleteSubscription?.cancel();
    _audioRecorder.dispose();
    _audioPlayer.dispose();
    return super.close();
  }
}

