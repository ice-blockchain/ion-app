import 'package:ice/app/extensions/enum.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'local_storage.g.dart';

@Riverpod(keepAlive: true)
Future<SharedPreferences> sharedPreferences(SharedPreferencesRef ref) =>
    SharedPreferences.getInstance();

@Riverpod(keepAlive: true)
LocalStorage localStorage(LocalStorageRef ref) {
  final prefs = ref.watch(sharedPreferencesProvider);

  return LocalStorage(prefs.requireValue);
}

class LocalStorage {
  final SharedPreferences _prefs;

  const LocalStorage(this._prefs);

  Future<bool> setBool({required String key, required bool value}) {
    return _prefs.setBool(key, value);
  }

  bool getBool(String key, {bool defaultValue = false}) {
    return _prefs.getBool(key) ?? defaultValue;
  }

  Future<bool> setDouble(String key, double value) {
    return _prefs.setDouble(key, value);
  }

  double getDouble(String key, {double defaultValue = 0.0}) {
    return _prefs.getDouble(key) ?? defaultValue;
  }

  Future<bool> setString(String key, String value) {
    return _prefs.setString(key, value);
  }

  String? getString(String key) {
    return _prefs.getString(key);
  }

  Future<bool> setEnum<T extends Enum>(String key, T value) {
    return _prefs.setString(key, value.toShortString());
  }

  // Get an enum value
  T getEnum<T extends Enum>(
    String key,
    List<T> enumValues, {
    required T defaultValue,
  }) {
    final stringValue = _prefs.getString(key);
    if (stringValue == null) {
      return defaultValue;
    }
    try {
      return EnumExtensions.fromShortString(enumValues, stringValue);
    } catch (e) {
      return defaultValue;
    }
  }
}
