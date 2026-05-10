/// Generic API response
class ApiResponse<T> {
  final bool success;
  final String? message;
  final T? data;
  final Map<String, dynamic>? errors;
  final int? statusCode;

  ApiResponse({
    required this.success,
    this.message,
    this.data,
    this.errors,
    this.statusCode,
  });

  /// Create from JSON
  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJsonT,
  ) {
    return ApiResponse(
      success: json['success'] ?? false,
      message: json['message'],
      data: json['data'] != null ? fromJsonT(json['data']) : null,
      errors: json['errors'],
      statusCode: json['statusCode'],
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson(Object? Function(T?) toJsonT) {
    return {
      'success': success,
      'message': message,
      'data': data != null ? toJsonT(data) : null,
      'errors': errors,
      'statusCode': statusCode,
    };
  }
}

/// Paginated response
class PaginatedResponse<T> {
  final List<T> data;
  final int total;
  final int page;
  final int pageSize;
  final int totalPages;
  final bool hasMore;

  PaginatedResponse({
    required this.data,
    required this.total,
    required this.page,
    required this.pageSize,
    required this.totalPages,
    required this.hasMore,
  });

  /// Create from JSON
  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJsonT,
  ) {
    final dataList =
        (json['data'] as List?)?.map((e) => fromJsonT(e)).toList() ?? [];
    final total = json['total'] ?? 0;
    final page = json['page'] ?? 1;
    final pageSize = json['pageSize'] ?? 10;
    final totalPages = (total / pageSize).ceil();

    return PaginatedResponse(
      data: dataList,
      total: total,
      page: page,
      pageSize: pageSize,
      totalPages: totalPages,
      hasMore: page < totalPages,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson(Object? Function(T) toJsonT) {
    return {
      'data': data.map((e) => toJsonT(e)).toList(),
      'total': total,
      'page': page,
      'pageSize': pageSize,
      'totalPages': totalPages,
      'hasMore': hasMore,
    };
  }
}

/// Login response
class LoginResponse {
  final String accessToken;
  final String? refreshToken;
  final int expiresIn;

  LoginResponse({
    required this.accessToken,
    this.refreshToken,
    required this.expiresIn,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
      expiresIn: json['expiresIn'] ?? 3600,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'expiresIn': expiresIn,
    };
  }
}

/// Error response
class ErrorResponse {
  final String code;
  final String message;
  final Map<String, dynamic>? details;

  ErrorResponse({required this.code, required this.message, this.details});

  factory ErrorResponse.fromJson(Map<String, dynamic> json) {
    return ErrorResponse(
      code: json['code'] ?? 'UNKNOWN_ERROR',
      message: json['message'] ?? 'An error occurred',
      details: json['details'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'code': code, 'message': message, 'details': details};
  }

  @override
  String toString() => 'ErrorResponse(code: $code, message: $message)';
}
