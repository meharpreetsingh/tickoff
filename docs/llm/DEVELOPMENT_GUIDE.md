# TickOff - Development Guide

Quick start guide for developing with TickOff Flutter project.

## 🚀 Project Initialization Complete!

Your **TickOff Habit Tracker** Flutter project is fully set up and ready for development.

---

## ✅ What's Been Done

### 1. Project Structure

- Created complete MVVM architecture with 60+ files
- Organized code into logical layers (core, config, data, presentation, utils)
- Implemented separation of concerns

### 2. Core Infrastructure

- ✅ Dependency injection setup (get_it)
- ✅ Navigation configuration (go_router)
- ✅ Theme system (Light/Dark mode)
- ✅ API manager with Dio
- ✅ Local storage service
- ✅ Notification service
- ✅ Exception handling framework

### 3. Data Models

- ✅ HabitModel (with JSON serialization)
- ✅ JournalEntryModel
- ✅ CategoryModel
- ✅ CompletionModel
- ✅ API response models

### 4. Utilities

- ✅ App constants and strings
- ✅ Dimensions and dimen system
- ✅ Validation helpers
- ✅ Common utility functions
- ✅ Decorations and styling

### 5. Code Quality

- ✅ No compilation errors
- ✅ Clean analysis results
- ✅ All dependencies resolved
- ✅ Code generation complete

---

## 📦 How to Use the Project

### 1. Install Dependencies (Already Done ✅)

```bash
cd h:\projects\tmp\tickoff
fvm flutter pub get
```

### 2. Generate Code (Already Done ✅)

```bash
fvm flutter pub run build_runner build
```

### 3. Check for Errors (Already Done ✅)

```bash
fvm flutter analyze
```

### 4. Format Code

```bash
fvm flutter format .
```

### 5. Run the App

```bash
# For web (development)
fvm flutter run -d web

# For Android
fvm flutter run

# For iOS
fvm flutter run -d ios

# For Windows Desktop
fvm flutter run -d windows
```

---

## 📋 Project Architecture Overview

### Layer Structure

```
Presentation Layer (UI)
  ├── Screens
  ├── Widgets
  └── Providers (ViewModels)
          ↓
Business Logic (State Management)
  └── Provider Classes
          ↓
Data Layer
  ├── Repositories
  ├── Models
  └── Data Sources (Local/Remote)
          ↓
Core & Utils Layer
  ├── Services
  ├── Configurations
  └── Utilities
```

### Key Services

1. **Dependency Injection** (`core/services/injector.dart`)
   - Register all services, repositories, and providers

2. **Storage** (`core/services/storage_service.dart`)
   - Handle local data persistence
   - Configuration storage

3. **Notifications** (`core/services/notification_service.dart`)
   - Schedule and manage notifications
   - Handle notification events

4. **API Manager** (`utils/api/api_manager.dart`)
   - All HTTP requests
   - Request/response interceptors
   - Error handling

---

## 🎨 Development Guidelines

### Adding a New Feature

1. **Create Model** in `data/models/`
   - Add `@JsonSerializable()` annotation
   - Run `build_runner` to generate `.g.dart` file

2. **Create Repository** in `data/repos/`
   - Define abstract interface
   - Implement local and remote data sources

3. **Create Provider** in `presentation/providers/`
   - Extend `ChangeNotifier` or use `StateNotifier`
   - Implement business logic
   - Register in `core/services/injector.dart`

4. **Create Screen** in `presentation/screens/`
   - Use `Consumer` or `Provider.watch()` for state
   - Build UI with model widgets

5. **Update Routing** in `config/router/app_routing.dart`
   - Add route definition
   - Add navigation method

### Example: Adding a New Habit Method

```dart
// 1. In habit_repository.dart (already exists)
abstract class HabitRepository {
  Future<HabitModel> createHabit(HabitModel habit);
}

// 2. In a new repo implementation
class HabitRepositoryImpl extends HabitRepository {
  // Implement using _localDataSource and _remoteDataSource
}

// 3. In presentation/providers/habit_provider.dart
class HabitProvider extends ChangeNotifier {
  final HabitRepository _repository;

  Future<void> createNewHabit(HabitModel habit) async {
    // Call repository
    // Update state
    notifyListeners();
  }
}

// 4. In core/services/injector.dart
getIt.registerSingleton<HabitProvider>(HabitProvider(...));

// 5. In a screen
final habitProvider = Provider.of<HabitProvider>(context);
habitProvider.createNewHabit(newHabit);
```

