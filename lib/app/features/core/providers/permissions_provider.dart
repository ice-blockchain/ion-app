// SPDX-License-Identifier: ice License 1.0

// ignore_for_file: constant_identifier_names

import 'package:permission_handler/permission_handler.dart';
import 'package:ice/app/features/core/permissions/data/models/models.dart';
import 'package:ice/app/features/core/permissions/factories/permission_factory.dart';
import 'package:ice/app/features/core/permissions/strategies/strategies.dart';
import 'package:mutex/mutex.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'permissions_provider.g.dart';

@riverpod
Mutex mutex(MutexRef ref) {
  return Mutex();
}

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
  AsyncValue<PermissionsState> build() => const AsyncValue.data(PermissionsState());

  AppPermissionStatus getPermissionStatus(AppPermissionType type) {
    return state.value?.permissions[type] ?? AppPermissionStatus.unknown;
  }

  bool hasPermission(AppPermissionType type) {
    final status = getPermissionStatus(type);

    return status == AppPermissionStatus.granted || status == AppPermissionStatus.limited;
  }

  Future<bool> checkAndRequestPermission(AppPermissionType type) async {
    await checkPermission(type);

    if (hasPermission(type)) return true;

    await requestPermission(type);

    return hasPermission(type);
  }

  Future<void> requestPermission(AppPermissionType type) async {
    final mutex = ref.read(mutexProvider);

    await mutex.protect(() async {
      if (hasPermission(type)) return;

      final permissionStrategy = ref.read(permissionStrategyProvider(type));

      state = await AsyncValue.guard(() async {
        final status = await permissionStrategy.requestPermission();
        final currentPermissions = state.value?.permissions ?? {};

        return PermissionsState(
          permissions: {
            ...currentPermissions,
            type: status,
          },
        );
      });
    });
  }

  Future<void> checkAllPermissions() async {
    await Future.wait(
      AppPermissionType.values.map(checkPermission),
    );
  }

  Future<void> checkPermission(AppPermissionType type) async {
    final permissionStrategy = ref.read(permissionStrategyProvider(type));

    state = await AsyncValue.guard(() async {
      final status = await permissionStrategy.checkPermission();
      final currentPermissions = state.value?.permissions ?? {};

      return PermissionsState(
        permissions: {
          ...currentPermissions,
          type: status,
        },
      );
    });
  }
}
