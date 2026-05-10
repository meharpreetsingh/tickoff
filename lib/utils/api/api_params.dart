/// API request parameters
class ApiParams {
  // Common params
  static const String id = 'id';
  static const String limit = 'limit';
  static const String offset = 'offset';
  static const String page = 'page';
  static const String sortBy = 'sortBy';
  static const String order = 'order';

  // Habit params
  static const String name = 'name';
  static const String description = 'description';
  static const String category = 'category';
  static const String icon = 'icon';
  static const String color = 'color';
  static const String schedule = 'schedule';
  static const String reminderEnabled = 'reminderEnabled';
  static const String reminderTime = 'reminderTime';
  static const String archived = 'archived';
  static const String paused = 'paused';

  // Completion params
  static const String completedDate = 'completedDate';
  static const String freezeUsed = 'freezeUsed';
  static const String fromDate = 'fromDate';
  static const String toDate = 'toDate';

  // Journal params
  static const String note = 'note';
  static const String photoPath = 'photoPath';
  static const String habitId = 'habitId';

  // Filter params
  static const String search = 'search';
  static const String filter = 'filter';
  static const String status = 'status';

  // Auth params
  static const String email = 'email';
  static const String password = 'password';
  static const String token = 'token';
  static const String refreshToken = 'refreshToken';
  static const String newPassword = 'newPassword';

  /// Build query parameters map
  static Map<String, dynamic> buildQueryParams({
    int? limit,
    int? offset,
    String? sortBy,
    String? order,
    Map<String, dynamic>? additional,
  }) {
    final params = <String, dynamic>{};

    if (limit != null) params[ApiParams.limit] = limit;
    if (offset != null) params[ApiParams.offset] = offset;
    if (sortBy != null) params[ApiParams.sortBy] = sortBy;
    if (order != null) params[ApiParams.order] = order;

    if (additional != null) {
      params.addAll(additional);
    }

    return params;
  }
}
