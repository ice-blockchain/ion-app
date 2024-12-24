// SPDX-License-Identifier: ice License 1.0

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/core/providers/dio_provider.c.dart';
import 'package:ion/app/features/core/providers/env_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'config_provider.c.g.dart';

@riverpod
ConfigService configService(Ref ref) => ConfigService(ref.watch(dioProvider));

class ConfigService {
  ConfigService(this.dio);
  final Dio dio;

  ConfigName _getPlatformConfigName() {
    if (Platform.isAndroid) {
      return ConfigName.requiredAndroidAppVersion;
    } else if (Platform.isIOS) {
      return ConfigName.requiredIosAppVersion;
    } else if (Platform.isMacOS) {
      return ConfigName.requiredMacosAppVersion;
    } else if (Platform.isWindows) {
      return ConfigName.requiredWindowsAppVersion;
    } else if (Platform.isLinux) {
      return ConfigName.requiredLinuxAppVersion;
    } else {
      throw ConfigPlatformNotSupportException();
    }
  }

  Future<String> fetchConfigForCurrentPlatform() async {
    final configName = _getPlatformConfigName();

    const baseUrl = EnvVariable.ION_ORIGIN;
    final path = '$baseUrl/v1/config/$configName';

    try {
      final response = await dio.get<String>(path);
      if (response.data == null) {
        throw ForceUpdateFetchConfigException();
      }
      return response.data!;
    } catch (e) {
      throw ForceUpdateFetchConfigException();
    }
  }
}

enum ConfigName {
  requiredAndroidAppVersion,
  requiredIosAppVersion,
  requiredMacosAppVersion,
  requiredWindowsAppVersion,
  requiredLinuxAppVersion;

  @override
  String toString() => switch (this) {
        ConfigName.requiredAndroidAppVersion => 'required_android_app_version',
        ConfigName.requiredIosAppVersion => 'required_ios_app_version',
        ConfigName.requiredMacosAppVersion => 'required_macos_app_version',
        ConfigName.requiredWindowsAppVersion => 'required_windows_app_version',
        ConfigName.requiredLinuxAppVersion => 'required_linux_app_version',
      };
}
