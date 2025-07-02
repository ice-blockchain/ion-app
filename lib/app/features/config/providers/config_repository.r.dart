// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/config/data/models/app_config_cache_strategy.dart';
import 'package:ion/app/features/config/data/models/app_config_with_version.dart';
import 'package:ion/app/features/core/providers/dio_provider.r.dart';
import 'package:ion/app/features/core/providers/env_provider.r.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:ion/app/services/storage/local_storage.r.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:synchronized/synchronized.dart';

part 'config_repository.r.g.dart';

class ConfigRepository {
  ConfigRepository({
    required Dio dio,
    required String ionOrigin,
    required LocalStorage localStorage,
    required Duration defaultCacheMaxAge,
  })  : _dio = dio,
        _ionOrigin = ionOrigin,
        _localStorage = localStorage,
        _defaultCacheMaxAge = defaultCacheMaxAge;

  final Dio _dio;
  final String _ionOrigin;
  final LocalStorage _localStorage;
  final Duration _defaultCacheMaxAge;

  // Lock map to prevent concurrent access per configName
  final Map<String, Lock> _locks = {};

  Future<T> getConfig<T>(
    String configName, {
    required AppConfigCacheStrategy cacheStrategy,
    required T Function(String) parser,
    Duration? refreshInterval,
    bool checkVersion = false,
  }) async {
    final cacheMaxAge = refreshInterval ?? _defaultCacheMaxAge;

    final lock = _locks.putIfAbsent(configName, Lock.new);

    return lock.synchronized(() async {
      final cachedData = await _getFromCache(
        configName,
        cacheStrategy,
        cacheMaxAge,
        (data) => _tryParse(parser, data),
      );
      if (cachedData != null) {
        return cachedData;
      }

      final networkData = await _getFromNetwork<T>(configName, parser, checkVersion);
      if (networkData != null) {
        await _saveToCache(configName, networkData, cacheStrategy);
        return networkData;
      }

      // Server returned 204 No Content - always update cache timestamp to prevent repeated requests
      await _updateCacheTimestamp(configName, cacheStrategy);

      final fallbackData = await _getFromCache(
        configName,
        cacheStrategy,
        const Duration(milliseconds: -1),
        parser,
      );

      if (fallbackData == null) {
        Logger.warning('Server returned 204 No Content but no cached data found for: $configName');
        throw AppConfigNotFoundException(configName);
      }

      return fallbackData;
    });
  }

  Future<T?> _getFromNetwork<T>(
    String configName,
    T Function(String) parser,
    bool checkVersion,
  ) async {
    try {
      final cacheVersion = _localStorage.getInt(getCacheVersionKey(configName)) ?? 0;
      final uri = Uri.parse(_ionOrigin).replace(
        path: '/v1/config/$configName',
        queryParameters: checkVersion ? {'version': cacheVersion.toString()} : null,
      );
      final response = await _dio.get<dynamic>(uri.toString());
      if (response.statusCode == HttpStatus.noContent) {
        return null;
      } else {
        return parser(
          response.data is String ? response.data as String : jsonEncode(response.data),
        );
      }
    } catch (error) {
      Logger.error(error);
      throw AppConfigException(
        error,
        configName: configName,
        errorMessage: 'Error getting config from network',
      );
    }
  }

  Future<T?> _getFromCache<T>(
    String configName,
    AppConfigCacheStrategy cacheStrategy,
    Duration cacheMaxAge,
    T Function(String) parser,
  ) async {
    try {
      final now = DateTime.now();

      if (cacheStrategy == AppConfigCacheStrategy.localStorage) {
        final lastSyncDate = _localStorage.getString(getSyncDateKey(configName));
        final cacheAvailable = cacheMaxAge.isNegative ||
            (lastSyncDate != null &&
                _isDateValid(lastSyncDate) &&
                now.difference(DateTime.parse(lastSyncDate)).inMilliseconds <
                    cacheMaxAge.inMilliseconds);

        if (!cacheAvailable) return null;

        final cachedDataString = _localStorage.getString(getDataKey(configName));
        if (cachedDataString == null) return null;

        return parser(cachedDataString);
      } else {
        final cacheFilePath = await _getCacheFilePath(configName);
        final cacheFile = File(cacheFilePath);
        if (cacheFile.existsSync()) {
          final cacheDuration = now.difference(cacheFile.lastModifiedSync());
          if (cacheMaxAge.isNegative || cacheDuration < cacheMaxAge) {
            return parser(await cacheFile.readAsString());
          }
        }
      }
      return null;
    } catch (error) {
      Logger.error(error);
      throw AppConfigException(
        error,
        configName: configName,
        errorMessage: 'Error getting config from cache',
      );
    }
  }

  bool _isDateValid(String dateString) => DateTime.tryParse(dateString) != null;

  Future<void> _saveToCache<T>(
    String configName,
    T data,
    AppConfigCacheStrategy cacheStrategy,
  ) async {
    final isString = data is String;
    final now = DateTime.now();

    try {
      if (cacheStrategy == AppConfigCacheStrategy.localStorage) {
        await Future.wait([
          _localStorage.setString(getSyncDateKey(configName), now.toIso8601String()),
          _localStorage.setString(
            getDataKey(configName),
            isString ? data : jsonEncode(data),
          ),
        ]);
      } else {
        final cacheFile = File(await _getCacheFilePath(configName));
        await cacheFile.writeAsString(isString ? data : jsonEncode(data));
        await cacheFile.setLastModified(now);
      }

      if (data is AppConfigWithVersion) {
        await _localStorage.setInt(getCacheVersionKey(configName), data.version);
      }
    } catch (error) {
      Logger.error(error);
      throw AppConfigException(
        error,
        configName: configName,
        errorMessage: 'Error saving config to cache',
      );
    }
  }

  Future<String> _getCacheFilePath(String configName) async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/${getCacheFileName(configName)}';
  }

  Future<void> _updateCacheTimestamp(
    String configName,
    AppConfigCacheStrategy cacheStrategy,
  ) async {
    try {
      final now = DateTime.now();

      if (cacheStrategy == AppConfigCacheStrategy.localStorage) {
        await _localStorage.setString(getSyncDateKey(configName), now.toIso8601String());
      } else {
        final cacheFile = File(await _getCacheFilePath(configName));
        if (cacheFile.existsSync()) {
          await cacheFile.setLastModified(now);
        }
      }
    } catch (error) {
      Logger.error(error);
      // Don't throw here, as this is just timestamp update
    }
  }

  T? _tryParse<T>(T Function(String) parser, String data) {
    try {
      return parser(data);
    } catch (error) {
      return null;
    }
  }

  /// Clears all locks to prevent memory leaks
  void clearLocks() {
    _locks.clear();
  }

  String getCacheFileName(String configName) => '$configName.json';

  String getCacheVersionKey(String configName) => '$configName:cache_version';

  String getSyncDateKey(String configName) => '$configName:syncDate';

  String getDataKey(String configName) => '$configName:data';
}

@Riverpod(keepAlive: true)
Future<ConfigRepository> configRepository(Ref ref) async {
  final env = ref.watch(envProvider.notifier);

  final origin = env.get<String>(EnvVariable.ION_ORIGIN);
  final cacheMaxAge = env.get<Duration>(EnvVariable.GENERIC_CONFIG_CACHE_DURATION);

  return ConfigRepository(
    dio: ref.watch(dioProvider),
    ionOrigin: origin,
    defaultCacheMaxAge: cacheMaxAge,
    localStorage: await ref.watch(localStorageAsyncProvider.future),
  );
}
