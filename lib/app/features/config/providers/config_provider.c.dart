// SPDX-License-Identifier: ice License 1.0

import 'dart:io';

import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/core/providers/dio_provider.c.dart';
import 'package:ion/app/features/core/providers/env_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'config_provider.c.g.dart';

@riverpod
class ConfigNotifier extends _$ConfigNotifier {
  @override
  FutureOr<void> build() {}

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

  Future<Map<String, dynamic>> fetchConfigForCurrentPlatform() async {
    final configName = _getPlatformConfigName();
    final path = '${EnvVariable.ION_ORIGIN}/v1/config/$configName';

    final dio = ref.read(dioProvider);
    final response = await dio.get<Map<String, dynamic>>(path);

    return response.data!;
  }
}

enum ConfigName {
  requiredAndroidAppVersion,
  requiredIosAppVersion,
  requiredMacosAppVersion,
  requiredWindowsAppVersion,
  requiredLinuxAppVersion;

  @override
  String toString() {
    switch (this) {
      case ConfigName.requiredAndroidAppVersion:
        return 'required_android_app_version';
      case ConfigName.requiredIosAppVersion:
        return 'required_ios_app_version';
      case ConfigName.requiredMacosAppVersion:
        return 'required_macos_app_version';
      case ConfigName.requiredWindowsAppVersion:
        return 'required_windows_app_version';
      case ConfigName.requiredLinuxAppVersion:
        return 'required_linux_app_version';
    }
  }
}
