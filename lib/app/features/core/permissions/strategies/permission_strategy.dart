// SPDX-License-Identifier: ice License 1.0

import 'package:ice/app/features/core/permissions/data/models/permissions_types.dart';

abstract class PermissionStrategy {
  Future<AppPermissionStatus> checkPermission();
  Future<AppPermissionStatus> requestPermission();
  Future<void>? openSettings();
}
