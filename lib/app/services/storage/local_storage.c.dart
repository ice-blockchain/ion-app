// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/enum.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'local_storage.c.g.dart';

@Riverpod(keepAlive: true)
Future<SharedPreferences> sharedPreferences(Ref ref) => SharedPreferences.getInstance();

@Riverpod(keepAlive: true)
LocalStorage localStorage(Ref ref) {
  final prefs = ref.watch(sharedPreferencesProvider);

  return LocalStorage(prefs.requireValue);
}

@Riverpod(keepAlive: true)
Future<LocalStorage> localStorageAsync(Ref ref) async {
  final prefs = await ref.watch(sharedPreferencesProvider.future);

  return LocalStorage(prefs);
}

class LocalStorage {
  const LocalStorage(this._prefs);

  final SharedPreferences _prefs;

  Future<bool> setBool({required String key, required bool value}) {
    return _prefs.setBool(key, value);
  }

  bool? getBool(String key) {
    return _prefs.getBool(key);
  }

  Future<bool> setDouble(String key, double value) {
    return _prefs.setDouble(key, value);
  }

  double? getDouble(String key) {
    return _prefs.getDouble(key);
  }

  Future<bool> setInt(String key, int value) {
    return _prefs.setInt(key, value);
  }

  int? getInt(String key) {
    return _prefs.getInt(key);
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

  Future<bool> setStringList(String key, List<String> value) {
    return _prefs.setStringList(key, value);
  }

  List<String>? getStringList(String key) {
    return _prefs.getStringList(key);
  }

  Future<bool> remove(String key) {
    return _prefs.remove(key);
  }

  Set<String> getKeys() {
    return _prefs.getKeys();
  }
}
