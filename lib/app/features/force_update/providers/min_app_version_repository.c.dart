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
import 'package:shared_preferences/shared_preferences.dart';

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
  final prefs = await ref.watch(sharedPreferencesProvider.future);
  return MinAppVersionRepository(
    dio: ref.watch(dioProvider),
    refreshInterval:
        ref.watch(envProvider.notifier).get<int>(EnvVariable.VERSIONS_CONFIG_REFETCH_INTERVAL),
    ionOrigin: ref.watch(envProvider.notifier).get<String>(EnvVariable.ION_ORIGIN),
    prefs: prefs,
  );
}

class MinAppVersionRepository {
  MinAppVersionRepository({
    required Dio dio,
    required int refreshInterval,
    required String ionOrigin,
    required SharedPreferences prefs,
  })  : _dio = dio,
        _refreshInterval = refreshInterval,
        _ionOrigin = ionOrigin,
        _prefs = prefs;

  final Dio _dio;
  final int _refreshInterval;
  final String _ionOrigin;
  final SharedPreferences _prefs;

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
    final path = '$_ionOrigin/v1/config/$configName';
    try {
      final response = await _dio.get<String>(path);
      return jsonDecode(response.data!) as String;
    } catch (error) {
      throw ForceUpdateFetchConfigException(error);
    }
  }

  String? _getFromCache() {
    final lastSyncDate = _prefs.getString(_lastSyncDateKey);
    final cacheAvailable = lastSyncDate != null &&
        DateTime.now().difference(DateTime.parse(lastSyncDate)).inMilliseconds < _refreshInterval;

    if (!cacheAvailable) {
      return null;
    }

    return _prefs.getString(_minSupportedAppVersionKey);
  }

  Future<bool> _saveToCache(String version) {
    return _prefs.setString(_minSupportedAppVersionKey, version);
  }
}