---

## 📝 Important Files to Know

### Configuration

- `lib/main.dart` - App entry point
- `lib/config/router/app_routing.dart` - Navigation setup
- `lib/config/theme/app_theme.dart` - Theme configuration
- `lib/core/services/injector.dart` - Dependency setup

### Constants & Strings

- `lib/utils/constants/app_strings.dart` - All UI text
- `lib/utils/constants/app_dimen.dart` - Sizes and spacing
- `lib/utils/constants/app_const.dart` - App configuration

### Utilities

- `lib/utils/app_validation.dart` - Input validation
- `lib/utils/app_function.dart` - Common functions
- `lib/utils/errors/` - Exception handling

---

## 🔗 Navigation Usage

### Simple Navigation

```dart
import 'package:go_router/go_router.dart';

// Navigate to home
context.goNamed(RouteNames.home);

// Navigate with parameters
context.goNamed(
  RouteNames.habitDetail,
  pathParameters: {'id': habitId},
);

// Go back
context.pop();
```

### Contextless Navigation

```dart
import 'config/router/app_routing.dart';

// Navigate from anywhere
AppRouting.navigateToHome();
AppRouting.navigateToHabitDetail(habitId);
AppRouting.goBack();
```

---

## 💾 Storage Usage

```dart
import 'core/services/injector.dart';
import 'utils/enums/storage_enums.dart';

// Save value
await storageService.saveValue(StorageEnum.theme, 'dark');

// Get value
final theme = storageService.getValue(StorageEnum.theme);

// Remove value
await storageService.removeValue(StorageEnum.theme);

// Clear all
await storageService.clear();
```

---

## 🌐 API Usage

```dart
import 'utils/api/api_manager.dart';
import 'utils/api/api_endpoints.dart';
import 'core/services/injector.dart';

// In any method
final response = await apiManager.get(
  ApiEndpoints.habits,
  queryParameters: {'limit': 10},
);

// For POST with data
final response = await apiManager.post(
  ApiEndpoints.createHabit,
  data: habitData,
);

// Set authorization header
apiManager.setAuthorizationHeader(token);

// Remove authorization
apiManager.removeAuthorizationHeader();
```

---

## 📱 Notifications Usage

```dart
import 'core/services/injector.dart';

// Show notification
await notificationService.showNotification(
  id: 1,
  title: 'Habit Reminder',
  body: 'Time to complete your daily habit!',
  payload: 'habit:123',
);

// Schedule notification
await notificationService.scheduleNotification(
  id: 2,
  title: 'Daily Check-in',
  body: 'Check your habits today!',
  scheduledDate: DateTime.now().add(Duration(hours: 1)),
);

// Cancel notification
await notificationService.cancelNotification(1);

// Cancel all
await notificationService.cancelAllNotifications();
```

---

## 🧪 Testing

```bash
# Run all tests
fvm flutter test

# Run specific test file
fvm flutter test test/path/to/test.dart

# Run tests with coverage
fvm flutter test --coverage
```

---

## 📱 Building for Release

### Android

```bash
fvm flutter build apk --release
# or
fvm flutter build appbundle --release
```

### iOS

```bash
fvm flutter build ios --release
```

### Web

```bash
fvm flutter build web --release
```

---

## 🐛 Troubleshooting

### Build Issues

**Issue**: Dependencies not found

```bash
fvm flutter pub get
fvm flutter pub run build_runner build --delete-conflicting-outputs
```

**Issue**: Model `.g.dart` files not generated

```bash
fvm flutter pub run build_runner build
fvm flutter pub run build_runner watch  # Watch for changes
```

**Issue**: Compilation errors

```bash
fvm flutter clean
fvm flutter pub get
fvm flutter analyze
```

---

## 🎯 Ready to Start?

1. ✅ Project is fully initialized
2. ✅ All dependencies installed
3. ✅ Code generation complete
4. ✅ No compilation errors
5. ✅ Ready for feature development

**Start by:**

1. Creating your first screen in `presentation/screens/`
2. Creating a provider in `presentation/providers/`
3. Implementing repository logic in `data/repos/`
4. Adding routes in `config/router/app_routing.dart`

---

Happy coding! 🚀
