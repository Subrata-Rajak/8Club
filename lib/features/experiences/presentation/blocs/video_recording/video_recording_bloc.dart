import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';
import 'video_recording_event.dart';
import 'video_recording_state.dart';

/// BLoC for managing video recording and playback state
class VideoRecordingBloc extends Bloc<VideoRecordingEvent, VideoRecordingState> {
  CameraController? _cameraController;
  VideoPlayerController? _videoPlayerController;
  Timer? _recordingTimer;
  DateTime? _recordingStartTime;
  List<CameraDescription>? _cameras;

  VideoRecordingBloc() : super(VideoRecordingInitial()) {
    on<InitializeCamera>(_onInitializeCamera);
    on<StartVideoRecording>(_onStartVideoRecording);
    on<StopVideoRecording>(_onStopVideoRecording);
    on<CancelVideoRecording>(_onCancelVideoRecording);
    on<DeleteVideo>(_onDeleteVideo);
    on<ToggleVideoPlayback>(_onToggleVideoPlayback);
    on<UpdateVideoRecordingDuration>(_onUpdateVideoRecordingDuration);

    // Initialize camera on startup
    add(InitializeCamera());
  }

  Future<void> _onInitializeCamera(
    InitializeCamera event,
    Emitter<VideoRecordingState> emit,
  ) async {
    try {
      // Check camera permission
      PermissionStatus status = await Permission.camera.status;
      
      if (!status.isGranted) {
        status = await Permission.camera.request();
        
        if (status.isDenied || !status.isGranted) {
          emit(VideoRecordingError(
            message: 'Camera permission is required to record video',
          ));
          return;
        }
      }

      // Get available cameras
      _cameras = await availableCameras();
      
      if (_cameras == null || _cameras!.isEmpty) {
        emit(VideoRecordingError(
          message: 'No cameras available on this device',
        ));
        return;
      }

      // Initialize camera controller with back camera (or first available)
      final camera = _cameras!.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => _cameras!.first,
      );

      _cameraController = CameraController(
        camera,
        ResolutionPreset.high,
        enableAudio: true,
      );

      await _cameraController!.initialize();

      emit(VideoCameraInitialized(
        cameraController: _cameraController!,
      ));
    } catch (e) {
      emit(VideoRecordingError(
        message: 'Failed to initialize camera: $e',
      ));
    }
  }

  Future<void> _onStartVideoRecording(
    StartVideoRecording event,
    Emitter<VideoRecordingState> emit,
  ) async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      emit(VideoRecordingError(
        message: 'Camera not initialized. Please wait...',
        cameraController: _cameraController,
      ));
      return;
    }

    // Check permissions
    PermissionStatus cameraStatus = await Permission.camera.status;
    PermissionStatus microphoneStatus = await Permission.microphone.status;

    if (!cameraStatus.isGranted) {
      cameraStatus = await Permission.camera.request();
      if (!cameraStatus.isGranted) {
        emit(VideoRecordingError(
          message: 'Camera permission is required',
          cameraController: _cameraController,
        ));
        return;
      }
    }

    if (!microphoneStatus.isGranted) {
      microphoneStatus = await Permission.microphone.request();
      if (!microphoneStatus.isGranted) {
        emit(VideoRecordingError(
          message: 'Microphone permission is required for video recording',
          cameraController: _cameraController,
        ));
        return;
      }
    }

    // Stop any playing video
    if (_videoPlayerController != null) {
      await _videoPlayerController!.dispose();
      _videoPlayerController = null;
    }

    try {
      await _cameraController!.startVideoRecording();

      _recordingStartTime = DateTime.now();

      emit(VideoRecordingInProgress(
        videoDuration: Duration.zero,
        cameraController: _cameraController!,
      ));

      // Start timer
      _recordingTimer?.cancel();
      _recordingTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
        if (_recordingStartTime != null) {
          final duration = DateTime.now().difference(_recordingStartTime!);
          add(UpdateVideoRecordingDuration(duration: duration));
        }
      });
    } catch (e) {
      emit(VideoRecordingError(
        message: 'Failed to start video recording: $e',
        cameraController: _cameraController,
      ));
    }
  }

  void _onUpdateVideoRecordingDuration(
    UpdateVideoRecordingDuration event,
    Emitter<VideoRecordingState> emit,
  ) {
    if (state is VideoRecordingInProgress) {
      emit(VideoRecordingInProgress(
        videoDuration: event.duration,
        cameraController: _cameraController!,
      ));
    }
  }

  Future<void> _onStopVideoRecording(
    StopVideoRecording event,
    Emitter<VideoRecordingState> emit,
  ) async {
    try {
      if (_cameraController == null || !_cameraController!.value.isRecordingVideo) {
        emit(VideoRecordingError(
          message: 'No video recording in progress',
          cameraController: _cameraController,
        ));
        return;
      }

      final file = await _cameraController!.stopVideoRecording();
      _recordingTimer?.cancel();
      _recordingTimer = null;
      _recordingStartTime = null;

      final duration = state.videoDuration;
      emit(VideoRecordingCompleted(
        videoPath: file.path,
        videoDuration: duration,
      ));
    } catch (e) {
      emit(VideoRecordingError(
        message: 'Failed to stop video recording: $e',
        cameraController: _cameraController,
        videoDuration: state.videoDuration,
      ));
    }
  }

  Future<void> _onCancelVideoRecording(
    CancelVideoRecording event,
    Emitter<VideoRecordingState> emit,
  ) async {
    try {
      if (_cameraController != null && _cameraController!.value.isRecordingVideo) {
        await _cameraController!.stopVideoRecording();
      }
      
      _recordingTimer?.cancel();
      _recordingTimer = null;
      _recordingStartTime = null;

      // Delete the recording file if it was created
      if (state.videoPath != null) {
        try {
          final file = File(state.videoPath!);
          if (await file.exists()) {
            await file.delete();
          }
        } catch (e) {
          // Ignore deletion errors
        }
      }

      // Return to initialized state
      if (_cameraController != null && _cameraController!.value.isInitialized) {
        emit(VideoCameraInitialized(
          cameraController: _cameraController!,
        ));
      } else {
        emit(VideoRecordingInitial());
      }
    } catch (e) {
      emit(VideoRecordingError(
        message: 'Failed to cancel video recording: $e',
        cameraController: _cameraController,
      ));
    }
  }

  Future<void> _onDeleteVideo(
    DeleteVideo event,
    Emitter<VideoRecordingState> emit,
  ) async {
    // Stop playing if video is playing
    if (_videoPlayerController != null) {
      await _videoPlayerController!.dispose();
      _videoPlayerController = null;
    }
    
    if (state.videoPath != null) {
      try {
        final file = File(state.videoPath!);
        if (await file.exists()) {
          await file.delete();
        }
      } catch (e) {
        // Ignore deletion errors
      }
    }
    
    // Return to initialized state if camera is available
    if (_cameraController != null && _cameraController!.value.isInitialized) {
      emit(VideoCameraInitialized(
        cameraController: _cameraController!,
      ));
    } else {
      emit(VideoRecordingInitial());
    }
  }

  Future<void> _onToggleVideoPlayback(
    ToggleVideoPlayback event,
    Emitter<VideoRecordingState> emit,
  ) async {
    if (state.videoPath == null) return;

    try {
      if (state.isPlaying) {
        // Pause video
        if (_videoPlayerController != null) {
          await _videoPlayerController!.pause();
        }
        emit(VideoPaused(
          videoPath: state.videoPath,
          videoDuration: state.videoDuration,
        ));
      } else {
        // Play video
        _videoPlayerController = VideoPlayerController.file(File(state.videoPath!));
        await _videoPlayerController!.initialize();
        await _videoPlayerController!.play();
        
        emit(VideoPlaying(
          videoPath: state.videoPath,
          videoDuration: state.videoDuration,
        ));
      }
    } catch (e) {
      emit(VideoRecordingError(
        message: 'Failed to play video: $e',
        videoPath: state.videoPath,
        videoDuration: state.videoDuration,
      ));
    }
  }

  @override
  Future<void> close() {
    _recordingTimer?.cancel();
    _cameraController?.dispose();
    _videoPlayerController?.dispose();
    return super.close();
  }
}

