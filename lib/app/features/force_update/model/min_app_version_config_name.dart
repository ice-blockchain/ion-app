// SPDX-License-Identifier: ice License 1.0

import 'dart:io';

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
