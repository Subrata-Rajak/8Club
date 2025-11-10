# Architecture Documentation

## Overview

8Club is a Flutter application built using Clean Architecture principles with BLoC pattern for state management. The app follows a feature-based modular structure with clear separation of concerns.

## Architecture Pattern

The application uses **Clean Architecture** with the following layers:

### 1. Presentation Layer
- **Location**: `lib/features/*/presentation/`
- **Responsibility**: UI components, BLoCs, widgets, and screens
- **Pattern**: BLoC (Business Logic Component) for state management

### 2. Domain Layer
- **Location**: `lib/features/*/domain/`
- **Responsibility**: Business logic, entities, use cases, and repository interfaces
- **Dependencies**: None (pure Dart)

### 3. Data Layer
- **Location**: `lib/features/*/data/`
- **Responsibility**: Data sources, models, and repository implementations
- **Dependencies**: Domain layer and external packages

## Project Structure

```
lib/
├── core/                    # Shared core functionality
│   ├── assets/             # Asset paths constants
│   ├── injection_container.dart  # Dependency injection setup
│   ├── network/             # Network services and connectivity
│   ├── routes/              # Navigation configuration
│   ├── storage/             # Local storage services
│   ├── theme/               # App theme and colors
│   └── widgets/            # Reusable widgets
│
├── features/                # Feature modules
│   └── experiences/         # Experiences feature
│       ├── data/            # Data layer
│       │   ├── datasources/ # Remote data sources
│       │   ├── models/      # Data models
│       │   └── repositories/ # Repository implementations
│       ├── domain/          # Domain layer
│       │   ├── entities/     # Business entities
│       │   ├── repositories/ # Repository interfaces
│       │   └── usecases/     # Use cases
│       └── presentation/     # Presentation layer
│           ├── blocs/       # BLoC state management
│           ├── screens/      # Screen widgets
│           └── widgets/     # Feature-specific widgets
│
└── main.dart                # App entry point
```

## State Management

### BLoC Pattern

The application uses the **BLoC (Business Logic Component)** pattern for state management:

- **Events**: User actions or system events
- **States**: UI states derived from business logic
- **BLoC**: Processes events and emits states

#### BLoCs in the Application

1. **ExperiencesBloc**
   - Manages experience selection state
   - Handles fetching experiences from API
   - Manages selection/deselection of experiences
   - Tracks note input

2. **AudioRecordingBloc**
   - Manages audio recording lifecycle
   - Handles permissions
   - Controls recording, playback, and deletion
   - Tracks recording duration and waveform data

3. **VideoRecordingBloc**
   - Manages video recording lifecycle
   - Handles camera initialization
   - Controls recording, playback, and deletion
   - Tracks recording duration

4. **ConnectivityBloc**
   - Monitors network connectivity
   - Provides app-wide connectivity state
   - Shows connection status to users

## Dependency Injection

The application uses **GetIt** for dependency injection:

- **Location**: `lib/core/injection_container.dart`
- **Pattern**: Service Locator
- **Registration Types**:
  - `registerLazySingleton`: For services that should be created once
  - `registerFactory`: For BLoCs that need new instances per screen

## Navigation

- **Package**: `go_router`
- **Configuration**: `lib/core/routes/app_router.dart`
- **Routes**: Defined in `lib/core/routes/route_paths.dart`
- **Route Names**: Defined in `lib/core/routes/route_names.dart`

### Navigation Flow

1. **Get Started Screen** (`/`)
2. **Experience Selection Screen** (`/experiences`)
3. **Onboarding Question Screen** (`/onboarding-question`)
4. **Thank You Screen** (`/thank-you`)

## Network Layer

- **HTTP Client**: `http` package
- **Service**: `HttpService` wrapper
- **Error Handling**: Centralized error handling in service layer
- **Environment Variables**: `.env` file for API configuration

## Local Storage

- **Package**: `shared_preferences`
- **Service**: `LocalStorageService` abstraction
- **Usage**: Storing user preferences and cached data

## Theme & Styling

- **Theme Configuration**: `lib/core/theme/app_colors.dart`
- **Text Styles**: `lib/core/theme/app_text_styles.dart`
- **Colors**: Centralized color constants
- **Fonts**: Google Fonts integration

## Key Design Patterns

1. **Repository Pattern**: Abstracts data sources
2. **Use Case Pattern**: Encapsulates business logic
3. **BLoC Pattern**: Manages application state
4. **Dependency Injection**: Loose coupling
5. **Clean Architecture**: Separation of concerns

## Best Practices

- ✅ Feature-based folder structure
- ✅ Clear separation of concerns
- ✅ Dependency injection for testability
- ✅ BLoC for predictable state management
- ✅ Type-safe navigation with go_router
- ✅ Centralized error handling
- ✅ Reusable widgets and components
- ✅ Environment-based configuration

