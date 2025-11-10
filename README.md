# 8Club

A Flutter onboarding application that allows users to select experiences and provide audio/video responses about their hosting motivations.

## Overview

8Club is a mobile application built with Flutter that guides users through an onboarding process. Users can:
- Select their preferred experience types (hotspots)
- Provide text responses
- Record audio or video responses
- Submit their information for review

## Features

- 🎯 **Experience Selection**: Choose 3 preferred experience types
- 📝 **Text Input**: Describe your perfect hotspot
- 🎤 **Audio Recording**: Record and playback audio responses
- 📹 **Video Recording**: Record and playback video responses
- ✅ **Validation**: Comprehensive validation with user-friendly error messages
- 🔄 **State Management**: BLoC pattern for predictable state management
- 🎨 **Modern UI**: Clean, intuitive user interface

## Tech Stack

- **Framework**: Flutter 3.9.2+
- **State Management**: BLoC (flutter_bloc)
- **Navigation**: go_router
- **Dependency Injection**: get_it
- **Networking**: http
- **Audio Recording**: record
- **Video Recording**: camera, video_player
- **Local Storage**: shared_preferences

## Getting Started

### Prerequisites

- Flutter SDK 3.9.2 or higher
- Dart SDK (included with Flutter)
- Android Studio / VS Code with Flutter extensions
- Xcode (for iOS development)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd eight_club
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure environment**
   - Create a `.env` file in the root directory
   - Add your API configuration:
     ```env
     API_BASE_URL=https://your-api-url.com
     ```

4. **Run the application**
   ```bash
   flutter run
   ```

For detailed setup instructions, see [Setup Guide](./docs/SETUP.md).

## Project Structure

```
lib/
├── core/              # Core functionality (DI, routing, theme, etc.)
├── features/          # Feature modules
│   └── experiences/   # Experiences feature
│       ├── data/      # Data layer
│       ├── domain/    # Domain layer
│       └── presentation/  # Presentation layer (BLoCs, screens, widgets)
└── main.dart          # App entry point
```

## Documentation

Comprehensive documentation is available in the `docs/` folder:

- 📐 [Architecture Documentation](./docs/ARCHITECTURE.md) - Project architecture and design patterns
- 🎯 [Features Documentation](./docs/FEATURES.md) - Detailed feature descriptions
- 🚀 [Setup Guide](./docs/SETUP.md) - Installation and configuration
- 🔌 [API Documentation](./docs/API.md) - API integration details
- 🧩 [BLoC Patterns](./docs/BLOC_PATTERNS.md) - State management patterns

## Key Features Explained

### Experience Selection
- Users must select exactly 3 experience types
- Must provide a descriptive note
- Validation with clear error messages

### Audio/Video Recording
- Switch between audio and video modes
- Cannot switch modes without deleting existing recording
- Real-time recording with duration tracking
- Playback controls for recorded media
- Permission handling for microphone and camera

### Validation
- Client-side validation throughout the app
- User-friendly error messages via snackbars
- Prevents progression until requirements are met

## Development

### Code Generation

If you modify models with `@JsonSerializable`:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Running Tests

```bash
flutter test
```

### Code Analysis

```bash
flutter analyze
```

## Building for Production

### Android

```bash
flutter build apk --release
# or
flutter build appbundle --release
```

### iOS

```bash
flutter build ios --release
```

## Permissions

The app requires the following permissions:

- **Microphone**: For audio recording
- **Camera**: For video recording
- **Storage**: For saving recordings (Android)

Permissions are requested at runtime when needed.

## Contributing

1. Follow the existing code structure
2. Use BLoC pattern for state management
3. Follow Clean Architecture principles
4. Write tests for new features
5. Update documentation as needed

## License

[Add your license information here]

## Support

For issues and questions, please [create an issue](link-to-issues) or contact the development team.
