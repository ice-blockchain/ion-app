// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:ice/app/features/core/permissions/strategies/strategies.dart';
import 'package:permission_handler/permission_handler.dart';

class IosGalleryPermissionStrategy extends BasePermissionStrategy {
  @override
  Future<Permission> get permission async => Future.value(Permission.photos);
}

class AndroidGalleryPermissionStrategy extends BasePermissionStrategy {
  @override
  Future<Permission> get permission async {
    final androidInfo = await DeviceInfoPlugin().androidInfo;

    /// **Android:**
    /// - Devices running Android 12 (API level 32) or lower: use [Permissions.storage].
    /// - Devices running Android 13 (API level 33) and above: Should use [Permissions.photos].
    ///
    /// in Manifest:
    /// <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" android:maxSdkVersion="32"/>
    /// <uses-permission android:name="android.permission.READ_MEDIA_IMAGES"/>
    return androidInfo.version.sdkInt <= 32 ? Permission.storage : Permission.photos;
  }
}
