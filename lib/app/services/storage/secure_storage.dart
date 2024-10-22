// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'secure_storage.g.dart';

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
}

@Riverpod(keepAlive: true)
SecureStorage secureStorage(Ref ref) {
  return SecureStorage();
}
