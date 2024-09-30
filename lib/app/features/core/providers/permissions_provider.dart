// ignore_for_file: constant_identifier_names

import 'package:ice/app/services/permissions_service/permissions_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'permissions_provider.g.dart';

@Riverpod(keepAlive: true)
class Permissions extends _$Permissions {
  @override
  Map<Permission, PermissionStatus> build() {
    return {};
  }

  Future<void> checkAllPermissions() async {
    final permissionsService = ref.read(permissionsServiceProvider);
    final permissions = <Permission, PermissionStatus>{};
    await Future.wait(
      Permission.values.map((permission) async {
        permissions[permission] = await permissionsService.check(permission);
      }),
    );
    state = permissions;
  }

  Future<PermissionStatus> request(Permission permission) async {
    final permissionsService = ref.read(permissionsServiceProvider);
    return permissionsService.request(permission);
  }
}

@riverpod
bool hasPermissionSelector(HasPermissionSelectorRef ref, Permission permission) {
  return ref.watch(
    permissionsProvider.select(
      (permissions) => permissions[permission] == PermissionStatus.granted,
    ),
  );
}
