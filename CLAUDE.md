# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Kipa is a Flutter mobile application for payment link management and delivery tracking. Built with Clean Architecture and Riverpod for state management.

## Development Commands

### Running the app
```bash
flutter run
```

### Build commands
```bash
flutter build apk          # Android APK
flutter build ios          # iOS build
flutter build appbundle    # Android App Bundle
```

### Code quality
```bash
flutter analyze            # Run static analysis
flutter pub get            # Install dependencies
```

## Architecture

### Clean Architecture Pattern

Each feature follows a strict 3-layer Clean Architecture:

```
lib/feature/<feature_name>/
├── data/
│   ├── datasources/       # Remote/Local data sources
│   ├── models/            # Data models with fromJson/toJson
│   └── repositories/      # Repository implementations
├── domain/
│   ├── entities/          # Business objects
│   ├── repositories/      # Repository interfaces
│   └── usecases/          # Business logic (one per use case)
└── presentation/
    ├── pages/             # UI screens
    ├── providers/         # Riverpod providers and dependency injection
    ├── state/             # State notifiers and state classes
    └── widgets/           # Feature-specific widgets
```

**Critical**: Always maintain this separation. Data layer handles API/storage, domain contains business rules, presentation manages UI/state.

### Dependency Injection

- **GetIt**: Core services registered in `lib/utils/constant.dart` via `initDependencies()`
- **Riverpod Providers**: Feature-level dependencies in `presentation/providers/` files
- Services (ApiService, AuthTokenService, SecureStorageService) use GetIt
- Feature components (repositories, usecases, notifiers) use Riverpod

### State Management

Uses **flutter_riverpod** with StateNotifier pattern:
- Providers defined in `presentation/providers/<feature>_provider.dart`
- State classes in `presentation/state/<feature>_state.dart`
- State notifiers in `presentation/state/<feature>_notifier.dart`

Example provider chain: DataSource → Repository → UseCase → Notifier → UI

### Routing

Centralized routing in `lib/core/routes/`:
- `app_router.dart`: Route generation using switch-case pattern
- `route_names.dart`: Route name constants
- Route arguments passed via `settings.arguments as Map<String, dynamic>?`

Navigation uses global `navigatorKey` defined in `main.dart`

### Network Layer

**AppDio** (`lib/core/services/network/app_dio.dart`):
- Base URL: Configured in `lib/core/constants/api_constants.dart`
- Interceptor automatically adds Bearer token from AuthTokenService
- Handles 401 via `handleTokenExpiration()`
- Logs all requests/responses for debugging
- 30s timeout for connect/receive/send

**ApiService**: High-level API wrapper using AppDio instance

### Storage

**SecureStorageService** wraps flutter_secure_storage for sensitive data (tokens, user data)

### Core Services

- **AuthTokenService**: Token management and 401 handling
- **WebSocketService**: Real-time delivery tracking
- **GooglePlacesService**: Address autocomplete
- **DeviceInfoService**: Device identification

### Responsive Design

All UI uses `ResponsiveHelper` for adaptive sizing:
- Mobile: < 600px
- Tablet: 600-1200px
- Desktop: >= 1200px (constrained to tablet width in app builder)

Text uses `ResponsiveText` widget with baseSize that scales automatically.
Desktop displays are constrained to tablet width in `main.dart` builder.
Landscape orientation shows full-width content.

## Key Implementation Patterns

### Creating a new feature

1. Create folder structure: `lib/feature/<name>/{data,domain,presentation}`
2. Define entities in `domain/entities/`
3. Create repository interface in `domain/repositories/`
4. Implement usecases in `domain/usecases/` (one class per action)
5. Create models in `data/models/` (extend entities, add serialization)
6. Implement repository in `data/repositories/`
7. Create state classes in `presentation/state/`
8. Wire dependencies in `presentation/providers/`
9. Build UI in `presentation/pages/` and `presentation/widgets/`

### API Integration

1. Add endpoint constant in `lib/core/constants/api_constants.dart`
2. Create method in datasource using `ApiService`
3. Map to repository interface
4. Create usecase that calls repository
5. Call usecase from StateNotifier

### Styling

Theme defined in `lib/theme/theme.dart` using Google Fonts (DM Sans)
Colors and common widgets in `lib/core/shared/widgets/`

## Google Maps Configuration

**Critical**: Google Maps API key is configured in multiple locations:

1. **Dart code**: `lib/feature/delivery/presentation/pages/delivery_tracking_screen.dart:15`
2. **iOS**:
   - `ios/Runner/Info.plist` (GMSApiKey entry)
   - `ios/Runner/AppDelegate.swift` (GMSServices.provideAPIKey call)
3. **Android**: `android/app/src/main/AndroidManifest.xml` (com.google.android.geo.API_KEY)

If changing API keys, update all three locations.

## Features

- **auth**: Phone verification (OTP), user registration, profile upload
- **payment**: Payment link creation, QR codes, buyer payment flow
- **delivery**: Real-time delivery tracking with WebSocket and Google Maps
- **wallet**: Wallet management and top-up
- **dashboard**: Main navigation hub
- **splash/onboarding**: App initialization flow
