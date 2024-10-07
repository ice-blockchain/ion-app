// SPDX-License-Identifier: ice License 1.0

import 'dart:async';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:ice/app/features/core/permissions/data/models/permissions_types.dart';
import 'package:ice/app/features/core/permissions/strategies/permission_strategy.dart';
import 'package:permission_handler/permission_handler.dart' as ph;

/// A base class responsible for handling permissions using the `permission_handler` package.
///
/// This class provides logic for requesting and checking permissions on platforms
/// where `permission_handler` is applicable. For platform-specific logic not covered by `permission_handler`,
/// a different implementation of [PermissionStrategy] can be used.
class PermissionHandlerStrategy extends PermissionStrategy {
  PermissionHandlerStrategy(this.permissionType);

  final Permission permissionType;

  @override
  Future<void> openSettings() async => ph.openAppSettings();

  @override
  Future<PermissionStatus> checkPermission() async {
    final permission = await _getPermission();
    final status = await permission.status;

    return _mapToAppPermission(status);
  }

  @override
  Future<PermissionStatus> requestPermission() async {
    final permission = await _getPermission();
    final status = await permission.request();

    return _mapToAppPermission(status);
  }

  PermissionStatus _mapToAppPermission(ph.PermissionStatus status) => switch (status) {
        ph.PermissionStatus.granted => PermissionStatus.granted,
        ph.PermissionStatus.denied => PermissionStatus.denied,
        ph.PermissionStatus.restricted => PermissionStatus.restricted,
        ph.PermissionStatus.limited => PermissionStatus.limited,
        ph.PermissionStatus.permanentlyDenied => PermissionStatus.permanentlyDenied,
        ph.PermissionStatus.provisional => PermissionStatus.provisional,
      };

  Future<ph.Permission> _getPermission() async {
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;

      return androidInfo.version.sdkInt <= 32 ? ph.Permission.storage : ph.Permission.photos;
    }

    final permission = switch (permissionType) {
      Permission.camera => ph.Permission.camera,
      Permission.contacts => ph.Permission.contacts,
      Permission.notifications => ph.Permission.notification,
      Permission.photos => ph.Permission.photos
    };

    return Future.value(permission);
  }
}
