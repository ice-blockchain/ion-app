// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'secure_storage.r.g.dart';

class SecureStorage {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<String?> getString({required String key}) {
    return _storage.read(key: key);
  }

  Future<void> setString({required String key, required String value}) {
    return _storage.write(key: key, value: value);
  }

  Future<void> remove({required String key}) {
    return _storage.delete(key: key);
  }

  /// Forcefully clear secure storage after app installation or reinstallation.
  /// This is necessary because the iOS keychain retains values even after the app is deleted.
  Future<void> clearOnReinstall() async {
    const key = 'SecureStorage:hasRunBefore';
    final prefs = await SharedPreferences.getInstance();

    if (prefs.getBool(key) == null) {
      await Future.wait([
        _storage.deleteAll(),
        prefs.setBool(key, true),
      ]);
    }
  }
}

@Riverpod(keepAlive: true)
SecureStorage secureStorage(Ref ref) {
  return SecureStorage();
}
