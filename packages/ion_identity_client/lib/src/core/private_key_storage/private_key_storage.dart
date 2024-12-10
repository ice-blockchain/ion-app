// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:rxdart/rxdart.dart';

/// A simple data holder for a user's private key.
class PrivateKeyEntry {
  const PrivateKeyEntry({
    required this.username,
    required this.privateKey,
  });

  factory PrivateKeyEntry.fromJson(Map<String, dynamic> json) {
    return PrivateKeyEntry(
      username: json['username'] as String,
      privateKey: json['privateKey'] as String,
    );
  }

  final String username;
  final String privateKey;

  Map<String, dynamic> toJson() => {
        'username': username,
        'privateKey': privateKey,
      };
}

/// A storage class for managing private keys associated with usernames.
/// Similar to TokenStorage, it uses secure storage, a BehaviorSubject to emit changes,
/// and caches the data in memory.
class PrivateKeysStorage {
  PrivateKeysStorage({required FlutterSecureStorage secureStorage})
      : _secureStorage = secureStorage;

  final FlutterSecureStorage _secureStorage;
  final BehaviorSubject<List<PrivateKeyEntry>> _privateKeysSubject = BehaviorSubject();

  /// Stream of all currently stored private keys as a list of [PrivateKeyEntry].
  Stream<List<PrivateKeyEntry>> get privateKeys => _privateKeysSubject.stream;

  /// In-memory cache mapping username to private key.
  final Map<String, String> _privateKeysCache = {};

  /// The key used to store the private keys in secure storage.
  static const privateKeysKey = 'ion_identity_client_private_keys_key';

  /// Initializes the storage by loading private keys from secure storage into the cache.
  Future<void> init() async {
    await _loadPrivateKeysFromStorage();
  }

  /// Retrieves the private key for the specified [username].
  /// Returns `null` if no private key is found.
  String? getPrivateKey({required String username}) {
    return _privateKeysCache[username];
  }

  /// Sets (adds or updates) the private key for a given [username].
  Future<void> setPrivateKey({
    required String username,
    required String privateKey,
  }) async {
    _privateKeysCache[username] = privateKey;
    await _savePrivateKeysToStorage();
    _privateKeysSubject.add(_privateKeysAsList());
  }

  /// Removes the private key associated with the specified [username].
  Future<void> removePrivateKey({required String username}) async {
    _privateKeysCache.remove(username);
    await _savePrivateKeysToStorage();
    _privateKeysSubject.add(_privateKeysAsList());
  }

  /// Clears all stored private keys.
  Future<void> clearAllPrivateKeys() async {
    _privateKeysCache.clear();
    await _savePrivateKeysToStorage();
    _privateKeysSubject.add(_privateKeysAsList());
  }

  /// Disposes of the stream subject to prevent memory leaks.
  void dispose() {
    _privateKeysSubject.close();
  }

  /// Loads private keys from secure storage.
  /// Expects a JSON object: { "username": "privateKey", ... }
  Future<void> _loadPrivateKeysFromStorage() async {
    final keysJson = await _secureStorage.read(key: privateKeysKey);
    if (keysJson == null) {
      // If there's nothing in storage, just emit an empty list.
      _privateKeysSubject.add([]);
      return;
    }

    final keysMap = json.decode(keysJson) as Map<String, dynamic>;
    _privateKeysCache
      ..clear()
      ..addAll(
        keysMap.map((key, value) => MapEntry(key, value as String)),
      );

    _privateKeysSubject.add(_privateKeysAsList());
  }

  /// Saves the current private keys to secure storage.
  Future<void> _savePrivateKeysToStorage() async {
    final dataToStore = json.encode(_privateKeysCache);
    await _secureStorage.write(key: privateKeysKey, value: dataToStore);
  }

  /// Converts the cache into a list of [PrivateKeyEntry] objects.
  List<PrivateKeyEntry> _privateKeysAsList() {
    return _privateKeysCache.entries
        .map((e) => PrivateKeyEntry(username: e.key, privateKey: e.value))
        .toList();
  }
}
