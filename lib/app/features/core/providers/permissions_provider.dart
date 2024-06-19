// ignore_for_file: constant_identifier_names

import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'permissions_provider.g.dart';

enum PermissionType { Contacts }

@Riverpod(keepAlive: true)
class Permissions extends _$Permissions {
  @override
  Map<PermissionType, bool> build() {
    return Map<PermissionType, bool>.unmodifiable(<PermissionType, bool>{});
  }

  Future<void> checkAllPermissions() async {
    final permissions = <PermissionType, bool>{};
    final contactsPermissionStatus = await Permission.contacts.status;
    permissions.putIfAbsent(
      PermissionType.Contacts,
      () => contactsPermissionStatus == PermissionStatus.granted,
    );
    state = Map<PermissionType, bool>.unmodifiable(permissions);
  }

  Future<void> requestContactsPermission() async {
    await Permission.contacts.request();
    // hardcode always as granted for now
    const newIsGranted = true;
    final newState = Map<PermissionType, bool>.from(state)
      ..update(
        PermissionType.Contacts,
        (_) => newIsGranted,
        ifAbsent: () => newIsGranted,
      );
    state = Map<PermissionType, bool>.unmodifiable(newState);
  }
}
