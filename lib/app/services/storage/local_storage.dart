import 'dart:async';

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

  void setBool({required String key, required bool value}) {
    return unawaited(_prefs.setBool(key, value));
  }

  bool? getBool(String key) {
    return _prefs.getBool(key);
  }

  void setDouble(String key, double value) {
    return unawaited(_prefs.setDouble(key, value));
  }

  double? getDouble(String key) {
    return _prefs.getDouble(key);
  }

  void setString(String key, String value) {
    return unawaited(_prefs.setString(key, value));
  }

  String? getString(String key) {
    return _prefs.getString(key);
  }

  void setEnum<T extends Enum>(String key, T value) {
    return unawaited(_prefs.setString(key, value.toShortString()));
  }

  // Get an enum value
  T? getEnum<T extends Enum>(
    String key,
    List<T> enumValues,
  ) {
    final stringValue = _prefs.getString(key);
    if (stringValue == null) {
      return null;
    }
    try {
      return EnumExtensions.fromShortString(enumValues, stringValue);
    } catch (e) {
      return null;
    }
  }
}
