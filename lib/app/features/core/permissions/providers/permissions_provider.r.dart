// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/core/permissions/data/models/models.dart';
import 'package:ion/app/features/core/permissions/factories/permission_factory.dart';
import 'package:ion/app/features/core/permissions/strategies/strategies.dart';
import 'package:meta/meta.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'permissions_provider.r.g.dart';

@riverpod
PlatformPermissionFactory platformFactory(Ref ref) {
  return PlatformPermissionFactory.forPlatform();
}

@riverpod
PermissionStrategy permissionStrategy(Ref ref, Permission type) {
  final factory = ref.watch(platformFactoryProvider);

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
PermissionStatus permissionStatus(Ref ref, Permission permissionType) {
  return ref.watch(
    permissionsProvider.select(
      (state) => state.permissions[permissionType] ?? PermissionStatus.unknown,
    ),
  );
}

@riverpod
bool hasPermission(Ref ref, Permission permissionType) {
  final permissionStatus = ref.watch(permissionStatusProvider(permissionType));

  return permissionStatus == PermissionStatus.granted ||
      permissionStatus == PermissionStatus.limited;
}

@riverpod
bool hasLimitedPermission(Ref ref, Permission permissionType) {
  final permissionStatus = ref.watch(permissionStatusProvider(permissionType));

  return permissionStatus == PermissionStatus.limited;
}

@riverpod
bool isPermanentlyDenied(Ref ref, Permission permissionType) {
  final permissionStatus = ref.watch(permissionStatusProvider(permissionType));

  return permissionStatus == PermissionStatus.permanentlyDenied;
}

@riverpod
class ActivePermissionRequestId extends _$ActivePermissionRequestId {
  @override
  String? build(String compositeKey) => null;

  set requestId(String? value) {
    state = value;
  }
}
