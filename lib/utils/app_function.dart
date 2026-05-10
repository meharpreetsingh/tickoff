import 'package:intl/intl.dart';

/// Utility functions
class AppFunction {
  /// Format date to string
  static String formatDate(DateTime date, {String format = 'MMM dd, yyyy'}) {
    return DateFormat(format).format(date);
  }

  /// Format time to string
  static String formatTime(DateTime time, {String format = 'HH:mm'}) {
    return DateFormat(format).format(time);
  }

  /// Get time difference in days
  static int daysDifference(DateTime from, DateTime to) {
    return to.difference(from).inDays;
  }

  /// Get time difference in hours
  static int hoursDifference(DateTime from, DateTime to) {
    return to.difference(from).inHours;
  }

  /// Check if date is today
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  /// Check if date is yesterday
  static bool isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day;
  }

  /// Get date with time set to midnight
  static DateTime getMidnightDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// Get readable time difference (e.g., "2 days ago")
  static String getReadableTimeDifference(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inSeconds < 60) {
      return 'just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks week${weeks > 1 ? 's' : ''} ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months month${months > 1 ? 's' : ''} ago';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years year${years > 1 ? 's' : ''} ago';
    }
  }

  /// Parse date string
  static DateTime? parseDate(
    String dateString, {
    String format = 'yyyy-MM-dd',
  }) {
    try {
      return DateFormat(format).parse(dateString);
    } catch (e) {
      return null;
    }
  }

  /// Get week number of year
  static int getWeekNumber(DateTime date) {
    final firstDayOfYear = DateTime(date.year, 1, 1);
    final daysFromFirstDay = date.difference(firstDayOfYear).inDays;
    return ((daysFromFirstDay + firstDayOfYear.weekday) / 7).ceil();
  }

  /// Get beginning of month
  static DateTime getBeginningOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  /// Get end of month
  static DateTime getEndOfMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0);
  }

  /// Get beginning of week
  static DateTime getBeginningOfWeek(DateTime date, {int weekStartDay = 1}) {
    final difference = (date.weekday - weekStartDay) % 7;
    return date.subtract(Duration(days: difference));
  }

  /// Get end of week
  static DateTime getEndOfWeek(DateTime date, {int weekStartDay = 1}) {
    return getBeginningOfWeek(
      date,
      weekStartDay: weekStartDay,
    ).add(const Duration(days: 6));
  }

  /// Debounce function
  static Future<void> debounce(
    Future<void> Function() func, {
    Duration delay = const Duration(milliseconds: 300),
  }) async {
    await Future.delayed(delay);
    await func();
  }

  /// Capitalize first letter
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  /// Truncate text
  static String truncate(
    String text, {
    int length = 50,
    String ending = '...',
  }) {
    if (text.length <= length) return text;
    return text.substring(0, length) + ending;
  }

  /// Generate UUID v4
  static String generateUuid() {
    final values = List<int>.generate(16, (i) => i);
    values[6] = (values[6] & 0x0f) | 0x40;
    values[8] = (values[8] & 0x3f) | 0x80;

    final guid = values.map((i) => i.toRadixString(16).padLeft(2, '0')).join();
    return '${guid.substring(0, 8)}-${guid.substring(8, 12)}-${guid.substring(12, 16)}-${guid.substring(16, 20)}-${guid.substring(20)}';
  }

  /// Format number with commas
  static String formatNumber(int number) {
    return number.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (Match m) => ',',
    );
  }

  /// Calculate percentage
  static double calculatePercentage(int completed, int total) {
    if (total == 0) return 0.0;
    return (completed / total) * 100;
  }

  /// Get initials from name
  static String getInitials(String name) {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return (parts[0][0] + parts[1][0]).toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '';
  }
}
