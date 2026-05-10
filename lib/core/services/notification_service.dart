import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../utils/constants/app_const.dart';
import '../../utils/errors/app_exceptions.dart';

/// Service for managing local notifications
class NotificationService {
  late FlutterLocalNotificationsPlugin _notificationsPlugin;
  bool _isInitialized = false;

  /// Initialize notification service
  Future<void> init() async {
    try {
      _notificationsPlugin = FlutterLocalNotificationsPlugin();

      // Initialize settings for Android
      const androidSettings = AndroidInitializationSettings('app_icon');

      // Initialize settings for iOS
      const iosSettings = DarwinInitializationSettings(
        requestSoundPermission: true,
        requestBadgePermission: true,
        requestAlertPermission: true,
      );

      const initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      await _notificationsPlugin.initialize(
        settings: initSettings,
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );

      // Create notification channel for Android
      await _createNotificationChannel();

      _isInitialized = true;
    } catch (e) {
      throw NotificationException(
        message: 'Failed to initialize notifications',
        originalException: e,
      );
    }
  }

  /// Create notification channel for Android
  Future<void> _createNotificationChannel() async {
    // Channel creation is handled automatically on Android 8.0+
    // No explicit channel creation needed
  }

  /// Handle notification tap
  void _onNotificationTapped(NotificationResponse response) {
    // Handle notification tap
    // final payload = response.payload;
    // TODO: Handle navigation based on payload
  }

  /// Show notification
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
    bool sound = true,
    bool vibration = true,
  }) async {
    if (!_isInitialized) {
      throw NotificationException(
        message: 'Notification service not initialized',
      );
    }

    try {
      const androidDetails = AndroidNotificationDetails(
        AppConstant.notificationChannelId,
        AppConstant.notificationChannelName,
        channelDescription: AppConstant.notificationChannelDesc,
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
        playSound: true,
        enableVibration: true,
      );

      const iosDetails = DarwinNotificationDetails(presentSound: true);

      const notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _notificationsPlugin.show(
        id: id,
        title: title,
        body: body,
        notificationDetails: notificationDetails,
        payload: payload,
      );
    } catch (e) {
      throw NotificationException(
        message: 'Failed to show notification',
        originalException: e,
      );
    }
  }

  /// Schedule notification
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    if (!_isInitialized) {
      throw NotificationException(
        message: 'Notification service not initialized',
      );
    }

    try {
      // Simple delay-based scheduling instead of zoned schedule
      final delay = scheduledDate.difference(DateTime.now());
      if (delay.isNegative) {
        // If time has passed, show immediately
        await showNotification(
          id: id,
          title: title,
          body: body,
          payload: payload,
        );
      } else {
        // For actual scheduling, use a different approach
        // This is a simplified version - consider using third-party packages for robust scheduling
        await Future.delayed(delay, () {
          return showNotification(
            id: id,
            title: title,
            body: body,
            payload: payload,
          );
        });
      }
    } catch (e) {
      throw NotificationException(
        message: 'Failed to schedule notification',
        originalException: e,
      );
    }
  }

  /// Cancel notification
  Future<void> cancelNotification(int id) async {
    try {
      await _notificationsPlugin.cancel(id: id);
    } catch (e) {
      throw NotificationException(
        message: 'Failed to cancel notification',
        originalException: e,
      );
    }
  }

  /// Cancel all notifications
  Future<void> cancelAllNotifications() async {
    try {
      await _notificationsPlugin.cancelAll();
    } catch (e) {
      throw NotificationException(
        message: 'Failed to cancel all notifications',
        originalException: e,
      );
    }
  }

  /// Request permission
  Future<bool> requestPermission() async {
    try {
      // Notifications permissions are typically handled by the system
      // during initialization
      return true;
    } catch (e) {
      throw NotificationException(
        message: 'Failed to request notification permission',
        originalException: e,
      );
    }
  }

  /// Check if initialized
  bool get isInitialized => _isInitialized;
}
