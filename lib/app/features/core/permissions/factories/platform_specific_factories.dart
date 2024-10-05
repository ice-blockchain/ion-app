// SPDX-License-Identifier: ice License 1.0

import 'dart:io';

import 'package:ice/app/features/core/permissions/data/models/permissions_types.dart';
import 'package:ice/app/features/core/permissions/factories/permission_factory.dart';
import 'package:ice/app/features/core/permissions/strategies/strategies.dart';

class MobilePermissionFactory implements PlatformPermissionFactory {
  @override
  PermissionStrategy createPermission(Permission type) {
    return switch (type) {
      Permission.camera => CameraPermissionStrategy(),
      Permission.photos =>
        Platform.isAndroid ? AndroidGalleryPermissionStrategy() : IosGalleryPermissionStrategy(),
      Permission.contacts => ContactsPermissionStrategy(),
      Permission.notifications => NotificationsPermissionStrategy()
    };
  }
}

class DesktopPermissionFactory implements PlatformPermissionFactory {
  @override
  PermissionStrategy createPermission(Permission type) {
    return switch (type) {
      Permission.camera => CameraPermissionStrategy(),
      Permission.photos => UnsupportedPermissionStrategy(),
      Permission.contacts => ContactsPermissionStrategy(),
      Permission.notifications => NotificationsPermissionStrategy()
    };
  }
}

class WebPermissionFactory implements PlatformPermissionFactory {
  @override
  PermissionStrategy createPermission(Permission type) {
    return type == Permission.camera ? CameraPermissionStrategy() : UnsupportedPermissionStrategy();
  }
}
