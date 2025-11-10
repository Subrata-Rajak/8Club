# Quick Reference Guide

## Common Commands

### Development
```bash
# Install dependencies
flutter pub get

# Run app
flutter run

# Run on specific device
flutter run -d android
flutter run -d ios

# Analyze code
flutter analyze

# Format code
flutter format .
```

### Code Generation
```bash
# Generate JSON serialization code
flutter pub run build_runner build --delete-conflicting-outputs

# Watch mode (auto-regenerate on changes)
flutter pub run build_runner watch
```

### Testing
```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage
```

### Building
```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# iOS
flutter build ios --release
```

## File Locations

### Key Files
- **Main Entry**: `lib/main.dart`
- **DI Setup**: `lib/core/injection_container.dart`
- **Routes**: `lib/core/routes/app_router.dart`
- **Theme**: `lib/core/theme/app_colors.dart`

### BLoCs
- **Experiences**: `lib/features/experiences/presentation/blocs/experiences/`
- **Audio Recording**: `lib/features/experiences/presentation/blocs/audio_recording/`
- **Video Recording**: `lib/features/experiences/presentation/blocs/video_recording/`
- **Connectivity**: `lib/core/network/connectivity_bloc/`

### Screens
- **Get Started**: `lib/features/experiences/presentation/screens/get_started_screen.dart`
- **Experience Selection**: `lib/features/experiences/presentation/screens/experience_selection_screen.dart`
- **Onboarding Question**: `lib/features/experiences/presentation/screens/onboarding_question_screen.dart`
- **Thank You**: `lib/features/experiences/presentation/screens/thank_you_screen.dart`

## Route Paths

- `/` - Get Started Screen
- `/experiences` - Experience Selection
- `/onboarding-question` - Onboarding Question
- `/thank-you` - Thank You Screen

## Environment Variables

Required in `.env`:
```env
API_BASE_URL=https://your-api-url.com
```

## Permissions

### Android (`android/app/src/main/AndroidManifest.xml`)
- `INTERNET`
- `RECORD_AUDIO`
- `CAMERA`
- `WRITE_EXTERNAL_STORAGE`
- `READ_EXTERNAL_STORAGE`

### iOS (`ios/Runner/Info.plist`)
- `NSMicrophoneUsageDescription`
- `NSCameraUsageDescription`
- `NSPhotoLibraryUsageDescription`

## Validation Rules

### Experience Selection
- ✅ Select exactly 3 experiences
- ✅ Provide non-empty note

### Onboarding Question
- ✅ Provide text input
- ✅ Provide audio OR video recording
- ✅ Cannot switch modes if recording exists

## Common Issues

### Dependencies
```bash
flutter clean
flutter pub get
```

### iOS Pods
```bash
cd ios
pod deintegrate
pod install
cd ..
```

### Build Errors
```bash
flutter clean
flutter pub get
flutter run
```

## BLoC Usage Pattern

```dart
// Provide BLoC
BlocProvider<MyBloc>(
  create: (context) => GetIt.instance<MyBloc>(),
  child: MyWidget(),
)

// Listen to state changes
BlocListener<MyBloc, MyState>(
  listener: (context, state) {
    // Handle side effects
  },
  child: child,
)

// Build UI based on state
BlocBuilder<MyBloc, MyState>(
  builder: (context, state) {
    // Return widget based on state
  },
)
```

## Testing Pattern

```dart
blocTest<MyBloc, MyState>(
  'description',
  build: () => MyBloc(),
  act: (bloc) => bloc.add(MyEvent()),
  expect: () => [MyState()],
);
```

## Documentation Links

- [Architecture](./ARCHITECTURE.md)
- [Features](./FEATURES.md)
- [Setup](./SETUP.md)
- [API](./API.md)
- [BLoC Patterns](./BLOC_PATTERNS.md)

