// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// A generic data storage class that stores a `Map<String, T>` in `FlutterSecureStorage`
/// and allows for CRUD operations on that map.
///
/// [T] is the type of the values that will be stored. It must be JSON-serializable.
class DataStorage<T> {
  DataStorage({
    required FlutterSecureStorage secureStorage,
    required String storageKey,
    required T Function(Map<String, dynamic>) fromJson,
    required Map<String, dynamic> Function(T) toJson,
  })  : _secureStorage = secureStorage,
        _storageKey = storageKey,
        _fromJson = fromJson,
        _toJson = toJson;

  final FlutterSecureStorage _secureStorage;
  final String _storageKey;
  final T Function(Map<String, dynamic>) _fromJson;
  final Map<String, dynamic> Function(T) _toJson;

  /// In-memory cache of items mapped by their keys.
  final Map<String, T> _cache = {};

  /// Initializes the storage by loading existing data from secure storage.
  /// If no data exists, the cache starts empty.
  Future<void> init() async {
    await _loadFromStorage();
  }

  /// Retrieves the data associated with the specified [key].
  /// Returns `null` if no data is found.
  T? getData({required String key}) {
    return _cache[key];
  }

  /// Sets (adds or updates) the data for a given [key].
  Future<void> setData({required String key, required T value}) async {
    _cache[key] = value;
    await _saveToStorage();
  }

  /// Removes the data associated with the specified [key].
  Future<void> removeData({required String key}) async {
    _cache.remove(key);
    await _saveToStorage();
  }

  /// Clears all stored data.
  Future<void> clearAllData() async {
    _cache.clear();
    await _saveToStorage();
  }

  /// Returns all data as a Map.
  Map<String, T> getAllData() {
    return Map.unmodifiable(_cache);
  }

  /// Returns all data keys.
  List<String> getAllKeys() {
    return _cache.keys.toList(growable: false);
  }

  /// Loads data from secure storage into the in-memory cache.
  Future<void> _loadFromStorage() async {
    final jsonStr = await _secureStorage.read(key: _storageKey);
    if (jsonStr == null) {
      return; // No data to load, keep cache empty.
    }

    final jsonMap = json.decode(jsonStr) as Map<String, dynamic>;
    _cache
      ..clear()
      ..addAll(
        jsonMap.map((key, value) {
          // value should be a Map<String, dynamic> representing T
          return MapEntry(key, _fromJson(value as Map<String, dynamic>));
        }),
      );
  }

  /// Saves the current cache to secure storage.
  Future<void> _saveToStorage() async {
    final jsonMap = _cache.map((key, value) => MapEntry(key, _toJson(value)));
    final jsonStr = json.encode(jsonMap);
    await _secureStorage.write(key: _storageKey, value: jsonStr);
  }
}
