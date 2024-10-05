// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:ice/app/features/core/permissions/strategies/base_permission_strategy.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactsPermissionStrategy extends BasePermissionStrategy {
  @override
  Future<Permission> get permission async => Future.value(Permission.contacts);
}
