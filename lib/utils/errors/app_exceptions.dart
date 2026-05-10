/// Custom exceptions for the application
class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalException;

  AppException({required this.message, this.code, this.originalException});

  @override
  String toString() => message;
}

class NetworkException extends AppException {
  NetworkException({
    required super.message,
    super.code,
    super.originalException,
  });
}

class CacheException extends AppException {
  CacheException({
    required super.message,
    super.code,
    super.originalException,
  });
}

class ValidationException extends AppException {
  ValidationException({
    required super.message,
    super.code,
    super.originalException,
  });
}

class AuthException extends AppException {
  AuthException({
    required super.message,
    super.code,
    super.originalException,
  });
}

class DatabaseException extends AppException {
  DatabaseException({
    required super.message,
    super.code,
    super.originalException,
  });
}

class NotificationException extends AppException {
  NotificationException({
    required super.message,
    super.code,
    super.originalException,
  });
}
