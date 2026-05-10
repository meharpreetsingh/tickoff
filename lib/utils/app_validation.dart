/// Validation utilities
class AppValidation {
  /// Validate habit name
  static String? validateHabitName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Habit name cannot be empty';
    }
    if (value.length < 2) {
      return 'Habit name must be at least 2 characters';
    }
    if (value.length > 50) {
      return 'Habit name cannot exceed 50 characters';
    }
    return null;
  }

  /// Validate email
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email cannot be empty';
    }
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  /// Validate password
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password cannot be empty';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    if (value.length > 50) {
      return 'Password cannot exceed 50 characters';
    }
    return null;
  }

  /// Validate confirm password
  static String? validateConfirmPassword(String? value, String? password) {
    final passwordError = validatePassword(value);
    if (passwordError != null) {
      return passwordError;
    }
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }

  /// Validate phone number
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number cannot be empty';
    }
    final phoneRegex = RegExp(r'^[0-9]{10,}$');
    if (!phoneRegex.hasMatch(value.replaceAll(RegExp(r'[^\d]'), ''))) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  /// Validate journal note
  static String? validateJournalNote(String? value) {
    if (value == null || value.isEmpty) {
      return 'Note cannot be empty';
    }
    if (value.length > 500) {
      return 'Note cannot exceed 500 characters';
    }
    return null;
  }

  /// Validate category name
  static String? validateCategoryName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Category name cannot be empty';
    }
    if (value.length < 2) {
      return 'Category name must be at least 2 characters';
    }
    if (value.length > 30) {
      return 'Category name cannot exceed 30 characters';
    }
    return null;
  }

  /// Check if string is empty or null
  static bool isEmpty(String? value) {
    return value == null || value.trim().isEmpty;
  }

  /// Check if string is not empty
  static bool isNotEmpty(String? value) {
    return !isEmpty(value);
  }

  /// Check if email is valid
  static bool isEmailValid(String? email) {
    return validateEmail(email) == null;
  }

  /// Check if password is valid
  static bool isPasswordValid(String? password) {
    return validatePassword(password) == null;
  }

  /// Check if phone number is valid
  static bool isPhoneValid(String? phone) {
    return validatePhoneNumber(phone) == null;
  }
}
