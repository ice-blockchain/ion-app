// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/services/storage/local_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_preferences_service.g.dart';

@Riverpod(keepAlive: true)
UserPreferencesService userPreferencesService(
  Ref ref, {
  required String userId,
}) {
  final localStorage = ref.watch(localStorageProvider);
  return UserPreferencesService(userId, localStorage);
}

class UserPreferencesService {
  UserPreferencesService(
    this._userId,
    this._localStorage,
  );

  final String _userId;
  final LocalStorage _localStorage;

  Future<bool> setValue<T>(String key, T value) {
    final userKey = _getUserKey(key);
    if (T == bool) {
      return _localStorage.setBool(key: userKey, value: value as bool);
    } else if (T == double) {
      return _localStorage.setDouble(userKey, value as double);
    } else if (T == String) {
      return _localStorage.setString(userKey, value as String);
    } else if (T == List<String>) {
      return _localStorage.setStringList(userKey, value as List<String>);
    } else {
      throw ArgumentError('Unsupported type: $T');
    }
  }

  T? getValue<T>(String key) {
    final userKey = _getUserKey(key);
    if (T == bool) {
      return _localStorage.getBool(userKey) as T?;
    } else if (T == double) {
      return _localStorage.getDouble(userKey) as T?;
    } else if (T == String) {
      return _localStorage.getString(userKey) as T?;
    } else if (T == List<String>) {
      return _localStorage.getStringList(userKey) as T?;
    } else {
      throw ArgumentError('Unsupported type: $T');
    }
  }

  void setEnum<T extends Enum>(String key, T value) {
    final userKey = _getUserKey(key);
    _localStorage.setEnum(userKey, value);
  }

  T? getEnum<T extends Enum>(String key, List<T> values) {
    final userKey = _getUserKey(key);
    return _localStorage.getEnum(userKey, values);
  }

  Future<bool> remove(String key) {
    final userKey = _getUserKey(key);
    return _localStorage.remove(userKey);
  }

  String _getUserKey(String key) => 'user_$_userId:$key';
}
