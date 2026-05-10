# TickOff - Habit Tracker App

> ℹ️ **For LLM/AI Reference Documentation**: See [docs/llm/ARCHITECTURE.md](docs/llm/ARCHITECTURE.md), [docs/llm/DEVELOPMENT_GUIDE.md](docs/llm/DEVELOPMENT_GUIDE.md), and [docs/llm/PROJECT_FILES.md](docs/llm/PROJECT_FILES.md)

A minimal, streak-focused habit tracker with a built-in micro-journal. Users create daily habits, tap to complete them, grow visual streaks, and optionally log notes/photos per habit entry.

## Technology Stack

- **Framework**: Flutter with FVM
- **State Management**: Provider
- **Navigation**: go_router
- **Dependency Injection**: get_it
- **Local Storage**: shared_preferences, sqflite
- **Networking**: dio
- **Notifications**: flutter_local_notifications
- **Authentication**: Firebase Auth
- **Cloud**: Firebase (Firestore, Storage)

## Architecture

### MVVM Pattern with Layer-Based Structure

```
lib/
├── main.dart                    # App entry point
├── core/
│   ├── app_init.dart           # App initialization
│   ├── app_storage.dart        # Storage management
│   ├── app_notifications.dart  # Notification management
│   ├── helpers/                # Helper utilities
│   └── services/
│       ├── injector.dart       # Dependency injection setup
│       ├── storage_service.dart
│       ├── notification_service.dart
│       └── api_manager.dart
├── config/
│   ├── router/
│   │   └── app_routing.dart    # Navigation setup
│   └── theme/
│       ├── app_colors.dart     # Color palette
│       └── app_theme.dart      # Theme configuration
├── data/
│   ├── models/
│   │   ├── habit_model.dart
│   │   ├── journal_entry_model.dart
│   │   ├── category_model.dart
│   │   └── completion_model.dart
│   └── repos/
│       └── habit_repository.dart
├── presentation/
│   ├── screens/
│   │   └── splash_screen.dart
│   ├── providers/              # ViewModels & State Management
│   └── widgets/
│       ├── global/             # Reusable widgets
│       └── feature/            # Feature-specific widgets
└── utils/
    ├── api/
    │   ├── api_manager.dart
    │   ├── api_endpoints.dart
    │   ├── api_params.dart
    │   └── api_responses.dart
    ├── constants/
    │   ├── app_const.dart
    │   ├── app_strings.dart
    │   ├── app_dimen.dart
    │   ├── app_img.dart
    │   └── app_validation.dart
    ├── enums/
    │   ├── storage_enums.dart
    │   └── router_enums.dart
    ├── errors/
    │   ├── app_exceptions.dart
    │   └── app_failures.dart
    ├── app_decoration.dart
    └── app_function.dart
```

## Getting Started

### Prerequisites

- Flutter SDK (3.13.0 or higher)
- Dart SDK (3.1.0 or higher)
- FVM (Flutter Version Manager)

### Installation

1. **Clone the repository**

   ```bash
   git clone <repository-url>
   cd tickoff
   ```

2. **Install dependencies**

   ```bash
   fvm flutter pub get
   ```

3. **Generate model files**

   ```bash
   fvm flutter pub run build_runner build
   ```

4. **Run the app**
   ```bash
   fvm flutter run
   ```

## Project Structure Overview

### Core Services

- **ApiManager**: Handles all HTTP requests with Dio
- **StorageService**: Manages local data with shared_preferences
- **NotificationService**: Handles local notifications

### Data Layer

- **Models**: `HabitModel`, `JournalEntryModel`, `CategoryModel`, `CompletionModel`
- **Repositories**: Abstract interfaces for data operations
- **Remote & Local**: Separate data sources for API and local storage

### Presentation Layer

- **Screens**: App views (Home, Settings, Analytics, etc.)
- **Providers**: State management with Provider
- **Widgets**: Reusable UI components

### Utilities

- **Constants**: App-wide constants and strings
- **Enums**: All enumeration types
- **Validation**: Input validation helpers
- **Functions**: Utility functions for common operations
- **API**: Network layer setup

## Key Features to Implement

- [ ] Home Screen with Habit Grid/List View
- [ ] Add/Edit Habit Screen
- [ ] Daily Habit Tracking
- [ ] Streak Calculation & Display
- [ ] Journal Entry Management
- [ ] Timeline View
- [ ] Analytics Dashboard
- [ ] Settings Screen
- [ ] Backup & Restore
- [ ] Notifications & Reminders
- [ ] Widget Integration
- [ ] Theme Customization

## Naming Conventions

- **Files**: `snake_case.dart`
- **Classes**: `PascalCase`
- **Variables**: `camelCase`
- **Constants**: `CONSTANT_CASE`
- **Enums**: `PascalCase`

## Code Guidelines

1. **State Management**: Use Provider for state management
2. **Navigation**: Use go_router for all navigation
3. **Error Handling**: Use custom exceptions and failure classes
4. **Validation**: Centralize validation in `app_validation.dart`
5. **Constants**: All hardcoded values in `constants/`
6. **API Calls**: Only through `ApiManager`
7. **Storage**: Only through `StorageService`

## Dependencies

Key packages used:

- `provider: ^6.1.1` - State management
- `go_router: ^13.2.4` - Navigation
- `get_it: ^7.6.4` - Dependency injection
- `dio: ^5.4.2` - HTTP client
- `flutter_local_notifications: ^17.1.2` - Notifications
- `shared_preferences: ^2.2.3` - Local storage
- `sqflite: ^2.3.3` - SQLite database
- `intl: ^0.19.0` - Internationalization

## Running Tests

```bash
fvm flutter test
```

## Building Release

### Android

```bash
fvm flutter build apk --release
```

### iOS

```bash
fvm flutter build ios --release
```

## Contributing

1. Follow the established code style and architecture
2. Create feature branches from `develop`
3. Ensure all tests pass before submitting PR
4. Update documentation as needed

## License

This project is licensed under the MIT License.

## Future Enhancements

- [ ] Multi-language support
- [ ] Habit recommendations based on time of day
- [ ] Social features (share achievements)
- [ ] Advanced analytics and insights
- [ ] Custom habit templates
- [ ] Integration with wearables
- [ ] Voice-based habit logging
- [ ] Habit communities

---

For more information, see the project documentation in the `docs/` folder.
