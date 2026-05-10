import 'app_exceptions.dart';

/// Base class for failures
abstract class Failure {
  final String message;
  final String? code;

  Failure({required this.message, this.code});
}

class NetworkFailure extends Failure {
  NetworkFailure({required super.message, super.code});

  factory NetworkFailure.fromException(NetworkException exception) {
    return NetworkFailure(message: exception.message, code: exception.code);
  }
}

class CacheFailure extends Failure {
  CacheFailure({required super.message, super.code});

  factory CacheFailure.fromException(CacheException exception) {
    return CacheFailure(message: exception.message, code: exception.code);
  }
}

class ValidationFailure extends Failure {
  ValidationFailure({required super.message, super.code});

  factory ValidationFailure.fromException(ValidationException exception) {
    return ValidationFailure(message: exception.message, code: exception.code);
  }
}

class AuthFailure extends Failure {
  AuthFailure({required super.message, super.code});

  factory AuthFailure.fromException(AuthException exception) {
    return AuthFailure(message: exception.message, code: exception.code);
  }
}

class DatabaseFailure extends Failure {
  DatabaseFailure({required super.message, super.code});

  factory DatabaseFailure.fromException(DatabaseException exception) {
    return DatabaseFailure(message: exception.message, code: exception.code);
  }
}

class NotificationFailure extends Failure {
  NotificationFailure({required super.message, super.code});

  factory NotificationFailure.fromException(NotificationException exception) {
    return NotificationFailure(
      message: exception.message,
      code: exception.code,
    );
  }
}

class UnknownFailure extends Failure {
  UnknownFailure({required super.message, super.code});
}
