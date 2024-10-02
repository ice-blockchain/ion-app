// SPDX-License-Identifier: ice License 1.0

import 'package:ice/app/features/core/permissions/strategies/base_permission_strategy.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationsPermissionStrategy extends BasePermissionStrategy {
  @override
  Permission get permission => Permission.notification;
}
