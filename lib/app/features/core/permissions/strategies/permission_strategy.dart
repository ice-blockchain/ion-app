// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/core/permissions/data/models/permissions_types.dart';

abstract class PermissionStrategy {
  Future<PermissionStatus> checkPermission();
  Future<PermissionStatus> requestPermission();
  Future<void>? openSettings();
}
