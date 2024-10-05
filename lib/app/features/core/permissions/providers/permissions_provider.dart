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
PermissionStrategy permissionStrategy(PermissionStrategyRef ref, AppPermissionType type) {
  final factory = ref.read(platformFactoryProvider);

  return factory.createPermission(type);
}

@Riverpod(keepAlive: true)
class Permissions extends _$Permissions {
  @override
  PermissionsState build() => const PermissionsState();

  Future<void> requestPermission(AppPermissionType type) async {
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

@riverpod
AppPermissionStatus permissionStatus(PermissionStatusRef ref, AppPermissionType permissionType) {
  return ref.watch(
    permissionsProvider.select(
      (state) => state.permissions[permissionType] ?? AppPermissionStatus.unknown,
    ),
  );
}

@riverpod
bool hasPermission(HasPermissionRef ref, AppPermissionType permissionType) {
  final permissionStatus = ref.watch(permissionStatusProvider(permissionType));

  return permissionStatus == AppPermissionStatus.granted ||
      permissionStatus == AppPermissionStatus.limited;
}

@riverpod
bool isPermanentlyDenied(IsPermanentlyDeniedRef ref, AppPermissionType permissionType) {
  final permissionStatus = ref.watch(permissionStatusProvider(permissionType));

  return permissionStatus == AppPermissionStatus.permanentlyDenied;
}
