// SPDX-License-Identifier: ice License 1.0

import 'package:ice/app/features/core/permissions/data/models/permissions_types.dart';
import 'package:ice/app/features/core/permissions/factories/permission_factory.dart';
import 'package:ice/app/features/core/permissions/strategies/strategies.dart';

class MobilePermissionFactory implements PlatformPermissionFactory {
  @override
  PermissionStrategy createPermission(AppPermissionType type) {
    return switch (type) {
      AppPermissionType.camera => CameraPermissionStrategy(),
      AppPermissionType.photos => MobileGalleryPermissionStrategy(),
      AppPermissionType.contacts => ContactsPermissionStrategy(),
      AppPermissionType.notifications => NotificationsPermissionStrategy()
    };
  }
}

class DesktopPermissionFactory implements PlatformPermissionFactory {
  @override
  PermissionStrategy createPermission(AppPermissionType type) {
    return switch (type) {
      AppPermissionType.camera => CameraPermissionStrategy(),
      AppPermissionType.photos => UnsupportedPermissionStrategy(),
      AppPermissionType.contacts => ContactsPermissionStrategy(),
      AppPermissionType.notifications => NotificationsPermissionStrategy()
    };
  }
}

class WebPermissionFactory implements PlatformPermissionFactory {
  @override
  PermissionStrategy createPermission(AppPermissionType type) {
    return type == AppPermissionType.camera
        ? CameraPermissionStrategy()
        : UnsupportedPermissionStrategy();
  }
}
