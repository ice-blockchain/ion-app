// SPDX-License-Identifier: ice License 1.0

// ignore_for_file: constant_identifier_names

import 'package:ice/app/features/core/permissions/data/models/models.dart';
import 'package:ice/app/features/core/permissions/factories/permission_factory.dart';
import 'package:ice/app/features/core/permissions/strategies/strategies.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'permissions_provider.g.dart';

@riverpod
PlatformPermissionFactory platformFactory(PlatformFactoryRef ref) {
  return PlatformPermissionFactory.forPlatform();
}

@riverpod
PermissionStrategy permissionStrategy(PermissionStrategyRef ref, AppPermissionType type) {
  final factory = ref.read(platformFactoryProvider);

  return factory.createPermission(type);
}

@Riverpod(keepAlive: true)
class Permissions extends _$Permissions {
  @override
  PermissionsState build() => const PermissionsState();

  AppPermissionStatus getPermissionStatus(AppPermissionType type) {
    return state.permissions[type] ?? AppPermissionStatus.unknown;
  }

  bool isPermanentlyDenied(AppPermissionType type) {
    return getPermissionStatus(type) == AppPermissionStatus.permanentlyDenied;
  }

  bool hasPermission(AppPermissionType type) {
    final status = getPermissionStatus(type);

    return status == AppPermissionStatus.granted || status == AppPermissionStatus.limited;
  }

  Future<void> openSettings(AppPermissionType type) async {
    final permissionStrategy = ref.read(permissionStrategyProvider(type));

    await permissionStrategy.openSettings();
  }

  Future<void> requestPermission(AppPermissionType type) async {
    final permissionStrategy = ref.read(permissionStrategyProvider(type));

    final status = await permissionStrategy.requestPermission();

    state = PermissionsState(
      permissions: {
        ...state.permissions,
        type: status,
      },
    );

    if (status == AppPermissionStatus.permanentlyDenied) {
      await permissionStrategy.openSettings();
    }
  }

  Future<void> checkAllPermissions() async {
    await Future.wait(
      AppPermissionType.values.map(checkPermission),
    );
  }

  Future<void> checkPermission(AppPermissionType type) async {
    final permissionStrategy = ref.read(permissionStrategyProvider(type));

    final status = await permissionStrategy.checkPermission();

    state = PermissionsState(
      permissions: {
        ...state.permissions,
        type: status,
      },
    );
  }
}
