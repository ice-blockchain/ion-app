import 'dart:async';

import 'package:ice/app/features/core/permissions/data/models/permissions_types.dart';
import 'package:ice/app/features/core/permissions/strategies/permission_strategy.dart';
import 'package:permission_handler/permission_handler.dart' as ph;

abstract class BasePermissionStrategy implements PermissionStrategy {
  Future<ph.Permission> get permission;

  @override
  Future<void> openSettings() async => ph.openAppSettings();

  @override
  Future<PermissionStatus> checkPermission() async {
    final perm = await permission;
    final status = await perm.status;

    return _mapToAppPermission(status);
  }

  @override
  Future<PermissionStatus> requestPermission() async {
    final perm = await permission;
    final status = await perm.request();

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
}
