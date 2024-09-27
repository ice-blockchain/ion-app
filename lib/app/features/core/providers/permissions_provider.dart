// ignore_for_file: constant_identifier_names

import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'permissions_provider.g.dart';

enum PermissionType { Contacts, Notifications }

typedef PermissionCallback = void Function();

@Riverpod(keepAlive: true)
class Permissions extends _$Permissions {
  @override
  Map<PermissionType, PermissionStatus> build() {
    return Map<PermissionType, PermissionStatus>.unmodifiable(
      <PermissionType, PermissionStatus>{},
    );
  }

  Future<void> checkAllPermissions() async {
    final permissions = <PermissionType, PermissionStatus>{};
    try {
      final contactsPermissionStatus = await Permission.contacts.status;
      final notificationsPermissionStatus = await Permission.notification.status;
      permissions
        ..putIfAbsent(
          PermissionType.Notifications,
          () => notificationsPermissionStatus,
        )
        ..putIfAbsent(
          PermissionType.Contacts,
          () => contactsPermissionStatus,
        );
    } finally {
      state = Map<PermissionType, PermissionStatus>.unmodifiable(permissions);
    }
  }

  Future<PermissionStatus> requestPermission(
    PermissionType permissionType,
  ) async {
    late final permission = switch (permissionType) {
      PermissionType.Contacts => Permission.contacts,
      PermissionType.Notifications => Permission.notification,
    };

    final permissionStatus = await permission.request();

    final newState = Map<PermissionType, PermissionStatus>.from(state)
      ..update(
        permissionType,
        (_) => permissionStatus,
        ifAbsent: () => permissionStatus,
      );
    state = Map<PermissionType, PermissionStatus>.unmodifiable(newState);

    return permissionStatus;
  }
}

@riverpod
bool hasPermissionSelector(HasPermissionSelectorRef ref, PermissionType permissionType) {
  return ref.watch(
    permissionsProvider.select(
      (permissions) => permissions[permissionType] == PermissionStatus.granted,
    ),
  );
}
