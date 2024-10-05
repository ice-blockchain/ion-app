// SPDX-License-Identifier: ice License 1.0

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
PermissionStrategy permissionStrategy(PermissionStrategyRef ref, Permission type) {
  final factory = ref.read(platformFactoryProvider);

  return factory.createPermission(type);
}

@Riverpod(keepAlive: true)
class Permissions extends _$Permissions {
  @override
  PermissionsState build() => const PermissionsState();

  Future<void> requestPermission(Permission type) async {
    final permissionStrategy = ref.read(permissionStrategyProvider(type));

    final status = await permissionStrategy.requestPermission();

    state = PermissionsState(
      permissions: {
        ...state.permissions,
        type: status,
      },
    );
  }

  Future<void> checkAllPermissions() async {
    await Future.wait(
      Permission.values.map(checkPermission),
    );
  }

  Future<void> checkPermission(Permission type) async {
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

@riverpod
PermissionStatus permissionStatus(PermissionStatusRef ref, Permission permissionType) {
  return ref.watch(
    permissionsProvider.select(
      (state) => state.permissions[permissionType] ?? PermissionStatus.unknown,
    ),
  );
}

@riverpod
bool hasPermission(HasPermissionRef ref, Permission permissionType) {
  final permissionStatus = ref.watch(permissionStatusProvider(permissionType));

  return permissionStatus == PermissionStatus.granted ||
      permissionStatus == PermissionStatus.limited;
}

@riverpod
bool isPermanentlyDenied(IsPermanentlyDeniedRef ref, Permission permissionType) {
  final permissionStatus = ref.watch(permissionStatusProvider(permissionType));

  return permissionStatus == PermissionStatus.permanentlyDenied;
}
