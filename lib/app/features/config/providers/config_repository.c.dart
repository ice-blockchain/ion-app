// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/config/data/models/app_config_cache_strategy.dart';
import 'package:ion/app/features/config/data/models/app_config_with_version.dart';
import 'package:ion/app/features/core/providers/dio_provider.c.dart';
import 'package:ion/app/features/core/providers/env_provider.c.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:ion/app/services/storage/local_storage.c.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:synchronized/synchronized.dart';

part 'config_repository.c.g.dart';

class ConfigRepository {
  ConfigRepository({
    required Dio dio,
    required String ionOrigin,
    required LocalStorage localStorage,
  })  : _dio = dio,
        _ionOrigin = ionOrigin,
        _localStorage = localStorage;

  final Dio _dio;
  final String _ionOrigin;
  final LocalStorage _localStorage;

  // Lock map to prevent concurrent access per configName
  final Map<String, Lock> _locks = {};

  Future<T> getConfig<T>(
    String configName, {
    required AppConfigCacheStrategy cacheStrategy,
    required int refreshInterval,
    required T Function(String) parser,
    bool checkVersion = false,
  }) async {
    final lock = _locks.putIfAbsent(configName, Lock.new);
    return lock.synchronized(() async {
      final cachedData = await _getFromCache(configName, cacheStrategy, refreshInterval, parser);
      if (cachedData != null) {
        return cachedData;
      }

      final configData = await _getFromNetwork<T>(configName, parser, checkVersion) ?? cachedData;
      if (configData == null) {
        if (refreshInterval < 0) {
          throw AppConfigNotFoundException(configName);
        }
        return getConfig<T>(
          configName,
          cacheStrategy: cacheStrategy,
          refreshInterval: -1,
          parser: parser,
          checkVersion: checkVersion,
        );
      }
      await _saveToCache(configName, configData, cacheStrategy);
      return configData;
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
    int refreshInterval,
    T Function(String) parser,
  ) async {
    try {
      if (cacheStrategy == AppConfigCacheStrategy.localStorage) {
        final lastSyncDate = _localStorage.getString(getSyncDateKey(configName));
        final cacheAvailable = refreshInterval < 0 ||
            (lastSyncDate != null &&
                DateTime.now().difference(DateTime.parse(lastSyncDate)).inMilliseconds <
                    refreshInterval);

        if (!cacheAvailable) return null;

        return parser(_localStorage.getString(getDataKey(configName))!);
      } else {
        final cacheFile = File(await _getCacheFilePath(configName));
        if (cacheFile.existsSync()) {
          final cacheDuration = DateTime.now().difference(cacheFile.lastModifiedSync());
          if (refreshInterval < 0 || cacheDuration < Duration(milliseconds: refreshInterval)) {
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

  Future<void> _saveToCache<T>(
    String configName,
    T data,
    AppConfigCacheStrategy cacheStrategy,
  ) async {
    final isString = data is String;

    try {
      if (cacheStrategy == AppConfigCacheStrategy.localStorage) {
        await Future.wait([
          _localStorage.setString(getSyncDateKey(configName), DateTime.now().toIso8601String()),
          _localStorage.setString(
            getDataKey(configName),
            isString ? data : jsonEncode(data),
          ),
        ]);
      } else {
        final cacheFile = File(await _getCacheFilePath(configName));
        await cacheFile.writeAsString(isString ? data : jsonEncode(data));
        await cacheFile.setLastModified(DateTime.now());
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

  String getCacheFileName(String configName) => '$configName.json';

  String getCacheVersionKey(String configName) => '$configName:cache_version';

  String getSyncDateKey(String configName) => '$configName:syncDate';

  String getDataKey(String configName) => '$configName:data';
}

@Riverpod(keepAlive: true)
Future<ConfigRepository> configRepository(Ref ref) async {
  return ConfigRepository(
    dio: ref.watch(dioProvider),
    ionOrigin: ref.watch(envProvider.notifier).get<String>(EnvVariable.ION_ORIGIN),
    localStorage: await ref.watch(localStorageAsyncProvider.future),
  );
}
