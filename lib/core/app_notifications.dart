import 'services/notification_service.dart';

/// App notifications management
class AppNotifications {
  final NotificationService _notificationService;

  AppNotifications(this._notificationService);

  /// Schedule habit reminder
  Future<void> scheduleHabitReminder({
    required String habitId,
    required String habitName,
    required DateTime scheduledTime,
  }) async {
    final id = habitId.hashCode;

    await _notificationService.scheduleNotification(
      id: id,
      title: 'Time to check your habits',
      body: 'Don\'t forget: $habitName',
      scheduledDate: scheduledTime,
      payload: 'habit:$habitId',
    );
  }

  /// Cancel habit reminder
  Future<void> cancelHabitReminder(String habitId) async {
    final id = habitId.hashCode;
    await _notificationService.cancelNotification(id);
  }

  /// Show completion notification
  Future<void> showCompletionNotification({
    required String habitId,
    required String habitName,
    required int streakDays,
  }) async {
    final id = habitId.hashCode;

    final body = streakDays % 7 == 0 && streakDays > 0
        ? 'Great job! $streakDays day streak on $habitName! 🔥'
        : 'Habit completed: $habitName ✓';

    await _notificationService.showNotification(
      id: id,
      title: 'Habit Tracked',
      body: body,
      payload: 'habit:$habitId',
    );
  }

  /// Show streak milestone notification
  Future<void> showStreakMilestoneNotification({
    required String habitId,
    required String habitName,
    required int streakDays,
  }) async {
    final id = habitId.hashCode + streakDays;

    await _notificationService.showNotification(
      id: id,
      title: '🏆 Milestone Reached!',
      body: '$streakDays day streak on $habitName!',
      payload: 'habit:$habitId',
    );
  }

  /// Show daily check-in reminder
  Future<void> showDailyCheckInReminder(DateTime scheduledTime) async {
    const id = 9999; // Fixed ID for daily reminder

    await _notificationService.scheduleNotification(
      id: id,
      title: 'Daily Check-In',
      body: 'Time to check your habits! ⏰',
      scheduledDate: scheduledTime,
      payload: 'daily-check-in',
    );
  }

  /// Cancel all notifications
  Future<void> cancelAll() {
    return _notificationService.cancelAllNotifications();
  }

  /// Request notification permissions
  Future<bool> requestPermissions() {
    return _notificationService.requestPermission();
  }

  /// Check if notifications are enabled
  bool isInitialized() {
    return _notificationService.isInitialized;
  }
}
