// SPDX-License-Identifier: ice License 1.0

import 'package:ice/app/features/core/permissions/data/models/permissions_types.dart';
import 'package:ice/app/features/core/permissions/strategies/permission_strategy.dart';

class UnsupportedPermissionStrategy implements PermissionStrategy {
  @override
  Future<PermissionStatus> checkPermission() async {
    return Future.value(PermissionStatus.notAvailable);
  }

  @override
  Future<PermissionStatus> requestPermission() async {
    return Future.value(PermissionStatus.notAvailable);
  }

  @override
  Future<void>? openSettings() => null;
}
