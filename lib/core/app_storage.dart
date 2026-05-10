import 'services/storage_service.dart';
import '../utils/enums/storage_enums.dart';

/// App storage management
class AppStorage {
  final StorageService _storageService;

  AppStorage(this._storageService);

  /// Save user settings
  Future<bool> saveSettings({
    String? theme,
    String? locale,
    String? accentColor,
  }) async {
    bool success = true;

    if (theme != null) {
      success = await _storageService.saveValue(StorageEnum.theme, theme);
    }

    if (locale != null) {
      success = await _storageService.saveValue(StorageEnum.locale, locale);
    }

    if (accentColor != null) {
      success =
          await _storageService.saveValue(StorageEnum.settings, accentColor);
    }

    return success;
  }

  /// Get user settings
  Map<String, dynamic> getSettings() {
    return {
      'theme': _storageService.getValue(StorageEnum.theme),
      'locale': _storageService.getValue(StorageEnum.locale),
      'accentColor': _storageService.getValue(StorageEnum.settings),
      'backupEnabled': _storageService.getValue(StorageEnum.backupEnabled),
    };
  }

  /// Save backup status
  Future<bool> setBackupEnabled(bool enabled) {
    return _storageService.saveValue(StorageEnum.backupEnabled, enabled);
  }

  /// Get backup status
  bool isBackupEnabled() {
    return _storageService.getValue(StorageEnum.backupEnabled,
            defaultValue: false) ??
        false;
  }

  /// Save last sync time
  Future<bool> setLastSyncTime(DateTime time) {
    return _storageService.saveValue(
        StorageEnum.lastSyncTime, time.toIso8601String());
  }

  /// Get last sync time
  DateTime? getLastSyncTime() {
    final timeString = _storageService.getValue(StorageEnum.lastSyncTime);
    if (timeString != null) {
      return DateTime.tryParse(timeString);
    }
    return null;
  }

  /// Clear all app storage
  Future<bool> clearAll() {
    return _storageService.clear();
  }
}
