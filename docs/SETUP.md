# Setup Guide

## Prerequisites

Before setting up the project, ensure you have the following installed:

- **Flutter SDK**: Version 3.9.2 or higher
- **Dart SDK**: Included with Flutter
- **Android Studio** or **VS Code** with Flutter extensions
- **Xcode** (for iOS development on macOS)
- **Git**

## Installation Steps

### 1. Clone the Repository

```bash
git clone <repository-url>
cd eight_club
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Environment Configuration

Create a `.env` file in the root directory:

```env
# API Configuration
API_BASE_URL=https://your-api-url.com
API_KEY=your-api-key-here
```

**Note**: The `.env` file should not be committed to version control. Add it to `.gitignore`.

### 4. Platform-Specific Setup

#### Android

1. **Permissions**: Already configured in `android/app/src/main/AndroidManifest.xml`:
   - `INTERNET`
   - `RECORD_AUDIO`
   - `CAMERA`
   - `WRITE_EXTERNAL_STORAGE`
   - `READ_EXTERNAL_STORAGE`

2. **Minimum SDK**: Check `android/app/build.gradle.kts` for minimum SDK version

#### iOS

1. **Permissions**: Configure in `ios/Runner/Info.plist`:
   - `NSMicrophoneUsageDescription`
   - `NSCameraUsageDescription`
   - `NSPhotoLibraryUsageDescription`

2. **Pod Installation**:
   ```bash
   cd ios
   pod install
   cd ..
   ```

### 5. Run the Application

#### Development Mode

```bash
flutter run
```

#### Release Mode

```bash
flutter run --release
```

#### Specific Platform

```bash
# Android
flutter run -d android

# iOS
flutter run -d ios
```

## Code Generation

If you modify models with `@JsonSerializable`, run:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## Testing

### Run Tests

```bash
flutter test
```

### Run Tests with Coverage

```bash
flutter test --coverage
```

## Building for Production

### Android APK

```bash
flutter build apk --release
```

### Android App Bundle

```bash
flutter build appbundle --release
```

### iOS

```bash
flutter build ios --release
```

## Troubleshooting

### Common Issues

1. **Dependencies not installing**
   ```bash
   flutter clean
   flutter pub get
   ```

2. **iOS Pod issues**
   ```bash
   cd ios
   pod deintegrate
   pod install
   cd ..
   ```

3. **Build errors**
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

4. **Permission issues on iOS**
   - Ensure Info.plist has required permission descriptions
   - Check Xcode project settings

5. **Camera/Microphone not working**
   - Verify permissions in device settings
   - Check platform-specific configuration files

## Development Tools

### Recommended IDE Extensions

- **Flutter**: Official Flutter extension
- **Dart**: Official Dart extension
- **BLoC**: BLoC extension for state management
- **Flutter Intl**: For internationalization (if needed)

### Useful Commands

```bash
# Analyze code
flutter analyze

# Format code
flutter format .

# Check for outdated packages
flutter pub outdated

# Upgrade packages
flutter pub upgrade
```

## Project Structure Overview

```
eight_club/
├── android/          # Android-specific files
├── ios/              # iOS-specific files
├── lib/               # Main application code
│   ├── core/         # Core functionality
│   ├── features/     # Feature modules
│   └── main.dart     # Entry point
├── assets/           # Images, icons, animations
├── test/             # Unit and widget tests
├── docs/             # Documentation
└── pubspec.yaml      # Dependencies and configuration
```

## Environment Variables

The app uses `flutter_dotenv` for environment configuration. Ensure your `.env` file contains:

- `API_BASE_URL`: Base URL for API calls
- Any other required environment variables

## Next Steps

1. Review the [Architecture Documentation](./ARCHITECTURE.md)
2. Read the [Features Documentation](./FEATURES.md)
3. Check the [API Documentation](./API.md) if applicable
4. Start developing!

