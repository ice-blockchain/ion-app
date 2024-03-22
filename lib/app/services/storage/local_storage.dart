import 'package:ice/app/extensions/enum.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static late SharedPreferences _prefs;

  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<bool> setBool(String key, bool value) {
    return _prefs.setBool(key, value);
  }

  static bool getBool(String key, {bool defaultValue = false}) {
    return _prefs.getBool(key) ?? defaultValue;
  }

  static Future<bool> setDouble(String key, double value) {
    return _prefs.setDouble(key, value);
  }

  static double getDouble(String key, {double defaultValue = 0.0}) {
    return _prefs.getDouble(key) ?? defaultValue;
  }

  static Future<bool> setString(String key, String value) {
    return _prefs.setString(key, value);
  }

  static String? getString(String key) {
    return _prefs.getString(key);
  }

  static Future<bool> setEnum<T extends Enum>(String key, T value) {
    return _prefs.setString(key, value.toShortString());
  }

  // Get an enum value
  static T getEnum<T extends Enum>(
    String key,
    List<T> enumValues, {
    required T defaultValue,
  }) {
    final String? stringValue = _prefs.getString(key);
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
