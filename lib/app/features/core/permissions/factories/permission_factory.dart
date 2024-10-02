// SPDX-License-Identifier: ice License 1.0

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:ice/app/features/core/permissions/data/models/permissions_types.dart';
import 'package:ice/app/features/core/permissions/factories/platform_specific_factories.dart';
import 'package:ice/app/features/core/permissions/strategies/permission_strategy.dart';

abstract class PlatformPermissionFactory {
  factory PlatformPermissionFactory.forPlatform() {
    if (kIsWeb) {
      return WebPermissionFactory();
    } else if (Platform.isAndroid || Platform.isIOS) {
      return MobilePermissionFactory();
    } else {
      return DesktopPermissionFactory();
    }
  }

  PermissionStrategy createPermission(AppPermissionType type);
}
