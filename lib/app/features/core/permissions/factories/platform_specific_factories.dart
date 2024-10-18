// SPDX-License-Identifier: ice License 1.0

import 'dart:io';

import 'package:ion/app/features/core/permissions/data/models/permissions_types.dart';
import 'package:ion/app/features/core/permissions/factories/permission_factory.dart';
import 'package:ion/app/features/core/permissions/strategies/strategies.dart';

class MobilePermissionFactory implements PlatformPermissionFactory {
  @override
  PermissionStrategy createPermission(Permission type) => PermissionHandlerStrategy(type);
}

class DesktopPermissionFactory implements PlatformPermissionFactory {
  @override
  PermissionStrategy createPermission(Permission type) {
    if (Platform.isMacOS || Platform.isLinux) {
      return UnsupportedPermissionStrategy();
    }

    if (type == Permission.photos) {
      return UnsupportedPermissionStrategy();
    }

    return PermissionHandlerStrategy(type);
  }
}

class WebPermissionFactory implements PlatformPermissionFactory {
  @override
  PermissionStrategy createPermission(Permission type) {
    return type == Permission.camera
        ? PermissionHandlerStrategy(type)
        : UnsupportedPermissionStrategy();
  }
}
