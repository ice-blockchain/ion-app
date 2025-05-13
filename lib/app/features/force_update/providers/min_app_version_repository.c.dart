// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/core/providers/dio_provider.c.dart';
import 'package:ion/app/features/core/providers/env_provider.c.dart';
import 'package:ion/app/services/storage/local_storage.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'min_app_version_repository.c.g.dart';

enum MinAppVersionConfigName {
  requiredAndroidAppVersion,
  requiredIosAppVersion,
  requiredMacosAppVersion,
  requiredWindowsAppVersion,
  requiredLinuxAppVersion;

  factory MinAppVersionConfigName.fromPlatform() {
    if (Platform.isAndroid) return MinAppVersionConfigName.requiredAndroidAppVersion;
    if (Platform.isIOS) return MinAppVersionConfigName.requiredIosAppVersion;
    if (Platform.isMacOS) return MinAppVersionConfigName.requiredMacosAppVersion;
    if (Platform.isWindows) return MinAppVersionConfigName.requiredWindowsAppVersion;
    if (Platform.isLinux) return MinAppVersionConfigName.requiredLinuxAppVersion;

    throw UnsupportedError('Unsupported platform: ${Platform.operatingSystem}');
  }

  @override
  String toString() => switch (this) {
        MinAppVersionConfigName.requiredAndroidAppVersion => 'required_android_app_version',
        MinAppVersionConfigName.requiredIosAppVersion => 'required_ios_app_version',
        MinAppVersionConfigName.requiredMacosAppVersion => 'required_macos_app_version',
        MinAppVersionConfigName.requiredWindowsAppVersion => 'required_windows_app_version',
        MinAppVersionConfigName.requiredLinuxAppVersion => 'required_linux_app_version',
      };
}

@Riverpod(keepAlive: true)
Future<MinAppVersionRepository> minAppVersionRepository(Ref ref) async {
  return MinAppVersionRepository(
    dio: ref.watch(dioProvider),
    refreshInterval:
        ref.watch(envProvider.notifier).get<int>(EnvVariable.VERSIONS_CONFIG_REFETCH_INTERVAL),
    ionOrigin: ref.watch(envProvider.notifier).get<String>(EnvVariable.ION_ORIGIN),
    localStorage: await ref.watch(localStorageAsyncProvider.future),
  );
}

class MinAppVersionRepository {
  MinAppVersionRepository({
    required Dio dio,
    required int refreshInterval,
    required String ionOrigin,
    required LocalStorage localStorage,
  })  : _dio = dio,
        _refreshInterval = refreshInterval,
        _ionOrigin = ionOrigin,
        _localStorage = localStorage;

  final Dio _dio;
  final int _refreshInterval;
  final String _ionOrigin;
  final LocalStorage _localStorage;

  static const String _lastSyncDateKey = 'MinSupportedAppVersion:syncDate';
  static const String _minSupportedAppVersionKey = 'MinSupportedAppVersion:version';

  Future<String> getMinVersion() async {
    final cachedVersion = _getFromCache();
    if (cachedVersion != null) {
      return cachedVersion;
    }

    final version = await _getFromNetwork();
    await _saveToCache(version);
    return version;
  }

  Future<String> _getFromNetwork() async {
    final configName = MinAppVersionConfigName.fromPlatform();
    try {
      final uri = Uri.parse(_ionOrigin).replace(path: '/v1/config/$configName');
      final response = await _dio.get<String>(uri.toString());
      return jsonDecode(response.data!) as String;
    } catch (error) {
      throw ForceUpdateFetchConfigException(error);
    }
  }

  String? _getFromCache() {
    final lastSyncDate = _localStorage.getString(_lastSyncDateKey);
    final cacheAvailable = lastSyncDate != null &&
        DateTime.now().difference(DateTime.parse(lastSyncDate)).inMilliseconds < _refreshInterval;

    if (!cacheAvailable) {
      return null;
    }

    return _localStorage.getString(_minSupportedAppVersionKey);
  }

  Future<void> _saveToCache(String version) async {
    await Future.wait([
      _localStorage.setString(_lastSyncDateKey, DateTime.now().toIso8601String()),
      _localStorage.setString(_minSupportedAppVersionKey, version),
    ]);
  }
}
