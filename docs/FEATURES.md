# Features Documentation

## Overview

8Club is an onboarding application that allows users to select experiences and provide audio/video responses. The app guides users through a multi-step process to collect their preferences and motivations.

## Feature List

### 1. Get Started Screen

**Purpose**: Welcome screen and app entry point

**Features**:
- Welcome message
- App branding
- "Get Started" button to begin onboarding

**Navigation**: 
- Next: Experience Selection Screen

---

### 2. Experience Selection Screen

**Purpose**: Allow users to select their preferred experience types

**Features**:
- Display available experience types as interactive stamps
- Select exactly 3 experiences
- Add a descriptive note about their perfect hotspot
- Validation:
  - Must select exactly 3 experiences
  - Must provide a note (minimum 1 character)
- Error messages via snackbars for validation failures

**User Flow**:
1. View available experiences
2. Tap to select/deselect experiences (max 3)
3. Enter note describing perfect hotspot
4. Tap "Next" to proceed (validated)

**Technical Details**:
- **BLoC**: `ExperiencesBloc`
- **Data Source**: Remote API
- **Validation**: Client-side validation with user feedback

---

### 3. Onboarding Question Screen

**Purpose**: Collect user's motivation and intent through text and media

**Features**:
- Text input for answering "Why do you want to host with us?"
- Audio recording capability
- Video recording capability
- Mode selection (Audio/Video)
- Validation:
  - Must provide text note
  - Must provide at least one recording (audio OR video)
  - Cannot switch modes without deleting existing recording

**Audio Recording**:
- Start/stop recording
- Real-time waveform visualization
- Recording timer
- Playback controls (play/pause)
- Delete recording
- Duration tracking

**Video Recording**:
- Camera preview
- Start/stop recording
- Recording timer
- Playback controls (play/pause)
- Delete recording
- Duration tracking

**Mode Switching Rules**:
- Initially, no mode is selected
- If audio exists, video button is disabled
- If video exists, audio button is disabled
- User must delete existing recording to switch modes
- Error messages guide users when attempting to switch

**Technical Details**:
- **BLoCs**: 
  - `AudioRecordingBloc` - Audio recording/playback
  - `VideoRecordingBloc` - Video recording/playback
- **Permissions**: 
  - Microphone (audio)
  - Camera + Microphone (video)
- **File Management**: Temporary files, cleaned up on delete

---

### 4. Thank You Screen

**Purpose**: Confirm submission and provide closure

**Features**:
- Thank you message
- "We will get back to you" message
- Close app button

**Navigation**:
- Close App: Exits the application

---

## User Journey

```
Get Started Screen
    ↓
Experience Selection Screen
    ↓ (Select 3 experiences + note)
Onboarding Question Screen
    ↓ (Text + Audio/Video recording)
Thank You Screen
    ↓ (Close app)
```

## Validation Rules

### Experience Selection Screen
- ✅ Must select exactly 3 experiences
- ✅ Must provide a note (non-empty)
- ❌ Error: "Please select exactly 3 hotspots to proceed."
- ❌ Error: "Please add a note describing your perfect hotspot."

### Onboarding Question Screen
- ✅ Must provide text input
- ✅ Must provide at least one recording (audio OR video)
- ✅ Cannot switch modes if recording exists
- ❌ Error: "Please type a note before proceeding."
- ❌ Error: "Please record an audio or video before proceeding."
- ❌ Error: "Please delete the [audio/video] recording before switching to [audio/video] mode."

## Permissions Required

### Audio Recording
- **Microphone**: Required for audio recording

### Video Recording
- **Camera**: Required for video recording
- **Microphone**: Required for video audio

### Permission Handling
- Requests permissions when needed
- Shows dialogs for permanently denied permissions
- Provides option to open device settings

## Media Features

### Audio Recording
- **Format**: AAC LC
- **Visualization**: Real-time waveform
- **Controls**: Record, pause, play, delete
- **Duration**: Tracked and displayed

### Video Recording
- **Preview**: Live camera preview
- **Controls**: Record, stop, delete
- **Playback**: Play/pause recorded video
- **Duration**: Tracked and displayed

## Error Handling

All validation errors are displayed as:
- **Type**: SnackBar
- **Color**: Red (AppColors.negative)
- **Duration**: 3 seconds
- **Location**: Bottom of screen

## Accessibility Considerations

- Clear error messages
- Visual feedback for disabled states
- Intuitive button labels
- Consistent navigation patterns

