import 'package:get_it/get_it.dart';
import '../../config/router/app_routing.dart';
import '../../utils/api/api_manager.dart';
import '../../core/services/storage_service.dart';
import '../../core/services/notification_service.dart';

final getIt = GetIt.instance;

/// Setup dependency injection
Future<void> setupDependencies() async {
  // API Manager
  getIt.registerSingleton<ApiManager>(ApiManager());

  // Storage Service
  final storageService = StorageService();
  await storageService.init();
  getIt.registerSingleton<StorageService>(storageService);

  // Notification Service
  final notificationService = NotificationService();
  await notificationService.init();
  getIt.registerSingleton<NotificationService>(notificationService);

  // Router
  getIt.registerSingleton(AppRouting.createRouter());

  // TODO: Register other services, repositories, and view models as needed
}

/// Get API Manager instance
ApiManager get apiManager => getIt<ApiManager>();

/// Get Storage Service instance
StorageService get storageService => getIt<StorageService>();

/// Get Notification Service instance
NotificationService get notificationService => getIt<NotificationService>();
