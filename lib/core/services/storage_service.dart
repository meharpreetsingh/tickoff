import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/enums/storage_enums.dart';

/// Service for managing local storage
class StorageService {
  late SharedPreferences _prefs;

  /// Initialize storage service
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Save string value
  Future<bool> saveString(String key, String value) async {
    return _prefs.setString(key, value);
  }

  /// Get string value
  String? getString(String key, {String? defaultValue}) {
    return _prefs.getString(key) ?? defaultValue;
  }

  /// Save integer value
  Future<bool> saveInt(String key, int value) async {
    return _prefs.setInt(key, value);
  }

  /// Get integer value
  int? getInt(String key, {int? defaultValue}) {
    return _prefs.getInt(key) ?? defaultValue;
  }

  /// Save boolean value
  Future<bool> saveBool(String key, bool value) async {
    return _prefs.setBool(key, value);
  }

  /// Get boolean value
  bool? getBool(String key, {bool? defaultValue}) {
    return _prefs.getBool(key) ?? defaultValue;
  }

  /// Save double value
  Future<bool> saveDouble(String key, double value) async {
    return _prefs.setDouble(key, value);
  }

  /// Get double value
  double? getDouble(String key, {double? defaultValue}) {
    return _prefs.getDouble(key) ?? defaultValue;
  }

  /// Save string list value
  Future<bool> saveStringList(String key, List<String> value) async {
    return _prefs.setStringList(key, value);
  }

  /// Get string list value
  List<String>? getStringList(String key, {List<String>? defaultValue}) {
    return _prefs.getStringList(key) ?? defaultValue;
  }

  /// Remove value
  Future<bool> remove(String key) async {
    return _prefs.remove(key);
  }

  /// Clear all values
  Future<bool> clear() async {
    return _prefs.clear();
  }

  /// Check if key exists
  bool hasKey(String key) {
    return _prefs.containsKey(key);
  }

  /// Get all keys
  Set<String> getAllKeys() {
    return _prefs.getKeys();
  }

  // Convenience methods using StorageEnum

  /// Save value using StorageEnum
  Future<bool> saveValue(StorageEnum key, dynamic value) async {
    if (value is String) {
      return saveString(key.key, value);
    } else if (value is int) {
      return saveInt(key.key, value);
    } else if (value is bool) {
      return saveBool(key.key, value);
    } else if (value is double) {
      return saveDouble(key.key, value);
    } else if (value is List<String>) {
      return saveStringList(key.key, value);
    }
    return false;
  }

  /// Get value using StorageEnum
  dynamic getValue(StorageEnum key, {dynamic defaultValue}) {
    if (!hasKey(key.key)) {
      return defaultValue;
    }

    final value = _prefs.get(key.key);
    return value ?? defaultValue;
  }

  /// Remove value using StorageEnum
  Future<bool> removeValue(StorageEnum key) async {
    return remove(key.key);
  }

  /// Clear all storage
  Future<void> clearAll() async {
    await clear();
  }
}
