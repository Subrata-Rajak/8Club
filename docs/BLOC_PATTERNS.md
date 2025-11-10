# BLoC Pattern Documentation

## Overview

The application uses the BLoC (Business Logic Component) pattern for state management. This document explains how BLoCs are structured and used throughout the application.

## BLoC Architecture

### Core Components

1. **Event**: Represents user actions or system events
2. **State**: Represents the UI state
3. **BLoC**: Processes events and emits states

### Flow

```
User Action → Event → BLoC → State → UI Update
```

## BLoCs in the Application

### 1. ExperiencesBloc

**Purpose**: Manages experience selection and submission

**Location**: `lib/features/experiences/presentation/blocs/experiences/`

**Events**:
- `FetchExperiences`: Load experiences from API
- `ToggleExperienceSelection`: Select/deselect an experience
- `UpdateExperienceNote`: Update the note text
- `SubmitExperiences`: Submit selected experiences

**States**:
- `ExperiencesInitial`: Initial state
- `ExperiencesLoading`: Loading experiences
- `ExperiencesLoaded`: Experiences loaded successfully
- `ExperiencesError`: Error occurred

**Usage**:
```dart
BlocProvider<ExperiencesBloc>(
  create: (context) => GetIt.instance<ExperiencesBloc>(),
  child: BlocBuilder<ExperiencesBloc, ExperiencesState>(
    builder: (context, state) {
      // Build UI based on state
    },
  ),
)
```

---

### 2. AudioRecordingBloc

**Purpose**: Manages audio recording, playback, and file management

**Location**: `lib/features/experiences/presentation/blocs/audio_recording/`

**Events**:
- `StartRecording`: Start audio recording
- `StopRecording`: Stop recording
- `CancelRecording`: Cancel and delete recording
- `DeleteAudio`: Delete recorded audio
- `ToggleAudioPlayback`: Play/pause audio
- `UpdateRecordingDuration`: Update duration timer

**States**:
- `AudioRecordingInitial`: Initial state
- `AudioRecordingInProgress`: Recording in progress
- `AudioRecordingCompleted`: Recording finished
- `AudioPlaying`: Audio is playing
- `AudioPaused`: Audio is paused
- `AudioRecordingError`: Error occurred

**Features**:
- Permission handling
- File management
- Duration tracking
- Waveform data generation
- Playback control

**Usage**:
```dart
BlocProvider<AudioRecordingBloc>(
  create: (context) => GetIt.instance<AudioRecordingBloc>(),
  child: BlocListener<AudioRecordingBloc, AudioRecordingState>(
    listener: (context, state) {
      if (state is AudioRecordingError) {
        // Handle error
      }
    },
    child: BlocBuilder<AudioRecordingBloc, AudioRecordingState>(
      builder: (context, state) {
        // Build UI based on state
      },
    ),
  ),
)
```

---

### 3. VideoRecordingBloc

**Purpose**: Manages video recording, playback, and camera operations

**Location**: `lib/features/experiences/presentation/blocs/video_recording/`

**Events**:
- `InitializeCamera`: Initialize camera
- `StartVideoRecording`: Start recording
- `StopVideoRecording`: Stop recording
- `CancelVideoRecording`: Cancel and delete recording
- `DeleteVideo`: Delete recorded video
- `ToggleVideoPlayback`: Play/pause video
- `UpdateVideoDuration`: Update duration timer

**States**:
- `VideoRecordingInitial`: Initial state
- `VideoCameraInitialized`: Camera ready
- `VideoRecordingInProgress`: Recording in progress
- `VideoRecordingCompleted`: Recording finished
- `VideoPlaying`: Video is playing
- `VideoPaused`: Video is paused
- `VideoRecordingError`: Error occurred

**Features**:
- Camera initialization
- Permission handling
- File management
- Duration tracking
- Playback control

**Usage**:
```dart
BlocProvider<VideoRecordingBloc>(
  create: (context) => GetIt.instance<VideoRecordingBloc>(),
  child: BlocBuilder<VideoRecordingBloc, VideoRecordingState>(
    builder: (context, state) {
      if (state is VideoCameraInitialized) {
        // Show camera preview
      }
      // Build UI based on state
    },
  ),
)
```

---

### 4. ConnectivityBloc

**Purpose**: Monitors network connectivity app-wide

**Location**: `lib/core/network/connectivity_bloc/`

**Events**:
- `CheckConnectivity`: Check current connectivity
- `ConnectivityChanged`: Connectivity status changed

**States**:
- `ConnectivityInitial`: Initial state
- `ConnectivityConnected`: Connected to network
- `ConnectivityDisconnected`: No network connection

**Usage**:
```dart
BlocListener<ConnectivityBloc, ConnectivityState>(
  listener: (context, state) {
    if (state is ConnectivityDisconnected) {
      // Show offline message
    }
  },
  child: child,
)
```

## Best Practices

### 1. Event Naming

- Use imperative verbs: `StartRecording`, `StopRecording`
- Be specific: `ToggleAudioPlayback` not `TogglePlayback`
- Group related events: All audio events in `AudioRecordingBloc`

### 2. State Design

- Make states immutable
- Include all necessary data in state
- Use sealed classes or abstract classes for type safety

### 3. Error Handling

- Always have an error state
- Include error messages in error states
- Use `BlocListener` for side effects (snackbars, navigation)

### 4. Lifecycle Management

- Dispose resources in `close()` method
- Cancel timers and subscriptions
- Close file streams

### 5. Testing

- Test event handlers
- Test state transitions
- Mock dependencies
- Use `bloc_test` package

## Common Patterns

### Loading States

```dart
if (state is ExperiencesLoading) {
  return LoadingIndicator();
}
```

### Error Handling

```dart
BlocListener<ExperiencesBloc, ExperiencesState>(
  listener: (context, state) {
    if (state is ExperiencesError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message)),
      );
    }
  },
  child: child,
)
```

### Conditional Rendering

```dart
BlocBuilder<AudioRecordingBloc, AudioRecordingState>(
  builder: (context, state) {
    if (state is AudioRecordingInProgress) {
      return RecordingUI();
    } else if (state is AudioRecordingCompleted) {
      return PlaybackUI();
    }
    return EmptyState();
  },
)
```

## Dependency Injection

All BLoCs are registered in `injection_container.dart`:

```dart
// Factory: New instance per screen
getIt.registerFactory<AudioRecordingBloc>(
  () => AudioRecordingBloc(),
);

// Singleton: Shared across app
getIt.registerLazySingleton<ConnectivityBloc>(
  () => ConnectivityBloc(...),
);
```

## Testing BLoCs

Example test structure:

```dart
blocTest<AudioRecordingBloc, AudioRecordingState>(
  'emits [AudioRecordingInProgress] when StartRecording is added',
  build: () => AudioRecordingBloc(),
  act: (bloc) => bloc.add(StartRecording()),
  expect: () => [isA<AudioRecordingInProgress>()],
);
```

## Resources

- [BLoC Documentation](https://bloclibrary.dev/)
- [flutter_bloc Package](https://pub.dev/packages/flutter_bloc)
- [bloc_test Package](https://pub.dev/packages/bloc_test)

