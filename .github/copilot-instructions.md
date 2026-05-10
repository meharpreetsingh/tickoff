## ⚠️ LLM REFERENCE DOCUMENTATION

Before working on this project, **ALWAYS read and reference the documentation in `docs/llm/`**:

- **docs/llm/ARCHITECTURE.md** - Complete architecture overview and tech stack
- **docs/llm/DEVELOPMENT_GUIDE.md** - Development patterns, examples, and guidelines
- **docs/llm/PROJECT_FILES.md** - Complete file structure and checklist

These documents contain all necessary context for understanding and extending this project.

---

## Technology

FVM - use for every flutter command

## Architecture

MVVM - Model View ViewModel
Layer Based Folder Structure (Screens, ViewModels, Services in each folder)

Routing - go_router (app_routing.dart - make each function & global navigation key for contextless navigation)
State Management - provider
Dependency Injector - get_it
Notifications - flutter_local_notifications
Network Requests - dio (api_manager.dart)

Themes (app_theme.dart - light & dark theme using | app_colors.dart - abstract each color being used in the app here into static variables)

Data Layer (Services Files)

## Folder Structure

- core
- helpers
- app_init.dart
- app_storage.dart
- app_notifications.dart
- services
- injector.dart (get_it)
- utils
- errors/
- app_exceptions.dart
- app_failures.dart
- api/
- api_manager.dart
  > post / get / del / ...
- api_params.dart
- api_responses.dart
- api_endpoints.dart
- constants/
- app_const.dart
- enums/
- storage_enums.dart
- router_enums.dart
- app_function.dart
- app_validation.dart
  > validateUsername / validatePassword / validatePhone / validateEmail / ...
- app_decoration.dart
- app_dimen.dart
- app_img.dart
- app_strings.dart
- config
- router/
- theme/
- app_colors.dart
- app_theme.dart
- repos
- \*
- \*\_local.dart
- \*\_remote.dart
- \*\_repo.dart
- \*\_repo_models.dart
- models
- \*\_model.dart
- screens
- \*\_screen.dart
- providers
- \*\_provider.dart (something like a provider for multiple screens)
- \*\_vm.dart (for managing each screen state)
- widgets
- /global
- app_drawer.dart
- app_bottomsheets.dart
- app_dialog.dart
- app_snackbar.dart
- /feature
